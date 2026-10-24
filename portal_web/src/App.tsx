import React, { useState } from 'react';
import {
  collection,
  getDocs,
  doc,
  setDoc,
  writeBatch,
} from 'firebase/firestore';
import { db } from './config/firebase';
import { DashboardOverview } from './components/DashboardOverview';
import { EpidemiologicalGisMap } from './components/EpidemiologicalGisMap';
import { FhsisExportService, SyncedEncounterRow } from './services/FhsisExportService';
import {
  LayoutDashboard,
  MapPin,
  FileSpreadsheet,
  ShieldCheck,
  Radio,
  Stethoscope,
  RotateCcw,
} from 'lucide-react';

const TENANT_ID = 'ph_biliran_naval';
const BARANGAY_ID = 'brgy_pi_garcia';
const TARGET_MONTH = '2026-10';

export const App: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'dashboard' | 'map'>('dashboard');
  const [isExporting, setIsExporting] = useState<boolean>(false);
  const [isResetting, setIsResetting] = useState<boolean>(false);

  const handleResetDemoData = async () => {
    const confirmed = window.confirm(
      'Reset Firestore to a clean presentation slate? This will remove old test records and reset the October 2026 KPI counters.'
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
        doc(db, `tenants/${TENANT_ID}/barangays/${BARANGAY_ID}/aggregates/${TARGET_MONTH}`),
        {
          year_month: TARGET_MONTH,
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
        reportingYear: 2026,
        reportingMonth: 'October',
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

  return (
    <div className="flex h-screen bg-slate-100 font-sans text-slate-800">
      {/* Pintig Brand Command Sidebar */}
      <aside className="w-72 bg-gradient-to-b from-slate-950 via-slate-900 to-[#1f0d12] text-white flex flex-col justify-between shrink-0 border-r border-slate-800/80 shadow-2xl">
        <div>
          {/* Official Pintig Logo & Brand Header */}
          <div className="p-6 border-b border-slate-800/80">
            <div className="flex items-center gap-3.5">
              <div className="w-12 h-12 rounded-2xl bg-[#FAF8F5] p-1.5 flex items-center justify-center shadow-lg shadow-rose-950/50 border border-white/80 shrink-0 overflow-hidden">
                <img
                  src="/pintig_logo.png"
                  alt="Pintig Logo"
                  className="w-full h-full object-contain"
                />
              </div>
              <div>
                <div className="flex items-center gap-2">
                  <h1 className="text-xl font-black tracking-wider text-white">Pintig</h1>
                  <span className="px-1.5 py-0.5 text-[9px] font-extrabold uppercase tracking-wider bg-rose-500/20 text-rose-300 rounded border border-rose-500/30">
                    PRO
                  </span>
                </div>
                <p className="text-xs text-slate-400 font-medium mt-0.5">
                  RHU Naval Command Portal
                </p>
              </div>
            </div>

            {/* Live Edge Bridge Pill */}
            <div className="mt-4 px-3 py-2 rounded-xl bg-slate-900/90 border border-slate-800 flex items-center justify-between text-[11px]">
              <span className="flex items-center gap-1.5 text-emerald-400 font-semibold">
                <Radio className="h-3.5 w-3.5 animate-pulse" /> Edge Sync Online
              </span>
              <span className="text-slate-400 font-mono">pintig-219</span>
            </div>
          </div>

          {/* Navigation Links */}
          <div className="px-4 pt-5 pb-2">
            <span className="px-3 text-[10px] font-bold uppercase tracking-widest text-slate-500">
              Clinical Surveillance
            </span>
            <nav className="mt-2 space-y-1.5">
              <button
                onClick={() => setActiveTab('dashboard')}
                className={`w-full flex items-center gap-3 px-3.5 py-3 rounded-xl text-sm font-bold transition-all ${
                  activeTab === 'dashboard'
                    ? 'bg-gradient-to-r from-[#C81E2B] to-rose-700 text-white shadow-lg shadow-rose-950/60'
                    : 'text-slate-400 hover:bg-slate-800/70 hover:text-white'
                }`}
              >
                <LayoutDashboard className="h-4 w-4" /> Overview & Triage
              </button>

              <button
                onClick={() => setActiveTab('map')}
                className={`w-full flex items-center gap-3 px-3.5 py-3 rounded-xl text-sm font-bold transition-all ${
                  activeTab === 'map'
                    ? 'bg-gradient-to-r from-[#C81E2B] to-rose-700 text-white shadow-lg shadow-rose-950/60'
                    : 'text-slate-400 hover:bg-slate-800/70 hover:text-white'
                }`}
              >
                <MapPin className="h-4 w-4" /> Spot Mapping (GIS)
              </button>
            </nav>
          </div>
        </div>

        {/* Bottom Command Officer & 1-Click FHSIS Export Panel */}
        <div className="p-4 space-y-2.5 border-t border-slate-800/80 bg-slate-950/50">
          <div className="p-3 rounded-xl bg-slate-900/90 border border-slate-800 flex items-center gap-3">
            <div className="h-9 w-9 rounded-lg bg-rose-500/15 border border-rose-500/30 flex items-center justify-center text-rose-400 shrink-0">
              <Stethoscope className="h-4 w-4" />
            </div>
            <div className="min-w-0">
              <p className="text-xs font-bold text-white truncate">Dr. Estrada, MHO</p>
              <p className="text-[11px] text-slate-400 truncate">Brgy. P.I. Garcia • Naval</p>
            </div>
          </div>

          <button
            onClick={handleDownloadFhsis}
            disabled={isExporting}
            className="w-full bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-500 hover:to-teal-500 disabled:from-slate-700 disabled:to-slate-700 text-white p-3 rounded-xl text-xs font-bold flex items-center justify-center gap-2 shadow-lg shadow-emerald-950/50 transition-all"
          >
            <FileSpreadsheet className="h-4 w-4" />
            {isExporting ? 'Generating DOH Workbook...' : '1-Click FHSIS M1/M2'}
          </button>

          <button
            onClick={handleResetDemoData}
            disabled={isResetting}
            className="w-full bg-slate-900/80 hover:bg-slate-800 text-slate-400 hover:text-white py-2 px-3 rounded-lg text-[11px] font-semibold border border-slate-800 flex items-center justify-center gap-1.5 transition-colors"
            title="Clear old anonymous test cards and reset counters for live presentation"
          >
            <RotateCcw className={`h-3.5 w-3.5 ${isResetting ? 'animate-spin' : ''}`} />
            {isResetting ? 'Resetting Slate...' : 'Reset Demo Slate'}
          </button>

          <div className="flex items-center justify-center gap-1 text-[10px] text-slate-400 pt-0.5">
            <ShieldCheck className="h-3 w-3 text-emerald-400" />
            <span>RA 10173 & DOH FHSIS Compliant</span>
          </div>
        </div>
      </aside>

      {/* Main Content Viewport */}
      <main className="flex-1 overflow-y-auto">
        {activeTab === 'dashboard' ? (
          <DashboardOverview />
        ) : (
          <div className="p-6">
            <EpidemiologicalGisMap />
          </div>
        )}
      </main>
    </div>
  );
};

export default App;