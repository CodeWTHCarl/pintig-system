// Reporting periods. The mobile sync writes monthly aggregates under the month of
// each encounter's timestamp (YYYY-MM), so the portal must read the same key.

export const MONTH_NAMES = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

export function monthKeyOf(date: Date): string {
  // UTC to match timestamp.substring(0, 7) on ISO strings written by the app.
  return date.toISOString().slice(0, 7);
}

export function currentMonthKey(): string {
  return monthKeyOf(new Date());
}

export function monthLabel(key: string): string {
  const [y, m] = key.split('-').map(Number);
  return `${MONTH_NAMES[(m || 1) - 1]} ${y}`;
}

export function monthParts(key: string): { year: number; monthName: string } {
  const [y, m] = key.split('-').map(Number);
  return { year: y, monthName: MONTH_NAMES[(m || 1) - 1] };
}

/** The current month and the months before it, newest first. */
export function recentMonthKeys(count = 3): string[] {
  const now = new Date();
  const keys: string[] = [];
  for (let i = 0; i < count; i++) {
    keys.push(monthKeyOf(new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() - i, 1))));
  }
  return keys;
}
