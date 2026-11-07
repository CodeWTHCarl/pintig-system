import React, { useEffect, useState } from 'react';
import {
  collection,
  getDocs,
  doc,
  setDoc,
  writeBatch,
} from 'firebase/firestore';
import { db } from './config/firebase';
import { currentMonthKey, monthLabel, monthParts } from './config/period';
import { DashboardOverview } from './components/DashboardOverview';
import { EpidemiologicalGisMap } from './components/EpidemiologicalGisMap';
import { PintigIcon } from './components/PintigIcons';
import { FhsisExportService, SyncedEncounterRow } from './services/FhsisExportService';

const TENANT_ID = 'ph_biliran_naval';
const BARANGAY_ID = 'brgy_pi_garcia';

export const App: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'dashboard' | 'map'>('dashboard');
  const [isExporting, setIsExporting] = useState<boolean>(false);
  const [isResetting, setIsResetting] = useState<boolean>(false);
  const [month, setMonth] = useState<string>(currentMonthKey());
  const [online, setOnline] = useState<boolean>(typeof navigator === 'undefined' ? true : navigator.onLine);

  useEffect(() => {
    const up = () => setOnline(true);
    const down = () => setOnline(false);
    window.addEventListener('online', up);
    window.addEventListener('offline', down);
    return () => {
      window.removeEventListener('online', up);
      window.removeEventListener('offline', down);
    };
  }, []);

  const handleResetDemoData = async () => {
    const confirmed = window.confirm(
      `Delete ALL encounters and alerts for this barangay and start a clean demo slate? The ${monthLabel(month)} counters are reset too. This cannot be undone.`
    );
    if (!confirmed) return;

    setIsResetting(true);
    try {
      const batch = writeBatch(db);

      // 1. Delete all existing documents in encounters
      const encountersRef = collection(
        db,
        `tenants/${TENANT_ID}/barangays/${BARANGAY_ID}/encounters`
      );
      const encountersSnap = await getDocs(encountersRef);
      encountersSnap.forEach((d) => batch.delete(d.ref));

      // 2. Delete all existing documents in triage_alerts
      const alertsRef = collection(
        db,
        `tenants/${TENANT_ID}/barangays/${BARANGAY_ID}/triage_alerts`
      );
      const alertsSnap = await getDocs(alertsRef);
      alertsSnap.forEach((d) => batch.delete(d.ref));

      await batch.commit();

      // 3. Seed 1 clean resolved baseline alert so the feed isn't completely empty before demo
      const baselineAlertId = '33333333-0000-4000-8000-000000000001';
      await setDoc(
        doc(db, `tenants/${TENANT_ID}/barangays/${BARANGAY_ID}/triage_alerts/${baselineAlertId}`),
        {
          alert_uuid: baselineAlertId,
          encounter_uuid: baselineAlertId,
          patient_uuid: '22222222-0000-4000-8000-000000000099',
          patient_name: 'Elena Navarro (Synthetic)',
          sitio_purok: 'Sitio Tinago',
          bhw_id: 'BHW-NAV-01',
          encounter_type: 'MATERNAL_CARE',
          risk_level: 'HIGH',
          status: 'RESOLVED',
          clinical_summary: 'Elena Navarro (Sitio Tinago): BP 145/95 mmHg (Preeclampsia Risk - HIGH)',
          triggered_at: new Date().toISOString(),
          resolution_notes: 'Dispatched RHU ambulance to Sitio Tinago; patient stabilized.',
          resolved_by: 'MHO_DR_ESTRADA',
        }
      );

      // 4. Reset monthly aggregate counters to clean baseline (1 verified maternal high-risk case)
      await setDoc(
        doc(db, `tenants/${TENANT_ID}/barangays/${BARANGAY_ID}/aggregates/${month}`),
        {
          year_month: month,
          total_encounters: 1,
          high_risk_alerts_count: 1,
          maternal_total: 1,
          maternal_high_risk: 1,
          immunization_total: 0,
          nutrition_opt_total: 0,
          nutrition_severely_wasted: 0,
          nutrition_moderately_stunted: 0,
        }
      );
    } catch (error) {
      console.error('Failed to reset demo data:', error);
      alert('Failed to reset demo data. Check console for details.');
    } finally {
      setIsResetting(false);
    }
  };

  const handleDownloadFhsis = async () => {
    setIsExporting(true);
    try {
      const encountersSnap = await getDocs(
        collection(db, `tenants/${TENANT_ID}/barangays/${BARANGAY_ID}/encounters`)
      );

      let syncedMaternal = 0;
      let syncedMaternalHighRisk = 0;
      let syncedIronFolic = 0;
      let syncedBcg = 0;
      let syncedHepb = 0;
      let syncedPenta1 = 0;
      let syncedPenta2 = 0;
      let syncedOpv1 = 0;
      let syncedOptTotal = 0;
      let syncedOptNormal = 0;
      let syncedOptStunted = 0;
      let syncedOptWasted = 0;

      const liveRows: SyncedEncounterRow[] = [];

      encountersSnap.forEach((docSnap) => {
        const d = docSnap.data();
        let clinical: Record<string, any> = {};
        if (typeof d.clinical_data === 'string') {
          try {
            clinical = JSON.parse(d.clinical_data);
          } catch {
            clinical = {};
          }
        } else if (d.clinical_data && typeof d.clinical_data === 'object') {
          clinical = d.clinical_data;
        }

        const type = String(d.encounter_type || '').toUpperCase();
        const risk = String(d.triage_risk_level || 'NORMAL').toUpperCase();
        const patientName = String(d.patient_name || clinical.patient_name || 'Verified Patient');
        const sitioPurok = String(d.sitio_purok || clinical.sitio_purok || 'Purok 1 (Centro)');
        let summary = '';

        if (type.includes('MATERNAL')) {
          syncedMaternal++;
          if (risk === 'HIGH' || risk === 'MODERATE') syncedMaternalHighRisk++;
          if (clinical.iron_folic_given) syncedIronFolic++;
          summary = `BP ${clinical.systolic_bp ?? 'N/A'}/${clinical.diastolic_bp ?? 'N/A'} mmHg, Wt ${clinical.weight_kg ?? 'N/A'}kg`;
        } else if (type.includes('IMMUNIZATION') || type.includes('EPI')) {
          const antigen = String(clinical.antigen_code || '').toUpperCase();
          const dose = Number(clinical.dose_number || 1);
          if (antigen === 'BCG') syncedBcg++;
          else if (antigen === 'HEPB') syncedHepb++;
          else if (antigen === 'PENTA' && dose === 1) syncedPenta1++;
          else if (antigen === 'PENTA' && dose === 2) syncedPenta2++;
          else if (antigen === 'OPV' && dose === 1) syncedOpv1++;
          summary = `Antigen: ${antigen} (Dose ${dose})${clinical.aefi_reported ? ' [AEFI FLAGGED]' : ''}`;
        } else if (type.includes('NUTRITION') || type.includes('OPT')) {
          syncedOptTotal++;
          const status = String(clinical.nutritional_status || 'NORMAL').toUpperCase();
          if (status.includes('WASTED')) syncedOptWasted++;
          else if (status.includes('STUNTED')) syncedOptStunted++;
          else syncedOptNormal++;
          summary = `Wt ${clinical.weight_kg ?? 'N/A'}kg, Ht ${clinical.height_cm ?? 'N/A'}cm, WHZ: ${clinical.whz ?? 'N/A'} (${status})`;
        }

        liveRows.push({
          encounterUuid: docSnap.id,
          timestamp: String(d.timestamp || ''),
          encounterType: type,
          patientName,
          sitioPurok,
          riskLevel: risk,
          bhwId: String(d.bhw_id || 'BHW-NAV-01'),
          clinicalSummary: summary,
        });
      });

      await FhsisExportService.generateFhsisMonthlyWorkbook({
        reportingYear: monthParts(month).year,
        reportingMonth: monthParts(month).monthName,
        barangayName: 'Barangay P.I. Garcia',
        municipality: 'Naval',
        province: 'Biliran',
        maternalMetrics: {
          totalTargetMaternal: 45,
          prenatalFirstTrimester: 18 + syncedMaternal,
          prenatalFourVisitsOrMore: 32 + syncedMaternal,
          highRiskPreeclampsiaDetected: 1 + syncedMaternalHighRisk,
          ironFolicAcidSupplemented: 38 + syncedIronFolic,
        },
        immunizationMetrics: {
          bcgDose1: 22 + syncedBcg,
          hepbDose1: 21 + syncedHepb,
          pentaDose1: 24 + syncedPenta1,
          pentaDose2: 23 + syncedPenta2,
          pentaDose3: 20,
          opvDose1: 24 + syncedOpv1,
          opvDose2: 23,
          opvDose3: 20,
          fullyImmunizedChildren: 19,
        },
        nutritionOptMetrics: {
          totalMeasuredPreschoolers: 120 + syncedOptTotal,
          normalStatus: 108 + syncedOptNormal,
          moderatelyStunted: 9 + syncedOptStunted,
          severelyWasted: 3 + syncedOptWasted,
        },
        liveSyncedEncounters: liveRows,
      });
    } catch (error) {
      console.error('Export failed:', error);
    } finally {
      setIsExporting(false);
    }
  };

  const navBtn = (active: boolean) =>
    `flex items-center gap-3 h-12 px-3.5 rounded-xl text-base font-bold transition-colors ${
      active ? 'bg-pintig-rose-tint text-pintig-crimson-ink' : 'text-pintig-ink hover:bg-pintig-paper'
    }`;

  return (
    <div className="min-h-screen flex flex-col lg:flex-row bg-pintig-paper text-pintig-ink font-sans">
      <aside className="lg:w-64 lg:shrink-0 lg:h-screen lg:sticky lg:top-0 flex flex-col gap-4 p-4 lg:p-5 bg-white border-b lg:border-b-0 lg:border-r border-pintig-line">
        {/* Logo: the official mark, on the logo's own ivory */}
        <div className="flex items-center gap-3 px-1">
          <div className="w-12 h-12 rounded-xl bg-pintig-ivory border border-pintig-line overflow-hidden shrink-0">
            <img src="/pintig_mark.png" alt="Pintig" className="w-full h-full object-contain" />
          </div>
          <div>
            <h1 className="text-xl font-extrabold leading-tight">Pintig</h1>
            <p className="text-sm text-pintig-muted">RHU Naval</p>
          </div>
        </div>

        <nav className="flex lg:flex-col gap-1" aria-label="Main">
          <button
            onClick={() => setActiveTab('dashboard')}
            aria-current={activeTab === 'dashboard' ? 'page' : undefined}
            className={navBtn(activeTab === 'dashboard')}
          >
            <PintigIcon name="alert" size={22} /> Alerts
          </button>
          <button
            onClick={() => setActiveTab('map')}
            aria-current={activeTab === 'map' ? 'page' : undefined}
            className={navBtn(activeTab === 'map')}
          >
            <PintigIcon name="map" size={22} /> Map of cases
          </button>
          <button
            onClick={handleDownloadFhsis}
            disabled={isExporting}
            className={`${navBtn(false)} disabled:opacity-60`}
          >
            <PintigIcon name="report" size={22} />
            {isExporting ? 'Preparing report...' : 'Monthly report'}
          </button>
        </nav>

        <div className="hidden lg:flex flex-col gap-3 mt-auto">
          <div className="px-1">
            <p className="text-sm font-extrabold">Dr. Estrada, MHO</p>
            <p className="text-sm text-pintig-muted">Brgy. P.I. Garcia, Naval</p>
          </div>

          <p
            className={`flex items-center gap-2 px-1 text-sm font-semibold ${
              online ? 'text-pintig-sea-ink' : 'text-pintig-crimson-ink'
            }`}
            role="status"
          >
            <span
              className={`h-2.5 w-2.5 rounded-full ${online ? 'bg-pintig-sea' : 'bg-pintig-crimson'}`}
              aria-hidden="true"
            />
            {online ? 'Connected' : 'Offline. Showing the last data received.'}
          </p>

          <details className="px-1 text-sm">
            <summary className="cursor-pointer text-pintig-muted underline underline-offset-2">Demo tools</summary>
            <div className="mt-2 p-3 rounded-xl bg-pintig-amber-tint text-pintig-amber-ink">
              <p className="font-semibold leading-snug">For presentations only. This deletes all test records.</p>
              <button
                onClick={handleResetDemoData}
                disabled={isResetting}
                className="mt-2 h-10 px-3 rounded-lg bg-white border-2 border-pintig-amber-ink font-bold disabled:opacity-60"
              >
                {isResetting ? 'Resetting...' : 'Reset demo data'}
              </button>
            </div>
          </details>
        </div>
      </aside>

      <main className="flex-1 min-w-0">
        {activeTab === 'dashboard' ? (
          <DashboardOverview month={month} onMonthChange={setMonth} />
        ) : (
          <div className="p-4 lg:p-8">
            <EpidemiologicalGisMap />
          </div>
        )}
      </main>
    </div>
  );
};

export default App;
