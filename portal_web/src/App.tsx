import React, { useState } from 'react';
import { DashboardOverview } from './components/DashboardOverview';
import { EpidemiologicalGisMap } from './components/EpidemiologicalGisMap';
import { FhsisExportService } from './services/FhsisExportService';
import { LayoutDashboard, MapPin, FileSpreadsheet } from 'lucide-react';

export const App: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'dashboard' | 'map'>('dashboard');
  const [isExporting, setIsExporting] = useState<boolean>(false);

  const handleDownloadFhsis = async () => {
    setIsExporting(true);
    try {
      await FhsisExportService.generateFhsisMonthlyWorkbook({
        reportingYear: 2026,
        reportingMonth: 'October',
        barangayName: 'Barangay P.I. Garcia',
        municipality: 'Naval',
        province: 'Biliran',
        maternalMetrics: {
          totalTargetMaternal: 45,
          prenatalFirstTrimester: 18,
          prenatalFourVisitsOrMore: 32,
          highRiskPreeclampsiaDetected: 2,
          ironFolicAcidSupplemented: 40,
        },
        immunizationMetrics: {
          bcgDose1: 22,
          hepbDose1: 21,
          pentaDose1: 24,
          pentaDose2: 23,
          pentaDose3: 20,
          opvDose1: 24,
          opvDose2: 23,
          opvDose3: 20,
          fullyImmunizedChildren: 19,
        },
        nutritionOptMetrics: {
          totalMeasuredPreschoolers: 120,
          normalStatus: 108,
          moderatelyStunted: 9,
          severelyWasted: 3,
        },
      });
    } catch (error) {
      console.error('Export failed:', error);
    } finally {
      setIsExporting(false);
    }
  };

  return (
    <div className="flex h-screen bg-slate-100 font-sans text-slate-800">
      {/* Sidebar Navigation */}
      <aside className="w-64 bg-slate-900 text-white flex flex-col justify-between shrink-0">
        <div>
          <div className="p-6 border-b border-slate-800">
            <h1 className="text-xl font-black tracking-wider text-sky-400">PINTIG</h1>
            <p className="text-xs text-slate-400 mt-0.5">RHU Naval Command Portal</p>
          </div>

          <nav className="p-4 space-y-1">
            <button
              onClick={() => setActiveTab('dashboard')}
              className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-semibold transition-colors ${
                activeTab === 'dashboard'
                  ? 'bg-sky-600 text-white'
                  : 'text-slate-400 hover:bg-slate-800 hover:text-white'
              }`}
            >
              <LayoutDashboard className="h-4 w-4" /> Overview & Triage
            </button>

            <button
              onClick={() => setActiveTab('map')}
              className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-semibold transition-colors ${
                activeTab === 'map'
                  ? 'bg-sky-600 text-white'
                  : 'text-slate-400 hover:bg-slate-800 hover:text-white'
              }`}
            >
              <MapPin className="h-4 w-4" /> Spot Mapping (GIS)
            </button>
          </nav>
        </div>

        {/* 1-Click DOH Export Button in Sidebar */}
        <div className="p-4 border-t border-slate-800">
          <button
            onClick={handleDownloadFhsis}
            disabled={isExporting}
            className="w-full bg-emerald-600 hover:bg-emerald-700 disabled:bg-slate-700 text-white p-3 rounded-lg text-xs font-bold flex items-center justify-center gap-2 shadow-sm transition-all"
          >
            <FileSpreadsheet className="h-4 w-4" />
            {isExporting ? 'Generating Excel...' : '1-Click FHSIS M1/M2'}
          </button>
          <p className="text-[10px] text-slate-400 text-center mt-2">
            Auto-formatted official DOH Excel
          </p>
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