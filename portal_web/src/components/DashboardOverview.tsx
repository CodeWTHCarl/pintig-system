import React, { useState, useEffect } from 'react';
import {
  doc,
  collection,
  query,
  where,
  orderBy,
  onSnapshot,
  updateDoc,
  serverTimestamp,
} from 'firebase/firestore';
import { db } from '../config/firebase';
import {
  AlertTriangle,
  Activity,
  Baby,
  HeartPulse,
  CheckCircle2,
  Clock,
  Send,
  ShieldAlert,
  ArrowUpRight,
  Stethoscope,
} from 'lucide-react';

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

interface AggregateDoc {
  year_month: string;
  metrics: AggregateMetrics;
  last_updated?: { toDate: () => Date };
}

interface TriageAlert {
  id: string;
  alert_uuid: string;
  encounter_uuid: string;
  patient_uuid: string;
  bhw_id: string;
  encounter_type: 'MATERNAL_CARE' | 'IMMUNIZATION' | 'NUTRITION_OPT';
  risk_level: 'HIGH';
  status: 'PENDING' | 'ACKNOWLEDGED' | 'RESOLVED' | 'REFERRED';
  clinical_summary: string;
  triggered_at: string;
  resolution_notes?: string;
  resolved_by?: string;
  resolved_at?: { toDate: () => Date };
}

const TENANT_ID = 'ph_biliran_naval';
const BARANGAY_ID = 'brgy_pi_garcia';
const TARGET_MONTH = '2026-10';

export const DashboardOverview: React.FC = () => {
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
  const [alerts, setAlerts] = useState<TriageAlert[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [resolvingId, setResolvingId] = useState<string | null>(null);
  const [actionNotes, setActionNotes] = useState<Record<string, string>>({});
  const [filterStatus, setFilterStatus] = useState<string>('ALL');

  useEffect(() => {
    // 1. Quota Guard: Single-document listener on monthly aggregate
    const aggregateDocRef = doc(
      db,
      `tenants/${TENANT_ID}/barangays/${BARANGAY_ID}/aggregates/${TARGET_MONTH}`
    );

    const unsubscribeAggregate = onSnapshot(aggregateDocRef, (snapshot) => {
      if (snapshot.exists()) {
        const data = snapshot.data() as AggregateDoc;
        if (data.metrics) {
          setAggregates(data.metrics);
        }
      }
    });

    // 2. Real-time Triage Alert Feed
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

    return () => {
      unsubscribeAggregate();
      unsubscribeAlerts();
    };
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
      
      const payload: Record<string, any> = {
        status: nextStatus,
        resolved_at: serverTimestamp(),
        resolved_by: 'MHO_DR_ESTRADA',
        resolution_notes: actionNotes[alertId] || `Marked as ${nextStatus} via Command Portal.`,
      };

      await updateDoc(alertRef, payload);
      setActionNotes((prev) => ({ ...prev, [alertId]: '' }));
    } catch (err) {
      console.error('Failed to update alert resolution status:', err);
    } finally {
      setResolvingId(null);
    }
  };

  const filteredAlerts = alerts.filter((a) => {
    if (filterStatus === 'ALL') return true;
    return a.status === filterStatus;
  });

  return (
    <div className="flex flex-col gap-6 p-6 bg-slate-50 min-h-screen text-slate-800">
      {/* Top Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between pb-4 border-b border-slate-200">
        <div>
          <div className="flex items-center gap-2">
            <span className="h-2.5 w-2.5 rounded-full bg-emerald-500 animate-pulse" />
            <span className="text-xs font-semibold tracking-wider uppercase text-slate-500">
              Naval RHU Clinical Command • {BARANGAY_ID}
            </span>
          </div>
          <h1 className="text-2xl font-bold tracking-tight text-slate-900 mt-1">
            MHO Triage & Ingestion Summary
          </h1>
        </div>
        <div className="mt-3 md:mt-0 flex items-center gap-3">
          <div className="text-right">
            <span className="block text-xs text-slate-500 font-medium">Reporting Period</span>
            <span className="text-sm font-semibold text-slate-700 bg-white px-2.5 py-1 rounded border border-slate-200">
              October 2026 (Active)
            </span>
          </div>
        </div>
      </div>

      {/* Primary KPI Aggregate Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* Total Encounters */}
        <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm flex flex-col justify-between">
          <div className="flex items-center justify-between text-slate-500">
            <span className="text-xs font-bold uppercase tracking-wider">Sync Ingestion</span>
            <Activity className="h-4 w-4 text-sky-600" />
          </div>
          <div className="mt-4">
            <div className="text-3xl font-extrabold text-slate-900">{aggregates.total_encounters}</div>
            <p className="text-xs text-slate-500 mt-1">Total Verified Encounters</p>
          </div>
          <div className="mt-4 pt-3 border-t border-slate-100 flex items-center justify-between text-[11px] text-slate-500">
            <span>Spark Quota Cost:</span>
            <span className="font-semibold text-emerald-600">1 Doc Read</span>
          </div>
        </div>

        {/* High Risk Critical Alarms */}
        <div className="bg-white p-5 rounded-xl border border-rose-200 shadow-sm flex flex-col justify-between ring-1 ring-rose-100">
          <div className="flex items-center justify-between text-rose-600">
            <span className="text-xs font-bold uppercase tracking-wider">High Risk Alarms</span>
            <ShieldAlert className="h-4 w-4 text-rose-600" />
          </div>
          <div className="mt-4">
            <div className="text-3xl font-extrabold text-rose-600">{aggregates.high_risk_alerts_count}</div>
            <p className="text-xs text-rose-700 mt-1 font-medium">Requires Immediate Action</p>
          </div>
          <div className="mt-4 pt-3 border-t border-rose-100 flex items-center justify-between text-[11px] text-rose-700">
            <span>Pending Triages:</span>
            <span className="font-bold">
              {alerts.filter((a) => a.status === 'PENDING').length} Unresolved
            </span>
          </div>
        </div>

        {/* Maternal Care Profile */}
        <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm flex flex-col justify-between">
          <div className="flex items-center justify-between text-slate-500">
            <span className="text-xs font-bold uppercase tracking-wider">Maternal Health</span>
            <HeartPulse className="h-4 w-4 text-indigo-600" />
          </div>
          <div className="mt-4">
            <div className="text-3xl font-extrabold text-slate-900">{aggregates.maternal_total}</div>
            <p className="text-xs text-slate-500 mt-1">Prenatal Assessments Logged</p>
          </div>
          <div className="mt-4 pt-3 border-t border-slate-100 flex items-center justify-between text-[11px]">
            <span className="text-slate-500">Preeclampsia Flags:</span>
            <span className="font-bold text-amber-600">{aggregates.maternal_high_risk} Detected</span>
          </div>
        </div>

        {/* Malnutrition Surveillance */}
        <div className="bg-white p-5 rounded-xl border border-slate-200 shadow-sm flex flex-col justify-between">
          <div className="flex items-center justify-between text-slate-500">
            <span className="text-xs font-bold uppercase tracking-wider">Child OPT Plus</span>
            <Baby className="h-4 w-4 text-emerald-600" />
          </div>
          <div className="mt-4">
            <div className="text-3xl font-extrabold text-slate-900">{aggregates.nutrition_opt_total}</div>
            <p className="text-xs text-slate-500 mt-1">Preschoolers Assessed</p>
          </div>
          <div className="mt-4 pt-3 border-t border-slate-100 flex items-center justify-between text-[11px]">
            <span className="text-slate-500">Severely Wasted:</span>
            <span className="font-bold text-rose-600">
              {aggregates.nutrition_severely_wasted} ({aggregates.nutrition_moderately_stunted} Stunted)
            </span>
          </div>
        </div>
      </div>

      {/* Live Priority Triage Feed */}
      <div className="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        <div className="p-5 border-b border-slate-200 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          <div>
            <h2 className="text-base font-bold text-slate-900 flex items-center gap-2">
              <AlertTriangle className="h-4 w-4 text-amber-500" />
              Live Clinical Triage & Emergency Referral Dispatch
            </h2>
            <p className="text-xs text-slate-500 mt-0.5">
              Sync-triggered field encounters flagged with high maternal or pediatric risk
            </p>
          </div>
          <div className="flex items-center gap-2">
            <span className="text-xs text-slate-400 font-medium">Filter Status:</span>
            <div className="inline-flex rounded-lg border border-slate-200 p-0.5 bg-slate-50 text-xs">
              {(['ALL', 'PENDING', 'ACKNOWLEDGED', 'RESOLVED'] as const).map((status) => (
                <button
                  key={status}
                  onClick={() => setFilterStatus(status)}
                  className={`px-3 py-1 rounded-md font-medium transition-colors ${
                    filterStatus === status
                      ? 'bg-white text-slate-900 shadow-sm'
                      : 'text-slate-500 hover:text-slate-900'
                  }`}
                >
                  {status}
                </button>
              ))}
            </div>
          </div>
        </div>

        {loading ? (
          <div className="p-8 text-center text-sm text-slate-400">Loading incoming triage feed...</div>
        ) : filteredAlerts.length === 0 ? (
          <div className="p-8 text-center text-sm text-slate-400">
            No clinical triage alerts found matching the current filter.
          </div>
        ) : (
          <div className="divide-y divide-slate-100">
            {filteredAlerts.map((alert) => (
              <div
                key={alert.id}
                className={`p-5 transition-colors ${
                  alert.status === 'PENDING' ? 'bg-rose-50/30' : 'bg-white'
                }`}
              >
                <div className="flex flex-col lg:flex-row lg:items-start justify-between gap-4">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 flex-wrap">
                      <span className="px-2 py-0.5 rounded text-[11px] font-bold bg-rose-100 text-rose-700 tracking-wide">
                        {alert.risk_level}
                      </span>
                      <span className="px-2 py-0.5 rounded text-[11px] font-semibold bg-slate-100 text-slate-700">
                        {alert.encounter_type.replace('_', ' ')}
                      </span>
                      <span
                        className={`px-2 py-0.5 rounded text-[11px] font-semibold ${
                          alert.status === 'PENDING'
                            ? 'bg-amber-100 text-amber-800'
                            : alert.status === 'ACKNOWLEDGED'
                            ? 'bg-sky-100 text-sky-800'
                            : 'bg-emerald-100 text-emerald-800'
                        }`}
                      >
                        {alert.status}
                      </span>
                      <span className="text-xs text-slate-400 flex items-center gap-1 ml-auto lg:ml-0">
                        <Clock className="h-3 w-3" />
                        {new Date(alert.triggered_at).toLocaleTimeString([], {
                          hour: '2-digit',
                          minute: '2-digit',
                          second: '2-digit',
                        })}
                      </span>
                    </div>

                    <p className="mt-2 text-sm font-semibold text-slate-800">{alert.clinical_summary}</p>

                    <div className="mt-2 flex flex-wrap gap-x-6 gap-y-1 text-xs text-slate-500">
                      <span>
                        Patient UUID: <strong className="text-slate-700">{alert.patient_uuid.slice(0, 13)}...</strong>
                      </span>
                      <span>
                        Field Officer: <strong className="text-slate-700">{alert.bhw_id}</strong>
                      </span>
                      <span>
                        Encounter: <strong className="text-slate-700">{alert.encounter_uuid.slice(0, 13)}...</strong>
                      </span>
                    </div>

                    {alert.resolution_notes && (
                      <div className="mt-2 p-2 rounded bg-slate-50 border border-slate-200 text-xs text-slate-600">
                        <span className="font-semibold text-slate-700">MHO Clinical Notes:</span>{' '}
                        {alert.resolution_notes}
                      </div>
                    )}
                  </div>

                  {/* Operational Resolution Controls */}
                  <div className="w-full lg:w-80 flex flex-col gap-2 shrink-0">
                    <input
                      type="text"
                      placeholder="Add triage action note..."
                      value={actionNotes[alert.id] || ''}
                      onChange={(e) =>
                        setActionNotes({ ...actionNotes, [alert.id]: e.target.value })
                      }
                      disabled={resolvingId === alert.id}
                      className="w-full text-xs px-2.5 py-1.5 rounded border border-slate-300 focus:outline-none focus:ring-1 focus:ring-teal-600"
                    />
                    <div className="flex items-center gap-2">
                      {alert.status === 'PENDING' && (
                        <button
                          onClick={() => handleUpdateAlertStatus(alert.id, 'ACKNOWLEDGED')}
                          disabled={resolvingId === alert.id}
                          className="flex-1 py-1.5 px-2 bg-sky-50 text-sky-700 hover:bg-sky-100 rounded text-xs font-semibold border border-sky-200 flex items-center justify-center gap-1"
                        >
                          <Clock className="h-3 w-3" /> Acknowledge
                        </button>
                      )}
                      {alert.status !== 'RESOLVED' && (
                        <button
                          onClick={() => handleUpdateAlertStatus(alert.id, 'RESOLVED')}
                          disabled={resolvingId === alert.id}
                          className="flex-1 py-1.5 px-2 bg-emerald-600 text-white hover:bg-emerald-700 rounded text-xs font-semibold shadow-sm flex items-center justify-center gap-1"
                        >
                          <CheckCircle2 className="h-3 w-3" /> Resolve
                        </button>
                      )}
                      <button
                        onClick={() => handleUpdateAlertStatus(alert.id, 'REFERRED')}
                        disabled={resolvingId === alert.id}
                        className="py-1.5 px-2 bg-slate-100 text-slate-700 hover:bg-slate-200 rounded text-xs font-semibold border border-slate-200 flex items-center justify-center gap-1"
                        title="Dispatch Referral to Biliran Provincial Hospital"
                      >
                        <ArrowUpRight className="h-3 w-3" /> Refer BPH
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};