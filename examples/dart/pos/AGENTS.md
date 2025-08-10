# Repository Guidelines

## Project Structure & Module Organization
- `lib/app`: app bootstrap, routing (`go_router`), theming.
- `lib/core`: shared services, database (Drift/SQLite), models.
- `lib/features`: feature modules (e.g., appointments, customers, employees).
- `lib/utils`: helpers and cross-cutting utilities.
- `assets/`: `database/pos.db`, `mock.json`, `backgrounds/`.
- `test/`: unit/widget tests; subfolders `integration/`, `performance/`.

## Architecture Overview
- State management: Riverpod 3 providers (`flutter_riverpod` + `riverpod_generator`) for DI and reactive state.
- Navigation: `go_router` with typed routes in `lib/app`.
- Data layer: repositories/services in `lib/core` backed by Drift (SQLite) for local persistence; network via `dio`/`http` when applicable.
- Models: `freezed` + `json_serializable` with generated `*.freezed.dart`/`*.g.dart`.
- Caching & storage: `shared_preferences` for simple flags; `flutter_secure_storage` for sensitive tokens.
- UI: feature-first widgets in `lib/features`, theme in `lib/app`.

## Migration Policy (UI + Riverpod)
- Preserve original UI layout and styles; replace state with Riverpod providers (no large UI rewrites).
- Keep screens thin; compose from smaller widgets; move logic to providers/repositories.
- Provider mapping: DI=`Provider`, UI state=`StateProvider<T>`, sync domain=`Notifier<T>`, async fetch=`AsyncNotifier<T>`, live data=`StreamNotifier<T>`.
- Watch small with `.select`, read in callbacks; use `AsyncValueWidget.fromProvider` for async sections.
- Refresh via `ref.invalidate`/`ref.refresh`; see `docs/RIVERPOD_UI_BIBLE.md` for patterns.

## Build, Test, and Development Commands
- Install deps: `flutter pub get`.
- Generate code: `dart run build_runner build --delete-conflicting-outputs`.
- Analyze/lint: `flutter analyze` (uses `flutter_lints` + `custom_lint`).
- Run app: `flutter run -d windows` (or another device).
- Run tests: `flutter test` (e.g., `flutter test test/appointments_screen_test.dart`).
- Build desktop: `flutter build windows`; Android: `flutter build apk --release`.
- Windows scripts: `./build_simple.bat`, `./build_release.bat` for local packaging.

## Coding Style & Naming Conventions
- Dart style: 2-space indent, single quotes, trailing commas; prefer `final` locals; always declare return types.
- Strict types: no implicit casts/dynamic (see `analysis_options.yaml`).
- Formatting: `dart format .` (CI checks with `flutter analyze`).
- Naming: files in `snake_case.dart`; tests end with `*_test.dart`.
- Do not edit generated files (`*.g.dart`, `*.freezed.dart`).

## UI Structure Rule of Thumb
- Put navigation-level widgets in `screens/`.
- Put positioning/rendering logic in `layout/` or `rendering/` so it can be reused across screens (timeline, grid, week view).

## Riverpod UI Guidelines
- Prefer generated `@riverpod` providers; use `@Riverpod(keepAlive: true)` only when necessary.
- Derive filtered/summary data via providers (not in widgets); use families for by-ID data.
- Example: `AsyncValueWidget.fromProvider(provider: todaysAppointmentsProvider, data: (c, list, r) => ListView(...))`.

## Testing Guidelines
- Frameworks: `flutter_test`, `integration_test`, `mocktail`.
- Place unit/widget tests in `test/`; integration in `test/integration/`.
- Cover new logic, edge cases, and DB interactions (Drift queries).
- Example: `flutter test test/appointment_repository_test.dart`.

## Commit & Pull Request Guidelines
- If unsure of local history conventions, use Conventional Commits: `feat:`, `fix:`, `refactor:`, `chore:`, `docs:`.
- PRs must include: clear description, linked issues, steps to verify, screenshots/GIFs for UI changes, and notes for DB/assets changes.
- Update docs when altering schema (`*.sql`) or assets.

## Security & Configuration Tips
- Do not commit secrets or real customer data. Treat `assets/database/pos.db` as sample data only.
- Keep environment-specific settings out of source; prefer runtime config or mock data.
- Validate no changes to generated files in diffs; re-run build runner after model/schema updates.

---

## Agent Operating Notes (Codex)

This section captures app-specific conventions and decisions to help agents comprehend and work safely and quickly.

### Environment & Run Targets
- Windows desktop build/run: prefer native Windows shell (`flutter run -d windows`).
- WSL/Linux dev: great for edits, codegen, analysis, unit tests, and web/desktop (`linux`, `chrome`).
- Always run, in order:
  1) `flutter pub get`
  2) `dart run build_runner build --delete-conflicting-outputs`
  3) `flutter analyze`

### Live Data Decisions (Key Invariants)
- Appointments today (dashboard): show only `scheduled | confirmed` and time-aware metrics. Provider: `todaysAppointmentsProvider`.
- Appointments today (calendar): show all except `cancelled | no-show | voided`. Provider: `todaysCalendarAppointmentsProvider`.
- Appointments by day/week: use range providers (calendar-filtered). Providers:
  - Future: `appointmentsByDateRangeForCalendarProvider(DateTimeRange)`
  - Stream (live): `selectedDateAppointmentsStreamProvider`, `weekAppointmentsForCalendarStreamProvider(anchorDay)`
- Tickets (queue + tech): single master stream + derived per‑technician lists; do NOT create N per‑tech DB watchers.
  - Master: `liveTicketsTodayProvider` (today + active statuses)
  - Per‑tech derived: `ticketsByTechnicianProvider(techId)`; returns empty when the tech is not clocked in.
  - Clock‑in gating source: `clockedInTechnicianIdsProvider` (time_entries).

### Provider Catalog (Current)
- Appointments data
  - `appointmentRepositoryProvider`
  - `todaysAppointmentsProvider` (dashboard view)
  - `todaysCalendarAppointmentsProvider` (calendar day view)
  - `appointmentsByDateRangeForCalendarProvider(DateTimeRange)`
  - `selectedDateAppointmentsProvider` (Future) and `selectedDateAppointmentsStreamProvider` (Stream)
  - `weekAppointmentsForCalendarStreamProvider(anchorDay)`
- Appointments UI state
  - `selectedDateProvider`
  - `calendarViewStateProvider` (replaces the conflicting provider name)
- Tickets (live)
  - `liveTicketsTodayProvider`
  - `clockedInTechnicianIdsProvider`
  - `ticketsByTechnicianProvider(techId)`
- Employees/Dashboard
  - `employeeStatusProvider` (notifier with clockIn/clockOut)
  - Legacy aliases named “technician*” have been replaced — avoid `technicianStatusProvider`.

### Status Semantics
- “Cancelled‑like” statuses: `{ cancelled, voided, noShow, no‑show }` — exclude from calendar.
- “Active ticket” statuses: `{ queued, assigned, in‑service }` — used by live tickets master.

### Codegen & Drift
- Never edit generated files (`*.g.dart`, `*.freezed.dart`).
- If codegen fails, first check for type/enum/duplicate symbol clashes (common during migrations) and fix those before re‑running.
- Drift: prefer `.watch()` streams for live updates (appointments, tickets) over timers.

### Safety & Migration Pitfalls
- Do NOT delete the `lib/` folder. Refactors must remain surgical; keep module structure intact.
- Many compile cascades usually stem from:
  - Stale imports (old MobX/Provider stores, deleted services)
  - Duplicate enums/classes in the same scope (e.g., view mode names)
  - Skipped codegen after API changes

### Testing (Sanity Tests to Keep)
- Tickets gating: per‑tech lists remain empty until the tech is clocked in; appear after clock‑in.
- Appointments filtering: calendar range excludes cancelled‑like statuses consistently.
- Appointments check‑in: `checkInAppointment(id)` transitions to `arrived` and invalidates dependent providers.

### Indexes (DB Performance)
- Ensure these exist in schema/migrations for tickets:
  - `idx_tickets_business_date (business_date)`
  - `idx_tickets_tech_date_status (assigned_technician_id, business_date, status)`
