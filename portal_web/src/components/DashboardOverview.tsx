import React, { useState, useEffect } from 'react';
import {
  doc,
  collection,
  query,
  orderBy,
  onSnapshot,
  updateDoc,
  serverTimestamp,
} from 'firebase/firestore';
import { db } from '../config/firebase';
import { monthLabel, recentMonthKeys } from '../config/period';
import { PintigIcon } from './PintigIcons';

interface AggregateMetrics {
  total_encounters: number;
  high_risk_alerts_count: number;
  maternal_total: number;
  maternal_high_risk: number;
  immunization_total: number;
  nutrition_opt_total: number;
  nutrition_severely_wasted: number;
  nutrition_moderately_stunted: number;
}

interface TriageAlert {
  id: string;
  alert_uuid: string;
  encounter_uuid: string;
  patient_uuid: string;
  patient_name?: string;
  sitio_purok?: string;
  bhw_id: string;
  encounter_type: 'MATERNAL_CARE' | 'IMMUNIZATION' | 'NUTRITION_OPT';
  risk_level: 'HIGH' | 'MODERATE';
  status: 'PENDING' | 'ACKNOWLEDGED' | 'RESOLVED' | 'REFERRED';
  clinical_summary: string;
  triggered_at: string;
  resolution_notes?: string;
  resolved_by?: string;
  resolved_at?: { toDate: () => Date };
}

const TENANT_ID = 'ph_biliran_naval';
const BARANGAY_ID = 'brgy_pi_garcia';

interface DashboardOverviewProps {
  month: string; // YYYY-MM
  onMonthChange: (month: string) => void;
}

type StatusFilter = 'PENDING' | 'ACKNOWLEDGED' | 'REFERRED' | 'RESOLVED' | 'ALL';

const TYPE_LABEL: Record<TriageAlert['encounter_type'], string> = {
  MATERNAL_CARE: 'Prenatal visit',
  NUTRITION_OPT: 'Child weighing',
  IMMUNIZATION: 'Vaccination',
};

const STATUS_CHIP: Record<TriageAlert['status'], { label: string; cls: string }> = {
  PENDING: { label: 'Needs action', cls: 'bg-pintig-amber-tint text-pintig-amber-ink' },
  ACKNOWLEDGED: { label: 'Acknowledged', cls: 'bg-pintig-sea-tint text-pintig-sea-ink' },
  REFERRED: { label: 'Referred', cls: 'bg-pintig-ink text-white' },
  RESOLVED: { label: 'Closed', cls: 'bg-pintig-sea-tint text-pintig-sea-ink' },
};

function waiting(iso: string, now: number): string {
  const t = Date.parse(iso);
  if (Number.isNaN(t)) return '';
  const mins = Math.max(0, Math.floor((now - t) / 60000));
  if (mins < 1) return 'Just now';
  if (mins < 60) return `${mins} min`;
  const h = Math.floor(mins / 60);
  const m = mins % 60;
  if (h < 24) return m === 0 ? `${h} h` : `${h} h ${String(m).padStart(2, '0')} min`;
  const d = Math.floor(h / 24);
  return `${d} ${d === 1 ? 'day' : 'days'}`;
}

function whenLabel(iso: string): string {
  const d = new Date(iso);
  if (Number.isNaN(d.getTime())) return '';
  return d.toLocaleString([], { month: 'short', day: 'numeric', hour: 'numeric', minute: '2-digit' });
}

export const DashboardOverview: React.FC<DashboardOverviewProps> = ({ month, onMonthChange }) => {
  const [aggregates, setAggregates] = useState<AggregateMetrics>({
    total_encounters: 0,
    high_risk_alerts_count: 0,
    maternal_total: 0,
    maternal_high_risk: 0,
    immunization_total: 0,
    nutrition_opt_total: 0,
    nutrition_severely_wasted: 0,
    nutrition_moderately_stunted: 0,
  });
  const [encountersCount, setEncountersCount] = useState({
    total: 0,
    maternal: 0,
    opt: 0,
    immunization: 0,
  });
  const [alerts, setAlerts] = useState<TriageAlert[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [resolvingId, setResolvingId] = useState<string | null>(null);
  const [actionNotes, setActionNotes] = useState<Record<string, string>>({});
  const [filterStatus, setFilterStatus] = useState<StatusFilter>('PENDING');
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [confirmReferId, setConfirmReferId] = useState<string | null>(null);
  const [now, setNow] = useState<number>(Date.now());

  // Keep "waiting" times fresh
  useEffect(() => {
    const t = window.setInterval(() => setNow(Date.now()), 30000);
    return () => window.clearInterval(t);
  }, []);

  // Monthly aggregate document and this month's encounter counts
  useEffect(() => {
    const aggregateDocRef = doc(
      db,
      `tenants/${TENANT_ID}/barangays/${BARANGAY_ID}/aggregates/${month}`
    );

    setAggregates({
      total_encounters: 0,
      high_risk_alerts_count: 0,
      maternal_total: 0,
      maternal_high_risk: 0,
      immunization_total: 0,
      nutrition_opt_total: 0,
      nutrition_severely_wasted: 0,
      nutrition_moderately_stunted: 0,
    });

    const unsubscribeAggregate = onSnapshot(aggregateDocRef, (snapshot) => {
      if (snapshot.exists()) {
        const raw = snapshot.data() as Record<string, any>;
        const m = raw.metrics || raw;
        setAggregates({
          total_encounters: Number(m.total_encounters ?? 0),
          high_risk_alerts_count: Number(m.high_risk_alerts_count ?? m.active_triage_alerts ?? 0),
          maternal_total: Number(m.maternal_total ?? m.maternal_care_count ?? m.maternal_encounters ?? 0),
          maternal_high_risk: Number(m.maternal_high_risk ?? m.high_risk_maternal_count ?? m.high_risk_maternal ?? 0),
          immunization_total: Number(m.immunization_total ?? m.immunization_count ?? m.immunization_encounters ?? 0),
          nutrition_opt_total: Number(m.nutrition_opt_total ?? m.nutrition_opt_count ?? m.opt_encounters ?? 0),
          nutrition_severely_wasted: Number(m.nutrition_severely_wasted ?? m.severe_wasting_count ?? 0),
          nutrition_moderately_stunted: Number(m.nutrition_moderately_stunted ?? m.stunted_count ?? 0),
        });
      }
    });

    const encountersColRef = collection(
      db,
      `tenants/${TENANT_ID}/barangays/${BARANGAY_ID}/encounters`
    );
    const unsubscribeEncounters = onSnapshot(encountersColRef, (snapshot) => {
      let total = 0;
      let maternal = 0;
      let opt = 0;
      let epi = 0;
      snapshot.forEach((docSnap) => {
        const d = docSnap.data();
        // Count only the selected month (timestamps are ISO strings)
        if (!String(d.timestamp || '').startsWith(month)) return;
        total++;
        const type = String(d.encounter_type || '').toUpperCase();
        if (type.includes('MATERNAL')) maternal++;
        else if (type.includes('NUTRITION') || type.includes('OPT')) opt++;
        else if (type.includes('IMMUNIZATION') || type.includes('EPI')) epi++;
      });
      setEncountersCount({ total, maternal, opt, immunization: epi });
    });

    return () => {
      unsubscribeAggregate();
      unsubscribeEncounters();
    };
  }, [month]);

  // Real-time triage alert feed (all months: open cases must never be hidden)
  useEffect(() => {
    const alertsColRef = collection(
      db,
      `tenants/${TENANT_ID}/barangays/${BARANGAY_ID}/triage_alerts`
    );
    const alertsQuery = query(alertsColRef, orderBy('triggered_at', 'desc'));

    const unsubscribeAlerts = onSnapshot(alertsQuery, (snapshot) => {
      const alertList: TriageAlert[] = [];
      snapshot.forEach((docSnap) => {
        alertList.push({ id: docSnap.id, ...(docSnap.data() as Omit<TriageAlert, 'id'>) });
      });
      setAlerts(alertList);
      setLoading(false);
    });

    return () => unsubscribeAlerts();
  }, []);

  const handleUpdateAlertStatus = async (
    alertId: string,
    nextStatus: 'ACKNOWLEDGED' | 'RESOLVED' | 'REFERRED'
  ) => {
    setResolvingId(alertId);
    try {
      const alertRef = doc(
        db,
        `tenants/${TENANT_ID}/barangays/${BARANGAY_ID}/triage_alerts/${alertId}`
      );

      // Notes record the decision only. They never claim an action that did not happen.
      const defaultNote =
        nextStatus === 'REFERRED'
          ? 'Referred to Biliran Provincial Hospital (BPH).'
          : nextStatus === 'ACKNOWLEDGED'
          ? 'Seen by the RHU.'
          : 'Case closed by the RHU.';

      const payload: Record<string, any> = {
        status: nextStatus,
        resolved_at: serverTimestamp(),
        resolved_by: 'MHO_DR_ESTRADA',
        resolution_notes: actionNotes[alertId]?.trim() || defaultNote,
      };

      await updateDoc(alertRef, payload);
      setActionNotes((prev) => ({ ...prev, [alertId]: '' }));
      setConfirmReferId(null);
    } catch (err) {
      console.error('Failed to update alert resolution status:', err);
    } finally {
      setResolvingId(null);
    }
  };

  // Counts: aggregate doc and live collections, so existing records show immediately
  const monthAlerts = alerts.filter((a) => String(a.triggered_at || '').startsWith(month));
  const visitsThisMonth = Math.max(aggregates.total_encounters, encountersCount.total, monthAlerts.length);
  const liveMaternalHighRisk = Math.max(
    aggregates.maternal_high_risk,
    monthAlerts.filter((a) => a.encounter_type === 'MATERNAL_CARE').length
  );
  const liveMaternalTotal = Math.max(aggregates.maternal_total, encountersCount.maternal, liveMaternalHighRisk);
  const liveOptWasted = Math.max(
    aggregates.nutrition_severely_wasted,
    monthAlerts.filter((a) => a.encounter_type === 'NUTRITION_OPT').length
  );
  const liveOptTotal = Math.max(aggregates.nutrition_opt_total, encountersCount.opt, liveOptWasted);
  const liveImmunizationTotal = Math.max(aggregates.immunization_total, encountersCount.immunization);

  const count = (s: TriageAlert['status']) => alerts.filter((a) => a.status === s).length;
  const pendingCount = count('PENDING');
  const referredCount = count('REFERRED');
  const resolvedCount = count('RESOLVED');

  const visible = alerts
    .filter((a) => filterStatus === 'ALL' || a.status === filterStatus)
    .sort((a, b) => {
      const open = filterStatus === 'PENDING' || filterStatus === 'ACKNOWLEDGED';
      const diff = String(a.triggered_at).localeCompare(String(b.triggered_at));
      return open ? diff : -diff; // open cases: oldest first. Closed: newest first.
    });
  const selected = visible.find((a) => a.id === selectedId) ?? visible[0] ?? null;

  const filters: { id: StatusFilter; label: string; n: number }[] = [
    { id: 'PENDING', label: 'Needs action', n: pendingCount },
    { id: 'ACKNOWLEDGED', label: 'Acknowledged', n: count('ACKNOWLEDGED') },
    { id: 'REFERRED', label: 'Referred', n: referredCount },
    { id: 'RESOLVED', label: 'Closed', n: resolvedCount },
    { id: 'ALL', label: 'All', n: alerts.length },
  ];

  const headline =
    pendingCount === 0
      ? 'No patients need action'
      : `${pendingCount} ${pendingCount === 1 ? 'patient needs' : 'patients need'} action`;

  const stat = (n: number, label: string, tone = 'text-pintig-ink') => (
    <div className="flex items-baseline gap-2">
      <span className={`text-3xl font-extrabold ${tone}`}>{n}</span>
      <span className="text-base text-pintig-muted">{label}</span>
    </div>
  );

  return (
    <div className="flex flex-col gap-7 p-4 lg:p-8 max-w-[1280px]">
      {/* Header */}
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div>
          <h1 className="text-3xl font-extrabold tracking-tight" aria-live="polite">
            {headline}
          </h1>
          <p className="text-base text-pintig-muted mt-1">Brgy. P.I. Garcia, Naval. Oldest first.</p>
        </div>
        <label className="flex flex-col text-sm font-bold gap-1">
          Month
          <select
            value={month}
            onChange={(e) => onMonthChange(e.target.value)}
            className="h-11 rounded-xl border-2 border-pintig-field bg-white px-3 text-base font-semibold"
          >
            {recentMonthKeys(3).map((k) => (
              <option key={k} value={k}>
                {monthLabel(k)}
              </option>
            ))}
          </select>
        </label>
      </div>

      {/* Summary */}
      <div className="flex flex-wrap gap-x-10 gap-y-3">
        {stat(visitsThisMonth, `visits in ${monthLabel(month).split(' ')[0]}`)}
        {stat(pendingCount, 'need action', pendingCount > 0 ? 'text-pintig-crimson-ink' : 'text-pintig-ink')}
        {stat(referredCount, 'referred')}
        {stat(resolvedCount, 'closed', 'text-pintig-sea')}
      </div>

      {/* Queue and case */}
      <div className="grid grid-cols-1 xl:grid-cols-[minmax(320px,1fr)_minmax(420px,1.3fr)] gap-6 items-start">
        <section aria-label="Alerts" className="bg-white rounded-2xl overflow-hidden border border-pintig-line">
          <div className="flex flex-wrap gap-2 p-3 border-b border-pintig-line" role="group" aria-label="Filter alerts">
            {filters.map((f) => (
              <button
                key={f.id}
                onClick={() => setFilterStatus(f.id)}
                aria-pressed={filterStatus === f.id}
                className={`h-10 px-3 rounded-lg text-sm font-bold border-2 transition-colors ${
                  filterStatus === f.id
                    ? 'bg-pintig-ink text-white border-pintig-ink'
                    : 'bg-white text-pintig-ink border-pintig-line hover:border-pintig-field'
                }`}
              >
                {f.label} {f.n}
              </button>
            ))}
          </div>

          {loading ? (
            <p className="p-8 text-center text-base text-pintig-muted">Loading alerts...</p>
          ) : visible.length === 0 ? (
            <p className="p-8 text-center text-base text-pintig-muted">
              {filterStatus === 'PENDING' ? 'All caught up. Nothing is waiting for you.' : 'No alerts match this filter.'}
            </p>
          ) : (
            <ul className="divide-y divide-pintig-line">
              {visible.map((alert) => {
                const isSel = selected?.id === alert.id;
                const wait = waiting(alert.triggered_at, now);
                const late = alert.status === 'PENDING' && now - Date.parse(alert.triggered_at) > 30 * 60000;
                return (
                  <li key={alert.id}>
                    <button
                      onClick={() => {
                        setSelectedId(alert.id);
                        setConfirmReferId(null);
                      }}
                      aria-current={isSel ? 'true' : undefined}
                      className={`w-full text-left px-4 py-4 flex items-center justify-between gap-3 transition-colors ${
                        isSel ? 'bg-pintig-rose-tint' : 'bg-white hover:bg-pintig-paper'
                      }`}
                    >
                      <span className="min-w-0">
                        <span className="block text-lg font-extrabold truncate">
                          {alert.patient_name || 'Unnamed patient'}
                        </span>
                        <span className="block text-base text-pintig-muted">
                          {TYPE_LABEL[alert.encounter_type] ?? 'Visit'}
                          {alert.sitio_purok ? `. ${alert.sitio_purok}` : ''}
                        </span>
                      </span>
                      {alert.status === 'PENDING' ? (
                        <span
                          className={`shrink-0 text-base font-extrabold ${
                            late ? 'text-pintig-crimson-ink' : 'text-pintig-ink'
                          }`}
                        >
                          {wait}
                        </span>
                      ) : (
                        <span className={`shrink-0 px-2.5 py-1 rounded-full text-sm font-bold ${STATUS_CHIP[alert.status].cls}`}>
                          {STATUS_CHIP[alert.status].label}
                        </span>
                      )}
                    </button>
                  </li>
                );
              })}
            </ul>
          )}
        </section>

        <section aria-label="Selected case" className="bg-white rounded-2xl border border-pintig-line p-6 lg:p-7">
          {!selected ? (
            <p className="text-base text-pintig-muted">Pick an alert to see the details.</p>
          ) : (
            <>
              <div className="flex flex-wrap items-start justify-between gap-3">
                <div>
                  <h2 className="text-2xl font-extrabold">{selected.patient_name || 'Unnamed patient'}</h2>
                  <p className="text-base text-pintig-muted mt-0.5">
                    {selected.sitio_purok ? `${selected.sitio_purok}. ` : ''}
                    Reported by {selected.bhw_id}, {whenLabel(selected.triggered_at)}.
                  </p>
                </div>
                <span className={`px-3 py-1 rounded-full text-sm font-bold ${STATUS_CHIP[selected.status].cls}`}>
                  {STATUS_CHIP[selected.status].label}
                </span>
              </div>

              <div className="mt-5 p-4 rounded-xl bg-pintig-rose-tint text-pintig-crimson-ink">
                <p className="text-sm font-bold">
                  {selected.risk_level === 'HIGH' ? 'High risk' : 'Moderate risk'}. {TYPE_LABEL[selected.encounter_type] ?? 'Visit'}.
                </p>
                <p className="text-xl font-extrabold mt-1 leading-snug">{selected.clinical_summary}</p>
              </div>

              {selected.resolution_notes && (
                <div className="mt-4 p-3.5 rounded-xl bg-pintig-paper text-base">
                  <span className="font-bold">Note from the RHU: </span>
                  {selected.resolution_notes}
                </div>
              )}

              {selected.status !== 'RESOLVED' && selected.status !== 'REFERRED' ? (
                <div className="mt-5">
                  <label htmlFor="case-note" className="block text-sm font-bold">
                    What did you do?
                  </label>
                  <textarea
                    id="case-note"
                    rows={3}
                    placeholder="Optional. Saved with the case and shown to the BHW."
                    value={actionNotes[selected.id] || ''}
                    onChange={(e) => setActionNotes({ ...actionNotes, [selected.id]: e.target.value })}
                    disabled={resolvingId === selected.id}
                    className="mt-1.5 w-full rounded-xl border-2 border-pintig-field px-3.5 py-3 text-base"
                  />

                  <div className="mt-4 flex flex-wrap gap-2.5">
                    {confirmReferId === selected.id ? (
                      <>
                        <button
                          onClick={() => handleUpdateAlertStatus(selected.id, 'REFERRED')}
                          disabled={resolvingId === selected.id}
                          className="h-13 min-h-[52px] px-5 rounded-xl bg-pintig-crimson text-white text-base font-extrabold disabled:opacity-60"
                        >
                          Yes, record the referral
                        </button>
                        <button
                          onClick={() => setConfirmReferId(null)}
                          className="min-h-[52px] px-5 rounded-xl border-2 border-pintig-ink bg-white text-base font-extrabold"
                        >
                          Cancel
                        </button>
                      </>
                    ) : (
                      <>
                        <button
                          onClick={() => setConfirmReferId(selected.id)}
                          disabled={resolvingId === selected.id}
                          className="min-h-[52px] px-5 rounded-xl bg-pintig-crimson text-white text-base font-extrabold flex items-center gap-2 disabled:opacity-60"
                        >
                          <PintigIcon name="refer" size={20} dot={false} /> Refer to Biliran Provincial Hospital
                        </button>
                        {selected.status === 'PENDING' && (
                          <button
                            onClick={() => handleUpdateAlertStatus(selected.id, 'ACKNOWLEDGED')}
                            disabled={resolvingId === selected.id}
                            className="min-h-[52px] px-5 rounded-xl border-2 border-pintig-ink bg-white text-base font-extrabold disabled:opacity-60"
                          >
                            Acknowledge
                          </button>
                        )}
                        <button
                          onClick={() => handleUpdateAlertStatus(selected.id, 'RESOLVED')}
                          disabled={resolvingId === selected.id}
                          className="min-h-[52px] px-5 rounded-xl border-2 border-pintig-ink bg-white text-base font-extrabold disabled:opacity-60"
                        >
                          Mark resolved
                        </button>
                      </>
                    )}
                  </div>
                  <p className="mt-3 text-sm text-pintig-muted leading-snug">
                    Referring records your decision on this case. It does not contact the hospital, so call to confirm.
                  </p>
                </div>
              ) : (
                <p className="mt-5 flex items-center gap-2 text-base font-bold text-pintig-sea-ink">
                  <PintigIcon name="check" size={22} dot={false} /> This case is closed.
                </p>
              )}
            </>
          )}
        </section>
      </div>

      {/* This month by program */}
      <section aria-label={`${monthLabel(month)} by program`}>
        <h2 className="text-xl font-extrabold">{monthLabel(month)} by program</h2>
        <div className="mt-3 grid grid-cols-1 md:grid-cols-3 bg-white rounded-2xl border border-pintig-line divide-y md:divide-y-0 md:divide-x divide-pintig-line">
          <div className="p-5 flex gap-4">
            <PintigIcon name="prenatal" size={32} />
            <div>
              <p className="text-3xl font-extrabold">{liveMaternalTotal}</p>
              <p className="text-base">Prenatal visits</p>
              <p className="text-sm text-pintig-muted">{liveMaternalHighRisk} flagged for high blood pressure</p>
            </div>
          </div>
          <div className="p-5 flex gap-4">
            <PintigIcon name="child" size={32} />
            <div>
              <p className="text-3xl font-extrabold">{liveOptTotal}</p>
              <p className="text-base">Children weighed</p>
              <p className="text-sm text-pintig-muted">
                {liveOptWasted} severely wasted, {aggregates.nutrition_moderately_stunted} stunted
              </p>
            </div>
          </div>
          <div className="p-5 flex gap-4">
            <PintigIcon name="vaccine" size={32} />
            <div>
              <p className="text-3xl font-extrabold">{liveImmunizationTotal}</p>
              <p className="text-base">Vaccinations</p>
              <p className="text-sm text-pintig-muted">Given by BHWs this month</p>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
};
