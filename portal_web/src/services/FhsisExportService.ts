import ExcelJS from 'exceljs';

export interface SyncedEncounterRow {
  encounterUuid: string;
  timestamp: string;
  encounterType: string;
  patientName: string;
  sitioPurok: string;
  riskLevel: string;
  bhwId: string;
  clinicalSummary: string;
}

export interface FhsisExportDataPayload {
  reportingYear: number;
  reportingMonth: string;
  barangayName: string;
  municipality: string;
  province: string;
  maternalMetrics: {
    totalTargetMaternal: number;
    prenatalFirstTrimester: number;
    prenatalFourVisitsOrMore: number;
    highRiskPreeclampsiaDetected: number;
    ironFolicAcidSupplemented: number;
  };
  immunizationMetrics: {
    bcgDose1: number;
    hepbDose1: number;
    pentaDose1: number;
    pentaDose2: number;
    pentaDose3: number;
    opvDose1: number;
    opvDose2: number;
    opvDose3: number;
    fullyImmunizedChildren: number;
  };
  nutritionOptMetrics: {
    totalMeasuredPreschoolers: number;
    normalStatus: number;
    moderatelyStunted: number;
    severelyWasted: number;
  };
  liveSyncedEncounters?: SyncedEncounterRow[];
}

export class FhsisExportService {
  /**
   * Generates and downloads the official DOH-FHSIS M1 (Maternal & Child Care),
   * M2 (OPT+ Child Nutrition), and Live Edge Sync Registry workbook.
   */
  public static async generateFhsisMonthlyWorkbook(
    payload: FhsisExportDataPayload
  ): Promise<void> {
    const workbook = new ExcelJS.Workbook();
    workbook.creator = 'Pintig Cloud Ingestion Engine';
    workbook.lastModifiedBy = 'MHO Naval';
    workbook.created = new Date();
    workbook.modified = new Date();

    // ---------------------------------------------------------
    // Worksheet 1: DOH-FHSIS Form M1 (Maternal & Child Health)
    // ---------------------------------------------------------
    const m1Sheet = workbook.addWorksheet('FHSIS M1 - Maternal & Child', {
      views: [{ showGridLines: true }],
    });

    m1Sheet.columns = [
      { width: 8 },
      { width: 45 },
      { width: 14 },
      { width: 14 },
      { width: 16 },
      { width: 28 },
    ];

    m1Sheet.mergeCells('A1:F1');
    const headerTitle = m1Sheet.getCell('A1');
    headerTitle.value = 'DEPARTMENT OF HEALTH • FIELD HEALTH SERVICES INFORMATION SYSTEM (FHSIS)';
    headerTitle.font = { name: 'Arial', size: 11, bold: true, color: { argb: 'FFFFFFFF' } };
    headerTitle.fill = {
      type: 'pattern',
      pattern: 'solid',
      fgColor: { argb: 'FF0F766E' },
    };
    headerTitle.alignment = { horizontal: 'center', vertical: 'middle' };
    m1Sheet.getRow(1).height = 26;

    m1Sheet.mergeCells('A2:F2');
    const subTitle = m1Sheet.getCell('A2');
    subTitle.value = `MONTHLY REPORT OF ACCOMPLISHMENTS (FORM M1) • REPORTING PERIOD: ${payload.reportingMonth.toUpperCase()} ${payload.reportingYear}`;
    subTitle.font = { name: 'Arial', size: 10, bold: true, color: { argb: 'FF0F172A' } };
    subTitle.alignment = { horizontal: 'center', vertical: 'middle' };
    m1Sheet.getRow(2).height = 20;

    m1Sheet.getCell('A4').value = 'PROVINCE:';
    m1Sheet.getCell('B4').value = payload.province;
    m1Sheet.getCell('D4').value = 'MUNICIPALITY:';
    m1Sheet.getCell('E4').value = payload.municipality;

    m1Sheet.getCell('A5').value = 'BARANGAY:';
    m1Sheet.getCell('B5').value = payload.barangayName;
    m1Sheet.getCell('D5').value = 'DATE EXPORTED:';
    m1Sheet.getCell('E5').value = new Date().toISOString().split('T')[0];

    ['A4', 'D4', 'A5', 'D5'].forEach((cell) => {
      m1Sheet.getCell(cell).font = { name: 'Arial', size: 9, bold: true, color: { argb: 'FF64748B' } };
    });
    ['B4', 'E4', 'B5', 'E5'].forEach((cell) => {
      m1Sheet.getCell(cell).font = { name: 'Arial', size: 9, bold: true };
    });

    const colHeaders = [
      'NO.',
      'INDICATOR DESCRIPTION',
      'ELIGIBLE POPULATION',
      'ACCOMPLISHED',
      '% ACCOMPLISHED',
      'REMARKS',
    ];
    const headerRowIndex = 7;
    const headerRow = m1Sheet.getRow(headerRowIndex);
    headerRow.values = colHeaders;
    headerRow.height = 24;

    for (let c = 1; c <= 6; c++) {
      const cell = headerRow.getCell(c);
      cell.font = { name: 'Arial', size: 9, bold: true, color: { argb: 'FFFFFFFF' } };
      cell.fill = {
        type: 'pattern',
        pattern: 'solid',
        fgColor: { argb: 'FF1E293B' },
      };
      cell.alignment = { horizontal: 'center', vertical: 'middle' };
      cell.border = {
        top: { style: 'thin' },
        left: { style: 'thin' },
        bottom: { style: 'medium' },
        right: { style: 'thin' },
      };
    }

    const m1Rows = [
      {
        no: 1,
        name: 'Pregnant Women with At Least 4 Prenatal Visits',
        target: payload.maternalMetrics.totalTargetMaternal,
        val: payload.maternalMetrics.prenatalFourVisitsOrMore,
        remarks: 'Target prenatal tracking',
      },
      {
        no: 2,
        name: 'Pregnant Women Screened in 1st Trimester',
        target: payload.maternalMetrics.totalTargetMaternal,
        val: payload.maternalMetrics.prenatalFirstTrimester,
        remarks: 'Early registration marker',
      },
      {
        no: 3,
        name: 'High-Risk Pregnancies Detected (Preeclampsia/Hypertension)',
        target: payload.maternalMetrics.totalTargetMaternal,
        val: payload.maternalMetrics.highRiskPreeclampsiaDetected,
        remarks: 'BPH Referral Protocol Initiated',
      },
      {
        no: 4,
        name: 'Pregnant Women Provided with Complete Iron-Folic Acid',
        target: payload.maternalMetrics.totalTargetMaternal,
        val: payload.maternalMetrics.ironFolicAcidSupplemented,
        remarks: 'Micronutrient supplementation',
      },
      {
        no: 5,
        name: 'Infants Given BCG at Birth',
        target: 25,
        val: payload.immunizationMetrics.bcgDose1,
        remarks: 'Routine EPI Schedule',
      },
      {
        no: 6,
        name: 'Infants Given HepB Dose 1 within 24 Hours',
        target: 25,
        val: payload.immunizationMetrics.hepbDose1,
        remarks: 'Routine EPI Schedule',
      },
      {
        no: 7,
        name: 'Infants Given Pentavalent Vaccine Dose 1',
        target: 25,
        val: payload.immunizationMetrics.pentaDose1,
        remarks: 'Routine EPI Schedule',
      },
      {
        no: 8,
        name: 'Infants Given Pentavalent Vaccine Dose 2',
        target: 25,
        val: payload.immunizationMetrics.pentaDose2,
        remarks: 'Routine EPI Schedule',
      },
      {
        no: 9,
        name: 'Infants Given Oral Polio Vaccine (OPV) Dose 1',
        target: 25,
        val: payload.immunizationMetrics.opvDose1,
        remarks: 'Routine EPI Schedule',
      },
    ];

    let currentRow = 8;
    m1Rows.forEach((rowItem) => {
      const r = m1Sheet.getRow(currentRow);
      const percent = rowItem.target > 0 ? (rowItem.val / rowItem.target) * 100 : 0;

      r.values = [
        rowItem.no,
        rowItem.name,
        rowItem.target,
        rowItem.val,
        `${percent.toFixed(1)}%`,
        rowItem.remarks,
      ];

      r.getCell(1).alignment = { horizontal: 'center' };
      r.getCell(3).alignment = { horizontal: 'right' };
      r.getCell(4).alignment = { horizontal: 'right' };
      r.getCell(5).alignment = { horizontal: 'right' };

      for (let c = 1; c <= 6; c++) {
        r.getCell(c).border = {
          top: { style: 'thin', color: { argb: 'FFE2E8F0' } },
          left: { style: 'thin', color: { argb: 'FFE2E8F0' } },
          bottom: { style: 'thin', color: { argb: 'FFE2E8F0' } },
          right: { style: 'thin', color: { argb: 'FFE2E8F0' } },
        };
        r.getCell(c).font = { name: 'Arial', size: 9 };
      }
      currentRow++;
    });

    // ---------------------------------------------------------
    // Worksheet 2: Child Malnutrition (Operation Timbang Plus)
    // ---------------------------------------------------------
    const optSheet = workbook.addWorksheet('FHSIS M2 - OPT Plus Child Nutrition', {
      views: [{ showGridLines: true }],
    });

    optSheet.columns = [
      { width: 10 },
      { width: 35 },
      { width: 18 },
      { width: 18 },
      { width: 30 },
    ];

    optSheet.mergeCells('A1:E1');
    const optTitle = optSheet.getCell('A1');
    optTitle.value = 'OPERATION TIMBANG PLUS (OPT) SUMMARY • PRESCHOOLERS 0-59 MONTHS';
    optTitle.font = { name: 'Arial', size: 11, bold: true, color: { argb: 'FFFFFFFF' } };
    optTitle.fill = {
      type: 'pattern',
      pattern: 'solid',
      fgColor: { argb: 'FF15803D' },
    };
    optTitle.alignment = { horizontal: 'center', vertical: 'middle' };
    optSheet.getRow(1).height = 26;

    const optHeaders = [
      'CLASS',
      'NUTRITIONAL STATUS',
      'CHILD COUNT',
      'PREVALENCE RATE',
      'INTERVENTION PROTOCOL',
    ];
    const optHeadRow = optSheet.getRow(3);
    optHeadRow.values = optHeaders;
    for (let c = 1; c <= 5; c++) {
      const cell = optHeadRow.getCell(c);
      cell.font = { name: 'Arial', size: 9, bold: true, color: { argb: 'FFFFFFFF' } };
      cell.fill = {
        type: 'pattern',
        pattern: 'solid',
        fgColor: { argb: 'FF1E293B' },
      };
      cell.alignment = { horizontal: 'center', vertical: 'middle' };
    }

    const totalOpt = payload.nutritionOptMetrics.totalMeasuredPreschoolers;
    const optData = [
      {
        class: 'Normal',
        desc: 'Normal Weight-for-Length/Height',
        count: payload.nutritionOptMetrics.normalStatus,
        intervention: 'Routine Community Growth Monitoring',
      },
      {
        class: 'Stunted',
        desc: 'Moderately Stunted (HAZ < -2 SD)',
        count: payload.nutritionOptMetrics.moderatelyStunted,
        intervention: 'Supplementary Feeding (LGU RHU Naval)',
      },
      {
        class: 'Wasted',
        desc: 'Severely Wasted (WHZ < -3 SD)',
        count: payload.nutritionOptMetrics.severelyWasted,
        intervention: 'Ready-to-Use Therapeutic Food (RUTF) / Clinical Admittance',
      },
    ];

    let optRowIdx = 4;
    optData.forEach((row) => {
      const prev = totalOpt > 0 ? (row.count / totalOpt) * 100 : 0;
      const r = optSheet.getRow(optRowIdx);
      r.values = [row.class, row.desc, row.count, `${prev.toFixed(1)}%`, row.intervention];
      r.getCell(3).alignment = { horizontal: 'right' };
      r.getCell(4).alignment = { horizontal: 'right' };
      for (let c = 1; c <= 5; c++) {
        r.getCell(c).font = { name: 'Arial', size: 9 };
        r.getCell(c).border = {
          top: { style: 'thin', color: { argb: 'FFE2E8F0' } },
          bottom: { style: 'thin', color: { argb: 'FFE2E8F0' } },
        };
      }
      optRowIdx++;
    });

    // ---------------------------------------------------------
    // Worksheet 3: Live Edge Sync Registry (Firestore Encounters)
    // ---------------------------------------------------------
    if (payload.liveSyncedEncounters && payload.liveSyncedEncounters.length > 0) {
      const logSheet = workbook.addWorksheet('Live Edge Sync Registry', {
        views: [{ showGridLines: true }],
      });

      logSheet.columns = [
        { width: 22 },
        { width: 18 },
        { width: 24 },
        { width: 20 },
        { width: 12 },
        { width: 14 },
        { width: 42 },
      ];

      logSheet.mergeCells('A1:G1');
      const logTitle = logSheet.getCell('A1');
      logTitle.value = 'PINTIG EDGE-TO-CLOUD VERIFIED FIELD ENCOUNTERS LOG (BRGY. P.I. GARCIA)';
      logTitle.font = { name: 'Arial', size: 11, bold: true, color: { argb: 'FFFFFFFF' } };
      logTitle.fill = {
        type: 'pattern',
        pattern: 'solid',
        fgColor: { argb: 'FF0284C7' },
      };
      logTitle.alignment = { horizontal: 'center', vertical: 'middle' };
      logSheet.getRow(1).height = 26;

      const logHeadRow = logSheet.getRow(3);
      logHeadRow.values = [
        'TIMESTAMP (UTC)',
        'TCL MODULE',
        'PATIENT NAME',
        'SITIO / PUROK',
        'CDSS RISK',
        'BHW OFFICER',
        'CLINICAL SUMMARY / VITALS',
      ];
      for (let c = 1; c <= 7; c++) {
        const cell = logHeadRow.getCell(c);
        cell.font = { name: 'Arial', size: 9, bold: true, color: { argb: 'FFFFFFFF' } };
        cell.fill = {
          type: 'pattern',
          pattern: 'solid',
          fgColor: { argb: 'FF1E293B' },
        };
      }

      let logRowIdx = 4;
      payload.liveSyncedEncounters.forEach((enc) => {
        const r = logSheet.getRow(logRowIdx);
        r.values = [
          enc.timestamp,
          enc.encounterType,
          enc.patientName,
          enc.sitioPurok,
          enc.riskLevel,
          enc.bhwId,
          enc.clinicalSummary,
        ];
        for (let c = 1; c <= 7; c++) {
          r.getCell(c).font = { name: 'Arial', size: 9 };
        }
        logRowIdx++;
      });
    }

    // Write file buffer and initiate browser download
    const buffer = await workbook.xlsx.writeBuffer();
    const blob = new Blob([buffer], {
      type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    });

    const filename = `DOH_FHSIS_${payload.municipality}_${payload.barangayName}_${payload.reportingYear}_${payload.reportingMonth}.xlsx`;
    const downloadUrl = window.URL.createObjectURL(blob);
    const anchor = document.createElement('a');
    anchor.href = downloadUrl;
    anchor.download = filename;
    document.body.appendChild(anchor);
    anchor.click();
    document.body.removeChild(anchor);
    window.URL.revokeObjectURL(downloadUrl);
  }
}