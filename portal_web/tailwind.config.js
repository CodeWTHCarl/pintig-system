/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['"Atkinson Hyperlegible Next"', '"Atkinson Hyperlegible"', 'system-ui', 'sans-serif'],
      },
      colors: {
        // Pintig brand (from the logo) and neutrals
        'pintig-crimson': '#C81E2B',
        'pintig-crimson-ink': '#8E1621',
        'pintig-coral': '#EF4444',
        'pintig-ivory': '#FAF8F5',
        'pintig-ink': '#14202B',
        'pintig-paper': '#F3F5F6',
        'pintig-line': '#E3E8EB',
        'pintig-muted': '#4A5966',
        'pintig-field': '#8A99A5',
        // Status: tints carry dark text, solids carry white text
        'pintig-sea': '#0B6E74',
        'pintig-sea-tint': '#DDF0F1',
        'pintig-sea-ink': '#084F54',
        'pintig-amber': '#B45309',
        'pintig-amber-tint': '#FFF0CF',
        'pintig-amber-ink': '#5C3A00',
        'pintig-rose-tint': '#FCE8EA',
        // Legacy names, kept so nothing that referenced them breaks
        'pintig-blue': '#0D47A1',
        'pintig-green': '#1B5E20',
        'pintig-red': '#B71C1C',
      },
    },
  },
  plugins: [],
}
