# Settings Screen Migration Audit

This document captures, in detail, the original `settings_screen.dart` behavior (backup copy at `lib/features/settings/settings_screen.dart`) and verifies that the refactored screen at `lib/features/settings/presentation/screens/settings_screen.dart` and its imports fully replicate that behavior.

## Source of Truth
- Backup/original parent: `lib/features/settings/settings_screen.dart`
- Refactored parent: `lib/features/settings/presentation/screens/settings_screen.dart`

Both files define the same top-level widget class and state and compose the same feature sections in the same order.

---

## Original Screen: Classes and Behavior

- `SettingsScreen extends ConsumerStatefulWidget`
  - Purpose: Top-level settings page that renders sectioned configuration UI and coordinates updates via Riverpod.

- `_SettingsScreenState extends ConsumerState<SettingsScreen>`
  - Fields:
    - `_hasUnsavedChanges: bool` — toggled to `true` on any `onUpdate` call; reset to `false` when pressing Save.
    - `_currentEmployeeId: int` — hardcoded `1` in this context (placeholder for an authenticated user id).
  - Methods:
    - `_update(String key, Object value) -> Future<void>`
      - Calls `ref.read(settingsMasterProvider.notifier).updateSetting(key, value)` to persist the change (Drift-backed repo under the hood).
      - On success: sets `_hasUnsavedChanges = true`.
      - On error: shows a `SnackBar` with the failure reason and uses `AppColors.errorRed` for background.
  - `build(BuildContext context)`
    - Watches `settingsMasterProvider` (Riverpod) which yields `AsyncValue<Map<String, StoreSetting>>`.
    - Scaffold:
      - `AppBar`: title `System Settings`, white background, `AppColors.textPrimary` foreground, subtle elevation.
      - `body`: `settingsAsync.when(...)` to render states:
        - `loading`: `CircularProgressIndicator` centered.
        - `error`: centered `Text('Error: $e')`.
        - `data (settings)`: padded, centered column (max width ~880) of titled, carded sections:
          1) `SectionHeader('Dashboard', Icons.dashboard)` + `SettingsCard(DashboardSection(...))`
          2) `SectionHeader('Backgrounds', Icons.wallpaper)` + `SettingsCard(BackgroundsSection(...))`
          3) `SectionHeader('Store', Icons.store)` + `SettingsCard(StoreSection(...))`
          4) `SectionHeader('Customer Data Collection', Icons.person_add)` + `SettingsCard(CustomerDataSection(...))`
          5) `SectionHeader('General', Icons.settings)` + `SettingsCard(GeneralSection(...))`
          6) `SectionHeader('Pagination', Icons.pages)` + `SettingsCard(PaginationSection(...))`
          7) `SectionHeader('Security', Icons.security)` + `SettingsCard(SecuritySection(..., currentEmployeeId: _currentEmployeeId))`
          8) Save button (full width): enabled when `_hasUnsavedChanges == true`, shows success `SnackBar` with `AppColors.successGreen` and resets `_hasUnsavedChanges` to `false`.
          9) `SectionHeader('Remote Access', Icons.screen_share)` + `RemoteSection()` (coming-soon style card)

### Section Contracts (as used by the original parent)
- Every functional section receives:
  - `settings: Map<String, StoreSetting>` — the entire settings key/value map.
  - `onUpdate(String key, Object value)` — callback to persist a specific key/value.
- `SecuritySection` additionally receives: `currentEmployeeId: int`.
- The parent does not transform values before passing; it relies on each section to:
  - Read by keys: e.g., `dashboard_show_customer_phone`, `general_default_items_per_page`, etc.
  - Convert typed UI values to strings/bools/ints for persistence.

Key examples used by sections (observed in refactored widgets, consistent with provider keys):
- Dashboard: `dashboard_show_customer_phone`, `dashboard_enable_checkout_notifications`, `dashboard_service_display_mode`
- Backgrounds: `dashboard_background`, `dashboard_background_opacity`, `dashboard_container_opacity`, `dashboard_widget_opacity`
- Store: `store_hours_configuration`, `store_online_booking` (plus coming-soon UI elements)
- Customer Data: `general_collect_customer_address`, `general_collect_customer_dob`, `general_collect_customer_gender`, `general_collect_customer_allergies`
- General: `general_theme`, `general_sound_effects`, `general_animations`, `general_language`
- Pagination: `general_default_items_per_page`
- Security: currently `ManagerPinTile` (coming-soon wrapper) wired for employee-context features

---

## Refactored Screen: Structure and Imports

- File: `lib/features/settings/presentation/screens/settings_screen.dart`
  - Same class names and state as original: `SettingsScreen`, `_SettingsScreenState`
  - Same `_update` implementation calling `settingsMasterProvider.notifier.updateSetting`
  - Same `AppBar` styling and `AsyncValue` handling
  - Same section order, padding, and layout
  - Same Save button behavior (enabling, success snack, reset of `_hasUnsavedChanges`)
  - Same `currentEmployeeId` wiring into `SecuritySection`

- Imports (refactored paths) and mapped widgets:
  - `../widgets/settings_section_header.dart` → provides `SectionHeader`
  - `../widgets/settings_card.dart` → provides `SettingsCard`
  - Sections (one widget per file):
    - `../widgets/settings_dashboard_section.dart` → `DashboardSection`
    - `../widgets/settings_background_section.dart` → `BackgroundsSection`
    - `../widgets/settings_store_section.dart` → `StoreSection`
    - `../widgets/settings_customer_data_section.dart` → `CustomerDataSection`
    - `../widgets/settings_general.dart` → `GeneralSection`
    - `../widgets/settings_pagination_section.dart` → `PaginationSection`
    - `../widgets/settings_security_section.dart` → `SecuritySection`
    - `../widgets/settings_remote_section.dart` → `RemoteSection`

All imported widget classes expose the same public names the original parent expects, with the same constructor contracts:
- `DashboardSection`, `BackgroundsSection`, `StoreSection`, `CustomerDataSection`, `GeneralSection`, `PaginationSection`:
  - `({required Map<String, StoreSetting> settings, required Future<void> Function(String, Object) onUpdate})`
- `SecuritySection`:
  - `({required Map<String, StoreSetting> settings, required Future<void> Function(String, Object) onUpdate, required int currentEmployeeId})`
- `RemoteSection`:
  - `const RemoteSection()`

Supporting widgets (`SettingsCard`, `SectionHeader`) match original behavior and styling contracts.

---

## Verification Results

- Class parity:
  - `SettingsScreen` and `_SettingsScreenState` are identical in behavior across original and refactored files.
  - `_hasUnsavedChanges` flag toggling and Save button enable/disable logic is the same.
  - Error and success snackbars use the same colors (`AppColors.errorRed`, `AppColors.successGreen`).

- Provider interaction:
  - Both screens use `settingsMasterProvider` for loading and updating settings.
  - No divergences in async state handling.

- Section composition and order: exact match (Dashboard → Backgrounds → Store → Customer Data → General → Pagination → Security → Save → Remote).

- Imports and widget contracts:
  - Refactored imports point to split widgets under `presentation/widgets/…` with class names preserved.
  - Each section accepts the same `settings` map and `onUpdate` callback; `SecuritySection` includes `currentEmployeeId`.

Conclusion: The refactored screen replicates the original functionality exactly, with improved file organization. The backup file at `lib/features/settings/settings_screen.dart` should be treated as historical reference (its import paths reference older folder structure), while the new screen compiles against the current `presentation/widgets` structure.

---

## Notes and Follow‑Ups

- Backup file provenance: The file at the feature directory root (`lib/features/settings/settings_screen.dart`) is the original backup copy. It intentionally uses legacy relative import comments/paths and should not be used as the compiled screen.
- Live functionality is provided by `presentation/screens/settings_screen.dart` and the widgets under `presentation/widgets/`. The provider layer is in `providers/settings_provider.dart`.
- If/when auth is integrated, replace `_currentEmployeeId = 1` with the real authenticated employee id.

