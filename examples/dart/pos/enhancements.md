Enhancements Roadmap (Proposed)

Scope: Small, safe improvements to stabilize refactors, tighten live updates, and increase confidence via targeted tests.

1) Streamify Clock‑In Gating
- Convert `clockedInTechnicianIdsProvider` to a Stream that watches `time_entries` for active sessions.
- Benefits: Instant gating updates for tickets per technician when clock state changes.
- Notes: Use Drift `.watch()` on `time_entries` (status = 'active' and `clock_out IS NULL`).

2) Add Sanity Tests (Minimal, High‑Value)
- Tickets gating: Assigned ticket does not surface for a technician until they clock in; appears after clock‑in.
- Appointments filtering: Calendar day/week exclude `cancelled` / `no‑show` / `voided` consistently.
- Appointments check‑in flow: `todaysAppointmentsProvider.notifier.checkInAppointment(id)` updates status to `arrived` and invalidates dependent providers.

3) Analyzer Pass + Dead Imports Cleanup
- Run targeted analyzer on changed files; strip unused imports and stale references.
- Confirm no imports from deleted legacy services (`time_tracking_service.dart`, old MobX stores).
- Stabilize codegen warnings by resolving enum/provider name collisions proactively.

4) Dashboard/Data Flow Polishing (Optional)
- Move any remaining dashboard data reads to stream‑based providers for true live updates (already done for tickets; consider applying to other panels where relevant).
- Normalize technician/employee naming across providers and widgets to avoid confusion.

5) Appointments Live Range Streams (Optional)
- Offer Stream versions for week/day windows (already introduced); wire UI where beneficial to avoid timer refreshes.
- Keep one‑shot Future providers for backward compatibility during migration.

6) Status Normalization Helpers (Optional)
- Centralize “cancelled‑like” statuses in a helper or constant set (e.g., `{cancelled, voided, noShow, no‑show}`) and reference everywhere.
- Reduces risk of inconsistent filters across repositories and providers.

7) Drift Index & Warning Triage (Later)
- Verify newly added indexes are present in production DBs.
- Triage existing Drift warnings in table files (unrelated to current changes) and harmonize references to generated table classes.

Execution Order (Suggested)
1) Streamify clock‑in gating
2) Add sanity tests (tickets gating, appointments filtering, check‑in invalidation)
3) Analyzer pass + dead imports cleanup
4) Optional polish items (4–7)

