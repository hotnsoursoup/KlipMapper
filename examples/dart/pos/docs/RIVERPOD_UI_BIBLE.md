# Riverpod UI Bible (v3) — Revised (Aug 2025)

> **Scope:** Riverpod v3 + `riverpod_generator`, Freezed 3.2
> **Rule:** Use existing widgets; wire them to Riverpod (no new widgets).

---

## 0) TL;DR — pick the right provider

| Need                        | Use                 |
|----------------------------|---------------------|
| DI for repos/services      | `Provider`          |
| Tiny UI state (tab/filter) | `StateProvider<T>`  |
| Sync domain state          | `Notifier<T>`       |
| Async fetch/update         | `AsyncNotifier<T>`  |
| Live data/streams (Drift)  | `StreamNotifier<T>` |

- `@riverpod` → autoDispose by default.
- Use `@Riverpod(keepAlive: true)` for long‑lived data (dashboards, caches).

---

## 1) Core philosophy (1‑liners)

- **Declarative UI:** widget = function(state).
- **Immutable state:** replace, don’t mutate.
- **Compile‑time safety:** codegen providers, not strings.

---

## 2) Generated providers — correct v3 patterns

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'dashboard_providers.g.dart';

@riverpod
TicketRepository ticketRepository(TicketRepositoryRef ref) =>
    DriftTicketRepository.instance;

@riverpod
class TodaysTickets extends _$TodaysTickets {
  @override
  Future<List<Ticket>> build() async {
    final repo = ref.watch(ticketRepositoryProvider);
    return repo.fetchTickets(Filter(date: DateTime.now()));
  }

  Future<void> addTicketToQueue(Ticket t) async {
    final repo = ref.read(ticketRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repo.addTicket(t);
      return repo.fetchTickets(Filter(date: DateTime.now()));
    });
  }
}
```

### Parameterized (old “family”)

```dart
@riverpod
class AppointmentDetails extends _$AppointmentDetails {
  @override
  Future<Appointment> build(String id) async {
    final repo = ref.watch(appointmentRepositoryProvider);
    return repo.getAppointmentById(id);
  }

  Future<void> updateStatus(String newStatus) async {
    final repo = ref.read(appointmentRepositoryProvider);
    final id = arg; // provided by generator
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repo.updateAppointmentStatus(id, newStatus);
      return repo.getAppointmentById(id);
    });
  }
}
```

---

## 3) Performance rules (succinct)

- Use `ref.watch` in `build`. Use `ref.read` in callbacks.
- Watch a slice with `.select`:
  ```dart
  final count = ref.watch(
    todaysTicketsProvider.select((v) => v.valueOrNull?.length ?? 0),
  );
  ```
- Split fat state into focused providers.
- Prefer **Stream** for Drift live queries:

```dart
@riverpod
class LiveTickets extends _$LiveTickets {
  @override
  Stream<List<Ticket>> build() {
    final repo = ref.watch(ticketRepositoryProvider);
    return repo.watchTicketsFor(DateTime.now());
  }
}
```

- Refresh patterns:
  - `ref.invalidate(provider)` → trigger refetch/rebuild soon.
  - `ref.refresh(provider)` → refetch and *return* the value now.
  - Inside notifiers: `ref.invalidateSelf()` to rebuild yourself.

---

## 4) UI patterns (use existing widgets)

### Standard async UI (with helper in §7)

```dart
final av = ref.watch(todaysTicketsProvider);
return AsyncValueWidget<List<Ticket>>(
  value: av,
  data: (c, list, isRefreshing) => TicketList(tickets: list),
  onRefresh: () async => ref.invalidate(todaysTicketsProvider),
);
```

### Derived/filtered providers

```dart
@riverpod
class QueueFilter extends _$QueueFilter {
  @override
  String build() => 'All';
  void set(String v) => state = v;
}

@riverpod
List<Ticket> filteredQueue(FilteredQueueRef ref) {
  final filter = ref.watch(queueFilterProvider);
  final all = ref.watch(todaysTicketsProvider).value ?? [];
  bool queued(Ticket t) => t.status == 'queued' || t.status == 'assigned';
  return all.where((t) {
    if (!queued(t)) return false;
    return switch (filter) {
      'All' => true,
      'Walk In' => t.appointmentId == null,
      'Appointment' => t.appointmentId != null,
      _ => true,
    };
  }).toList();
}
```

---

## 5) Forms (ownership)

- Controllers live **in the widget**.
- Notifier performs submit/side‑effects; returns `Future<void>`.
- Button disabled/loading bound to `AsyncValue` (`isLoading`/refreshing).

---

## 6) Testing (minimal but essential)

```dart
// test/todays_tickets_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockTicketRepository extends Mock implements TicketRepository {}

void main() {
  test('addTicketToQueue updates state and refetches', () async {
    final repo = MockTicketRepository();
    when(() => repo.fetchTickets(any())).thenAnswer((_) async => []);
    when(() => repo.addTicket(any())).thenAnswer((_) async {});
    when(() => repo.fetchTickets(any()))
      .thenAnswer((_) async => [Ticket.fake()]);

    final c = ProviderContainer(overrides: [
      ticketRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(c.dispose);

    await c.read(todaysTicketsProvider.future); // resolve initial load
    await c.read(todaysTicketsProvider.notifier)
      .addTicketToQueue(Ticket.fake());

    expect(c.read(todaysTicketsProvider).value?.length, 1);
  });
}
```

> Tip: put `Ticket.fake()` and a fallback `Filter` in `test_utils.dart`.

---

## 7) AsyncValueWidget — keep it, enhance it (final)

**Verdict:** keep and enhance. It standardizes async UX, reduces boilerplate,
and encourages correct refresh/error flows.

Enhancements applied:
- Accept **either** a raw `AsyncValue<T>` or a provider.
- Provide `isRefreshing = isLoading && hasValue` to the `data` builder.
- `isEmpty` callback for non‑List data.
- Pull‑to‑refresh works even when content isn’t scrollable.
- Retry uses `onRefresh` or `ref.invalidate(provider)`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef DataBuilder<T> =
  Widget Function(BuildContext ctx, T data, bool isRefreshing);

class AsyncValueWidget<T> extends ConsumerWidget {
  final AsyncValue<T>? value;
  final ProviderListenable<AsyncValue<T>>? provider;
  final DataBuilder<T> data;
  final Widget Function(BuildContext ctx)? loading;
  final Widget Function(BuildContext ctx, Object e, StackTrace st)? error;
  final Widget Function(BuildContext ctx)? emptyBuilder;
  final bool Function(T data)? isEmpty;
  final Future<void> Function()? onRefresh;

  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.emptyBuilder,
    this.isEmpty,
    this.onRefresh,
  }) : provider = null;

  const AsyncValueWidget.fromProvider({
    super.key,
    required this.provider,
    required this.data,
    this.loading,
    this.error,
    this.emptyBuilder,
    this.isEmpty,
    this.onRefresh,
  }) : value = null;

  @override
  Widget build(BuildContext ctx, WidgetRef ref) {
    final av = value ?? ref.watch(provider!);
    final refreshing = av.isLoading && av.hasValue;

    Widget content = av.when(
      data: (d) {
        final empty = isEmpty?.call(d) ?? (d is List && d.isEmpty);
        if (empty) {
          return emptyBuilder?.call(ctx) ??
              const Center(child: Text('No items found.'));
        }
        return data(ctx, d, refreshing);
      },
      loading: () =>
          loading?.call(ctx) ??
          const Center(child: CircularProgressIndicator()),
      error: (e, st) =>
          error?.call(ctx, e, st) ??
          _DefaultError(
            error: e,
            onRetry: () async {
              if (onRefresh != null) return onRefresh!();
              if (provider != null) ref.invalidate(provider!);
            },
          ),
    );

    if (onRefresh != null) {
      content = RefreshIndicator(
        onRefresh: onRefresh!,
        child: _ensureScrollable(content),
      );
    }
    return content;
  }

  Widget _ensureScrollable(Widget child) {
    if (child is ScrollView) return child;
    return LayoutBuilder(
      builder: (ctx, _) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(ctx).size.height),
          child: child,
        ),
      ),
    );
  }
}

class _DefaultError extends StatelessWidget {
  final Object error;
  final Future<void> Function() onRetry;
  const _DefaultError({required this.error, required this.onRetry, super.key});

  @override
  Widget build(BuildContext ctx) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('$error', textAlign: TextAlign.center),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
      ]),
    );
  }
}
```

**Usage**

```dart
// Passing a watched value
final av = ref.watch(todaysTicketsProvider);
return AsyncValueWidget<List<Ticket>>(
  value: av,
  data: (c, list, r) => TicketList(tickets: list),
  onRefresh: () async => ref.invalidate(todaysTicketsProvider),
);

// Passing a provider
return AsyncValueWidget<List<Ticket>>.fromProvider(
  provider: todaysTicketsProvider,
  data: (c, list, r) => TicketList(tickets: list),
);
```

---

## 8) Global logging (debug‑only)

```dart
class AppLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? prev,
    Object? next,
    ProviderContainer c,
  ) {
    assert(() {
      debugPrint('[${provider.name ?? provider.runtimeType}] → $next');
      return true;
    }());
  }
}
```

Enable at root:
```dart
void main() => runApp(
  ProviderScope(observers: [AppLogger()], child: const MyApp()),
);
```

---

## 9) Engineer’s checklist

- Correct provider type? Granular? Logic in Notifier? `@riverpod` used?
- `watch` only where reactive, `read` in handlers, use `.select`?
- `AsyncNotifier`/`StreamNotifier` for async/live? `AsyncValue.guard`?
- Use helper instead of raw `.when()`? Custom empty/error when needed?
- Unidirectional flow UI → Provider → Repo → DB? No Drift in UI/providers?
- Param providers for shared/by‑ID state? Tests written?
- Refresh via `invalidate`/`refresh` documented? Keep‑alive justified?

---

## 10) Naming & lifecycle

- Names noun‑first: `ticketsForTodayProvider`.
- Keep‑alive annotate only when necessary; prefer autoDispose.
- Self‑refresh inside notifiers with `ref.invalidateSelf()`.

---

### Final word on `AsyncValueWidget`
Keep it and use it app‑wide. With the enhancements above, it’s not noise—
it’s your standard, consistent async UX surface.
