/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        'pintig-blue': '#0D47A1',
        'pintig-green': '#1B5E20',
        'pintig-amber': '#E65100',
        'pintig-red': '#B71C1C',
      },
    },
  },
  plugins: [],
}