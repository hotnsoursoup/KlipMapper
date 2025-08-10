# The UI Bible, Part 4: The Complete Playbook (Expanded)

**Document**: `part_4_complete_playbook.md`
**Audience**: All UI Engineers
**Author**: Alex, Lead Architect

---

## Chapter 13: The Final Chapter

Welcome to the final part of the UI Bible. We have established our philosophy, mastered the art of composition, and understood the science of rendering. This chapter is our playbook. It codifies our specific architectural choices and patterns into a set of mandatory standards for the project.

Adherence to these patterns is not optional. They are the "way we do things here." This consistency is our primary defense against technical debt, fragmentation, and performance degradation as the team and the application scale.

## Chapter 14: Our Navigation Strategy

For an application with the complexity of a desktop POS, a robust and predictable navigation strategy is critical.

-   **Our Choice**: We will use the `go_router` package.
-   **The "Why"**: `go_router` is the official routing package from the Flutter team. It is URL-based, which is excellent for desktop and web platforms, and it provides a robust API for handling complex routing scenarios, including nested routes, redirects, and route guards.

### Navigation Standards:

1.  **Centralized Route Configuration**: All routes will be defined in a single location, `lib/core/routing/app_router.dart`. No `MaterialPageRoute` calls should be scattered throughout the codebase.
2.  **Typed Routes**: We will use a code generation approach (e.g., `go_router_builder`) to create typed routes. This prevents typos in route paths and allows for compile-time safety when navigating.
3.  **Authentication Guard**: The router will be the single source of truth for authentication state. A `redirect` guard will be implemented that checks an `AuthenticationStore`. If the user is not authenticated, it will automatically redirect them to the `/login` route, regardless of the route they were trying to access.
4.  **Parameter Passing**: All parameters will be passed via the routing mechanism, not through widget constructors for top-level screens. This ensures that screens can be deep-linked and their state can be restored from a URL.

## Chapter 15: Handling Asynchronous UI

Nearly every piece of data in our application will come from an asynchronous source (the database). Handling the `loading` and `error` states of these operations is a critical part of the user experience.

-   **Our Choice**: We will create a custom `AsyncState` sealed class to represent the different states of an asynchronous operation.
-   **The "Why"**: A custom `AsyncState` class provides a type-safe way to handle the `loading`, `loaded`, and `error` states of an asynchronous operation. This makes our code more predictable and easier to read.

### Asynchronous UI Standards:

1.  **Create a Custom `AsyncState` Class**: We will use the `freezed` package to create a sealed class called `AsyncState` with three states: `loading`, `loaded`, and `error`.
2.  **Use `AsyncState` in MobX Stores**: Our MobX stores will use the `AsyncState` class to represent the state of asynchronous operations.
3.  **Pattern Matching with `switch` is Mandatory**: When observing a store that returns an `AsyncState`, you **must** use a `switch` expression to handle all three cases (`.loading`, `.loaded`, `.error`). This is compile-time safe.
4.  **Use a Shared `LoadingIndicator`**: Create a standardized, project-wide loading widget (e.g., `lib/core/widgets/loading_indicator.dart`). This should be returned in the `loading` case of the `switch`.
5.  **Use a Shared `ErrorDisplay`**: Create a standardized widget for displaying errors (`lib/core/widgets/error_display.dart`). This widget should take an error and stack trace, and a "Retry" callback. This will be returned in the `error` case.

**Example Implementation:**
```dart
// lib/core/state/async_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'async_state.freezed.dart';

@freezed
abstract class AsyncState<T> with _$AsyncState<T> {
  const factory AsyncState.loading() = _Loading;
  const factory AsyncState.loaded({required T data}) = _Loaded<T>;
  const factory AsyncState.error({required Object error, required StackTrace stackTrace}) = _Error;
}

// In your MobX store
class MyStore with Store {
  @observable
  AsyncState<MyData> myData = AsyncState.loading();

  @action
  Future<void> fetchData() async {
    myData = AsyncState.loading();
    try {
      final data = await _myApi.fetchData();
      myData = AsyncState.loaded(data: data);
    } catch (e, s) {
      myData = AsyncState.error(error: e, stackTrace: s);
    }
  }
}

// In your widget
import 'package.flutter_riverpod/flutter_riverpod.dart';

// 1. Define a provider for your store
final myStoreProvider = Provider((ref) => MyStore());

// 2. Make your widget a ConsumerWidget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 3. Watch the provider to get the store
    final myStore = ref.watch(myStoreProvider);

    return Observer(
      builder: (_) {
        // 4. Use a switch expression on the state
        return switch (myStore.myData) {
          _Loaded(:final data) => MyDataWidget(data: data),
          _Loading() => const LoadingIndicator(),
          _Error(:final error, :final stackTrace) => ErrorDisplay(
            error: error,
            // Use ref.read to call methods on the store
            onRetry: () => ref.read(myStoreProvider).fetchData(),
          ),
        };
      },
    );
  }
}
```

## Chapter 16: Forms and User Input

Forms are a primary point of user interaction and a potential source of performance issues and state management complexity. We have two standard approaches for handling forms:

### 1. Simple Forms: `StatefulWidget`

-   **Our Choice**: For simple forms with minimal validation, we will use standard `StatefulWidget`s to manage the local, ephemeral state of our forms.
-   **The "Why"**: The state of a text field as a user is typing is a classic example of ephemeral UI state. It is not business logic and does not belong in a global MobX store. Encapsulating this state within a `StatefulWidget` is the most efficient and correct approach for simple cases.

### 2. Complex Forms: Dedicated MobX Store

-   **Our Choice**: For complex forms with intricate validation logic, multiple steps, or dependencies on other parts of the application's state, we will create a dedicated MobX `Store` for the form.
-   **The "Why"**: A dedicated MobX store allows us to encapsulate all the form's logic in one place, making it easier to test and maintain. We can use `computed` values for real-time validation and `actions` to handle form submission.

Here is a detailed example of the MobX approach:

**1. The `LoginFormStore`**

This store manages the state of the login form, including validation.

```dart
// lib/stores/login_form_store.dart
import 'package:mobx/mobx.dart';

part 'login_form_store.g.dart';

class LoginFormStore = _LoginFormStore with _$LoginFormStore;

abstract class _LoginFormStore with Store {
  @observable
  String email = '';

  @observable
  String password = '';

  @computed
  bool get isEmailValid => email.contains('@');

  @computed
  bool get isPasswordValid => password.length >= 6;

  @computed
  bool get isFormValid => isEmailValid && isPasswordValid;

  @action
  void setEmail(String value) => email = value;

  @action
  void setPassword(String value) => password = value;

  @action
  Future<void> submit() async {
    if (isFormValid) {
      // Perform login
    }
  }
}
```

**2. The `LoginForm` Widget**

This widget uses an `Observer` to react to the store's state and display validation messages.

```dart
// lib/ui/widgets/login_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:my_app/stores/login_form_store.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formStore = Provider.of<LoginFormStore>(context);

    return Form(
      child: Column(
        children: [
          Observer(
            builder: (_) => TextFormField(
              onChanged: formStore.setEmail,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: formStore.isEmailValid ? null : 'Invalid email',
              ),
            ),
          ),
          Observer(
            builder: (_) => TextFormField(
              onChanged: formStore.setPassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: formStore.isPasswordValid ? null : 'Password too short',
              ),
            ),
          ),
          Observer(
            builder: (_) => ElevatedButton(
              onPressed: formStore.isFormValid ? formStore.submit : null,
              child: const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}
```

## Chapter 17: The UI Agent's Checklist

Before you mark a UI task as "done," you must be able to answer "yes" to every question on this checklist. This is our contract for quality and performance.

### The Checklist:

1.  **State Management & Rebuilds:**
    *   [ ] Have I used the most granular MobX stores possible for the state my widget needs?
    *   [ ] Have I used `Observer` widgets to rebuild only the necessary parts of the UI?
    *   [ ] Have I used the "Highlight Repaints" tool in DevTools to confirm that only the widgets I *expect* to rebuild are actually rebuilding?

2.  **Composition & Performance:**
    *   [ ] Have I added the `const` keyword to every possible widget and constructor? Is the `prefer_const_constructors` lint rule showing zero warnings for my code?
    *   [ ] For any complex, static widget, have I considered if a `RepaintBoundary` would be appropriate?
    *   [ ] For any list of data, am I using a `.builder` constructor (e.g., `ListView.builder`)?

3.  **Asynchronous & Error Handling:**
    *   [ ] For every asynchronous operation, am I using our custom `AsyncState` class to represent the state?
    *   [ ] Am I using a `switch` statement to handle the `loading`, `loaded`, and `error` states?
    *   [ ] Am I using our project's shared `LoadingIndicator` and `ErrorDisplay` widgets?

4.  **Project Standards & Architecture:**
    *   [ ] Does my code adhere to the project's navigation (`go_router`), theming, and form-handling standards?
    *   [ ] Is my UI fully responsive and does it adhere to the adaptive layout patterns defined in the `UI_UX_GUIDE.md`?
    *   [ ] Have I created separate, referenceable documents for any complex code examples, as per our documentation strategy?

---

This concludes the UI Bible. This four-part guide is our architectural north star. Study it, internalize it, and apply it with discipline. By holding ourselves and our teammates to these standards, we will build a product that is not only functional but also a genuine pleasure to use—performant, predictable, and professional. Let's get to work.