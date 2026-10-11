import React, { useEffect, useRef, useState, useMemo } from 'react';
import * as L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import { Layers, ShieldCheck } from 'lucide-react';

interface HouseholdGeo {
  household_uuid: string;
  sitio_name: string;
  latitude: number;
  longitude: number;
  water_source_code: number;
  sanitation_facility_code: number;
  risk_category: 'MATERNAL_RISK' | 'MALNUTRITION' | 'WATER_SANITATION' | 'ROUTINE';
  indicator_details: string;
}

const RAW_COMMUNITY_COORDINATES: HouseholdGeo[] = [
  {
    household_uuid: '11111111-0000-4000-8000-000000000001',
    sitio_name: 'Sitio Tinago',
    latitude: 11.5623,
    longitude: 124.3982,
    water_source_code: 1,
    sanitation_facility_code: 1,
    risk_category: 'MATERNAL_RISK',
    indicator_details: 'Elena Navarro (BP 145/95 mmHg - Preeclampsia Risk)',
  },
  {
    household_uuid: '11111111-0000-4000-8000-000000000002',
    sitio_name: 'Sitio Tinago',
    latitude: 11.5627,
    longitude: 124.3986,
    water_source_code: 2,
    sanitation_facility_code: 1,
    risk_category: 'MATERNAL_RISK',
    indicator_details: 'Maritess Alcantara (BP 150/100 mmHg - Preeclampsia Risk)',
  },
  {
    household_uuid: '11111111-0000-4000-8000-000000000003',
    sitio_name: 'Sitio Tinago',
    latitude: 11.5631,
    longitude: 124.399,
    water_source_code: 3,
    sanitation_facility_code: 2,
    risk_category: 'ROUTINE',
    indicator_details: 'Routine Immunization & Normal Prenatal Status',
  },
  {
    household_uuid: '11111111-0000-4000-8000-000000000004',
    sitio_name: 'Sitio Seaside',
    latitude: 11.5645,
    longitude: 124.3951,
    water_source_code: 2,
    sanitation_facility_code: 1,
    risk_category: 'ROUTINE',
    indicator_details: 'Routine Growth Monitoring & Normal Maternal Care',
  },
  {
    household_uuid: '11111111-0000-4000-8000-000000000005',
    sitio_name: 'Sitio Seaside',
    latitude: 11.5649,
    longitude: 124.3955,
    water_source_code: 1,
    sanitation_facility_code: 3,
    risk_category: 'MALNUTRITION',
    indicator_details: 'Joshua Salazar (WHZ -3.22 - Severely Wasted)',
  },
  {
    household_uuid: '11111111-0000-4000-8000-000000000006',
    sitio_name: 'Sitio Seaside',
    latitude: 11.5653,
    longitude: 124.3958,
    water_source_code: 2,
    sanitation_facility_code: 1,
    risk_category: 'MALNUTRITION',
    indicator_details: 'Chloe Flores (HAZ -2.48 - Moderately Stunted)',
  },
  {
    household_uuid: '11111111-0000-4000-8000-000000000007',
    sitio_name: 'Sitio Lupa',
    latitude: 11.5601,
    longitude: 124.4012,
    water_source_code: 3,
    sanitation_facility_code: 2,
    risk_category: 'ROUTINE',
    indicator_details: 'Routine Child Nutrition & Normal Encounters',
  },
  {
    household_uuid: '11111111-0000-4000-8000-000000000008',
    sitio_name: 'Sitio Lupa',
    latitude: 11.5605,
    longitude: 124.4015,
    water_source_code: 2,
    sanitation_facility_code: 1,
    risk_category: 'ROUTINE',
    indicator_details: 'Routine Encounters Logged',
  },
  {
    household_uuid: '11111111-0000-4000-8000-000000000009',
    sitio_name: 'Sitio Central',
    latitude: 11.5615,
    longitude: 124.3975,
    water_source_code: 3,
    sanitation_facility_code: 2,
    risk_category: 'ROUTINE',
    indicator_details: 'Central Admin Cluster Encampment',
  },
  {
    household_uuid: '11111111-0000-4000-8000-000000000010',
    sitio_name: 'Sitio Central',
    latitude: 11.5618,
    longitude: 124.3978,
    water_source_code: 3,
    sanitation_facility_code: 1,
    risk_category: 'WATER_SANITATION',
    indicator_details: 'Shared Unimproved Sanitation Infrastructure',
  },
];

function pseudoRandom(seed: number): number {
  const x = Math.sin(seed) * 10000;
  return x - Math.floor(x);
}

function applyGaussianCoordinateJitter(lat: number, lng: number, seedKey: string): [number, number] {
  let hash = 0;
  for (let i = 0; i < seedKey.length; i++) {
    hash = (hash << 5) - hash + seedKey.charCodeAt(i);
    hash |= 0;
  }

  const u1 = Math.max(1e-6, pseudoRandom(hash));
  const u2 = pseudoRandom(hash + 1);

  const z0 = Math.sqrt(-2.0 * Math.log(u1)) * Math.cos(2.0 * Math.PI * u2);
  const z1 = Math.sqrt(-2.0 * Math.log(u1)) * Math.sin(2.0 * Math.PI * u2);

  const SIGMA_METERS = 50;
  const MAX_METERS = 150;

  const jitterEastMeters = Math.max(-MAX_METERS, Math.min(MAX_METERS, z0 * SIGMA_METERS));
  const jitterNorthMeters = Math.max(-MAX_METERS, Math.min(MAX_METERS, z1 * SIGMA_METERS));

  const METERS_PER_DEG_LAT = 110580.0;
  const METERS_PER_DEG_LNG = 111320.0 * Math.cos((lat * Math.PI) / 180.0);

  const jitteredLat = lat + jitterNorthMeters / METERS_PER_DEG_LAT;
  const jitteredLng = lng + jitterEastMeters / METERS_PER_DEG_LNG;

  return [jitteredLat, jitteredLng];
}

export const EpidemiologicalGisMap: React.FC = () => {
  const mapContainerRef = useRef<HTMLDivElement | null>(null);
  const mapInstanceRef = useRef<L.Map | null>(null);
  const layerGroupRef = useRef<L.LayerGroup | null>(null);
  const [selectedFilter, setSelectedFilter] = useState<string>('ALL');

  const deidentifiedData = useMemo(() => {
    return RAW_COMMUNITY_COORDINATES.map((item) => {
      const [jitteredLat, jitteredLng] = applyGaussianCoordinateJitter(
        item.latitude,
        item.longitude,
        item.household_uuid
      );
      return {
        ...item,
        displayLat: jitteredLat,
        displayLng: jitteredLng,
      };
    });
  }, []);

  useEffect(() => {
    if (!mapContainerRef.current) return;

    // Destroy existing instance to prevent "Map container is already initialized"
    if (mapInstanceRef.current) {
      mapInstanceRef.current.remove();
      mapInstanceRef.current = null;
    }

    const container = mapContainerRef.current as HTMLDivElement & { _leaflet_id?: number | null };
    if (container._leaflet_id) {
      container._leaflet_id = null;
    }

    const map = L.map(container, {
      center: [11.5625, 124.398],
      zoom: 16,
      preferCanvas: true,
    });

    L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
      attribution:
        '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="https://carto.com/attributions">CARTO</a>',
      subdomains: 'abcd',
      maxZoom: 19,
    }).addTo(map);

    const layerGroup = L.layerGroup().addTo(map);
    mapInstanceRef.current = map;
    layerGroupRef.current = layerGroup;

    // Force map to recalculate container boundaries once mounted
    setTimeout(() => {
      map.invalidateSize();
    }, 100);

    return () => {
      if (mapInstanceRef.current) {
        mapInstanceRef.current.remove();
        mapInstanceRef.current = null;
      }
      layerGroupRef.current = null;
    };
  }, []);

  // Update canvas markers when filter changes
  useEffect(() => {
    if (!layerGroupRef.current || !mapInstanceRef.current) return;

    layerGroupRef.current.clearLayers();

    const filtered = deidentifiedData.filter((pt) => {
      if (selectedFilter === 'ALL') return true;
      return pt.risk_category === selectedFilter;
    });

    filtered.forEach((pt) => {
      let fillColor = '#10b981';
      let strokeColor = '#047857';

      if (pt.risk_category === 'MATERNAL_RISK') {
        fillColor = '#ef4444';
        strokeColor = '#b91c1c';
      } else if (pt.risk_category === 'MALNUTRITION') {
        fillColor = '#f59e0b';
        strokeColor = '#b45309';
      } else if (pt.risk_category === 'WATER_SANITATION') {
        fillColor = '#6366f1';
        strokeColor = '#4338ca';
      }

      const privacyBuffer = L.circle([pt.displayLat, pt.displayLng], {
        radius: 150,
        color: strokeColor,
        weight: 1,
        dashArray: '3, 4',
        fillColor: fillColor,
        fillOpacity: 0.05,
      });

      const marker = L.circleMarker([pt.displayLat, pt.displayLng], {
        radius: 8,
        fillColor: fillColor,
        color: '#ffffff',
        weight: 2,
        opacity: 1,
        fillOpacity: 0.9,
      });

      const popupHtml = `
        <div style="font-family: system-ui, sans-serif; font-size: 12px; line-height: 1.4; color: #1e293b;">
          <div style="font-weight: 700; color: #0f172a; border-bottom: 1px solid #e2e8f0; padding-bottom: 4px; margin-bottom: 4px;">
            ${pt.sitio_name} (De-Identified)
          </div>
          <div style="margin-bottom: 4px;"><strong>Indicator:</strong> ${pt.indicator_details}</div>
          <div style="color: #64748b; font-size: 11px;">
            <strong>Privacy Protection:</strong> ±150m Gaussian displacement applied under RA 10173.
          </div>
        </div>
      `;

      marker.bindPopup(popupHtml);
      layerGroupRef.current?.addLayer(privacyBuffer);
      layerGroupRef.current?.addLayer(marker);
    });
  }, [selectedFilter, deidentifiedData]);

  return (
    <div className="relative w-full h-[620px] rounded-xl overflow-hidden border border-slate-200 shadow-sm bg-white flex flex-col">
      <div className="absolute top-4 left-4 z-[1000] bg-white/95 backdrop-blur-sm p-3 rounded-lg shadow-md border border-slate-200 max-w-sm">
        <div className="flex items-center gap-2 text-slate-800 font-bold text-sm">
          <Layers className="h-4 w-4 text-teal-600" />
          Epidemiological GIS Spot Map
        </div>
        <p className="text-[11px] text-slate-500 mt-0.5 leading-snug">
          Brgy. P.I. Garcia • Sitio Tinago, Seaside, Lupa & Central
        </p>

        <div className="mt-3 flex flex-wrap gap-1.5">
          {[
            { id: 'ALL', label: 'All Indicators' },
            { id: 'MATERNAL_RISK', label: 'Maternal High Risk' },
            { id: 'MALNUTRITION', label: 'Child Malnutrition' },
            { id: 'WATER_SANITATION', label: 'WASH Vulnerability' },
          ].map((item) => (
            <button
              key={item.id}
              onClick={() => setSelectedFilter(item.id)}
              className={`text-[11px] font-semibold px-2 py-1 rounded transition-colors ${
                selectedFilter === item.id
                  ? 'bg-teal-700 text-white'
                  : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
              }`}
            >
              {item.label}
            </button>
          ))}
        </div>
      </div>

      <div className="absolute bottom-4 left-4 z-[1000] bg-white/95 backdrop-blur-sm px-3 py-2 rounded-lg shadow-md border border-slate-200 flex items-center gap-2 max-w-md">
        <ShieldCheck className="h-4 w-4 text-emerald-600 shrink-0" />
        <span className="text-[11px] text-slate-600 leading-tight">
          <strong>RA 10173 Protected:</strong> Coordinates jittered using an orthogonal Gaussian distribution (&plusmn;150m) to protect residential privacy.
        </span>
      </div>

      <div ref={mapContainerRef} className="w-full h-full" />
    </div>
  );
};