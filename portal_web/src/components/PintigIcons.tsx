// Pintig icon set: rounded strokes and one coral dot, echoing the logo's loop-and-dot mark.
// Same path data as client_mobile/lib/presentation/widgets/pintig_icons.dart.
import React from 'react';

export type PintigIconName =
'prenatal'
  | 'child'
  | 'vaccine'
  | 'send'
  | 'saved'
  | 'waiting'
  | 'alert'
  | 'calendar'
  | 'chevronR'
  | 'chevronL'
  | 'pin'
  | 'check'
  | 'refer'
  | 'map'
  | 'report'
  | 'search'
  | 'standing'
  | 'recumbent'
  | 'info';

const ICONS: Record<PintigIconName, { paths: string[]; dots: [number, number, number][] }> = {
  prenatal: { paths: ["M12.5 5 C12.5 6.38075 11.380749999999999 7.5 10 7.5 C8.619250000000001 7.5 7.5 6.38075 7.5 5 C7.5 3.61925 8.619250000000001 2.5 10 2.5 C11.380749999999999 2.5 12.5 3.61925 12.5 5 Z", "M10 9.5 C7.5 10.5 7 13 8 16 L8.5 21", "M10 9.5 C13 9.5 16.5 12 16.5 15.5 C16.5 18 14.5 19.5 12.5 19.5 L12.5 21"], dots: [[13.2, 14.6, 1.3]] },
  child: { paths: ["M14.5 5.5 C14.5 6.88075 13.380749999999999 8.0 12 8.0 C10.619250000000001 8.0 9.5 6.88075 9.5 5.5 C9.5 4.11925 10.619250000000001 3.0 12 3.0 C13.380749999999999 3.0 14.5 4.11925 14.5 5.5 Z", "M12 9.5 C9 9.5 7.5 12 7.5 14.5 L7.5 21 L16.5 21 L16.5 14.5 C16.5 12 15 9.5 12 9.5 Z"], dots: [[12, 15.3, 1.3]] },
  vaccine: { paths: ["M7 13 L11 17 L17.5 10.5 L13.5 6.5 Z", "M9 15 L4.5 19.5", "M15.5 8.5 L18.5 5.5", "M17 4 L20 7"], dots: [[12.25, 11.75, 1.1]] },
  send: { paths: ["M19 12 C19 8 15.5 5 12 5 C9.5 5 7.5 6.2 6.2 8", "M6 4.5 L6.2 8 L9.8 8.3", "M5 12 C5 16 8.5 19 12 19 C14.5 19 16.5 17.8 17.8 16", "M18 19.5 L17.8 16 L14.2 15.7"], dots: [[12, 12, 1.6]] },
  saved: { paths: ["M7 3 L17 3 C18.1 3 19 3.9 19 5 L19 19 C19 20.1 18.1 21 17 21 L7 21 C5.9 21 5 20.1 5 19 L5 5 C5 3.9 5.9 3 7 3 Z", "M8.8 11.3 L11 13.5 L15.4 8.8"], dots: [[12, 17.6, 1]] },
  waiting: { paths: ["M20.5 12 C20.5 16.69455 16.69455 20.5 12 20.5 C7.3054499999999996 20.5 3.5 16.69455 3.5 12 C3.5 7.3054499999999996 7.3054499999999996 3.5 12 3.5 C16.69455 3.5 20.5 7.3054499999999996 20.5 12 Z", "M12 12 L12 7.5", "M12 12 L15.2 14"], dots: [[12, 12, 1.5]] },
  alert: { paths: ["M8.5 8.5 C6.2 10.8 6.2 13.2 8.5 15.5", "M5.5 5.5 C1.8 9.3 1.8 14.7 5.5 18.5", "M15.5 8.5 C17.8 10.8 17.8 13.2 15.5 15.5", "M18.5 5.5 C22.2 9.3 22.2 14.7 18.5 18.5"], dots: [[12, 12, 2.2]] },
  calendar: { paths: ["M5 6 L19 6 C20.1 6 21 6.9 21 8 L21 19 C21 20.1 20.1 21 19 21 L5 21 C3.9 21 3 20.1 3 19 L3 8 C3 6.9 3.9 6 5 6 Z", "M3 10.5 L21 10.5", "M8 3.5 L8 7.5", "M16 3.5 L16 7.5"], dots: [[12, 15.5, 1.4]] },
  chevronR: { paths: ["M9 5 C11.5 8 14 10 15.5 12 C14 14 11.5 16 9 19"], dots: [] },
  chevronL: { paths: ["M15 5 C12.5 8 10 10 8.5 12 C10 14 12.5 16 15 19"], dots: [] },
  pin: { paths: ["M12 21 C12 21 5.5 15 5.5 10 C5.5 6.4 8.4 3.5 12 3.5 C15.6 3.5 18.5 6.4 18.5 10 C18.5 15 12 21 12 21 Z"], dots: [[12, 10, 2.2]] },
  check: { paths: ["M5 12.5 L10 17.5 L19 7"], dots: [] },
  refer: { paths: ["M14 4 L20 4 L20 10", "M20 4 L11 13", "M17 14 L17 18 C17 19.1 16.1 20 15 20 L6 20 C4.9 20 4 19.1 4 18 L4 9 C4 7.9 4.9 7 6 7 L10 7"], dots: [[8.5, 16, 1.2]] },
  map: { paths: ["M3 6 L9 4 L15 6 L21 4 L21 18 L15 20 L9 18 L3 20 Z", "M9 4 L9 18", "M15 6 L15 20"], dots: [[12, 12, 1.4]] },
  report: { paths: ["M7 3 L14.5 3 L19 7.5 L19 19 C19 20.1 18.1 21 17 21 L7 21 C5.9 21 5 20.1 5 19 L5 5 C5 3.9 5.9 3 7 3 Z", "M14 3 L14 8 L19 8", "M8.5 12.5 L15.5 12.5"], dots: [[11, 16.5, 1.2]] },
  search: { paths: ["M16.5 10.5 C16.5 13.8138 13.8138 16.5 10.5 16.5 C7.1861999999999995 16.5 4.5 13.8138 4.5 10.5 C4.5 7.1861999999999995 7.1861999999999995 4.5 10.5 4.5 C13.8138 4.5 16.5 7.1861999999999995 16.5 10.5 Z", "M15 15 L20 20"], dots: [[10.5, 10.5, 1.5]] },
  standing: { paths: ["M14 4.5 C14 5.6046 13.1046 6.5 12 6.5 C10.8954 6.5 10 5.6046 10 4.5 C10 3.3954 10.8954 2.5 12 2.5 C13.1046 2.5 14 3.3954 14 4.5 Z", "M12 8 L12 15", "M8.5 10 L15.5 10", "M12 15 L9.5 21", "M12 15 L14.5 21"], dots: [] },
  recumbent: { paths: ["M7 12.5 C7 13.6046 6.1046 14.5 5 14.5 C3.8954 14.5 3 13.6046 3 12.5 C3 11.3954 3.8954 10.5 5 10.5 C6.1046 10.5 7 11.3954 7 12.5 Z", "M8 12.5 L16 12.5", "M16 12.5 L21 10.5", "M16 12.5 L21 15.5", "M3 19 L21 19"], dots: [] },
  info: { paths: ["M20.5 12 C20.5 16.69455 16.69455 20.5 12 20.5 C7.3054499999999996 20.5 3.5 16.69455 3.5 12 C3.5 7.3054499999999996 7.3054499999999996 3.5 12 3.5 C16.69455 3.5 20.5 7.3054499999999996 20.5 12 Z", "M12 11 L12 16.5"], dots: [[12, 7.6, 1.2]] },
};

interface PintigIconProps {
  name: PintigIconName;
  size?: number;
  className?: string;
  /** Show the coral accent dot. */
  dot?: boolean;
  /** Accessible name. Omit for decorative icons. */
  label?: string;
}

export const PintigIcon: React.FC<PintigIconProps> = ({ name, size = 20, className, dot = true, label }) => {
  const spec = ICONS[name];
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={2}
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
      role={label ? 'img' : undefined}
      aria-label={label}
      aria-hidden={label ? undefined : true}
    >
      {spec.paths.map((d, i) => (
        <path key={i} d={d} />
      ))}
      {dot &&
        spec.dots.map(([cx, cy, r], i) => (
          <circle key={i} cx={cx} cy={cy} r={r} fill="#EF4444" stroke="none" />
        ))}
    </svg>
  );
};
