# Pintig UI/UX pass

Copy these files over your repo (same paths). Nothing was removed: every route, provider,
notifier call, Firestore path and sync call is unchanged. Only the UI layer changed, plus two
small additions listed under "New behaviour".

## Run after copying
- Mobile: `cd client_mobile && flutter pub get && flutter analyze && flutter run`
  (new font and image assets are declared in pubspec.yaml)
- Web: `cd portal_web && npm install && npm run build` (this passes `tsc` and `vite build`)

## Not verified
- The Flutter code was NOT compiled or run (no Flutter SDK here). Bracket balance and APIs were
  checked by hand. Please run `flutter analyze` first and send me anything it flags.
- Nothing was screenshotted. Check both surfaces on a real phone in daylight.

## Design system
- Logo: the real Pintig mark (cropped from `pintig_logo.png`) on the logo's ivory, in the app header and portal rail.
- Palette from the logo: crimson `#C81E2B`, coral `#EF4444` (the logo's dot), ink `#14202B`,
  paper `#F3F5F6`, sea teal `#0B6E74`. Alerts are tints with dark text, not white on solid colour.
- Font: Atkinson Hyperlegible (bundled in the app so it works offline, OFL licence included;
  Google Fonts link in the portal).
- Icons: a custom set (`pintig_icons.dart`, `PintigIcons.tsx`) with rounded strokes and one coral dot,
  echoing the logo. Same path data on both platforms. No Material or lucide icons are used any more.

## Mobile
- Home: compact header, three visit types in one list, sync status pinned at the bottom with plain wording.
- Forms: sectioned, units inside the fields, the triage result pinned above Save so it is never
  scrolled out of view, plain button labels, readable status text (no `SEVERELYWASTED`).
- Shared widgets in `accessible_form_widgets.dart`: `PintigScreenHeader`, `PintigActionBar`,
  `PintigDropdownField`, `PintigToggleRow`, `PintigSectionTitle`. `PintigCdssBanner` now takes
  `tone` and `icon` instead of `backgroundColor` and `IconData`.
- Routine "no reaction" banner on the vaccination form was removed (it showed on every visit).

## Portal
- Alert queue is the first thing on the page, oldest first, with waiting time. Open the case on the right.
- "Need action" counts only open cases. Referral asks for confirmation. Notes no longer claim
  "Emergency referral dispatched"; they record the decision only.
- Reporting month defaults to the current month and has a selector. It was hardcoded to 2026-10,
  while the app writes aggregates under each record's own month.
- Counts are filtered to the selected month; open alerts from any month always stay visible.
- Removed: "PRO" badge, fake "pintig-219" id, "Spark Quota Cost", raw UUID fragments, the
  "RA 10173 compliant" badge (see below). "Reset Demo Slate" moved into a collapsed "Demo tools".
- Rail collapses to a top bar on small screens. Connection status now reflects `navigator.onLine`.

## New behaviour (not just visuals)
1. `rhu_updates_provider.dart`: the app reads back the alerts the RHU acted on and shows them on the
   home screen. It is read-only, fails silently offline, and refreshes after each send and on pull-down.
2. `config/period.ts` on the portal (month handling above).

## Still to do (not UI)
- `firestore.rules` allows read and write to anyone (`if true`) on patient and encounter data, and
  the Firebase key is in source. Lock this down before any real pilot.
- Home has no patient search yet: the app has no patient-list query, and the three visit types
  still use the demo patient. Needs a DAO method first.
- Move the duplicated project constants (project id, key, tenant) into one config file.
