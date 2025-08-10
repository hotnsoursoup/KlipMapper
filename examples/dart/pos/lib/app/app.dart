// lib/app/app.dart
// Main Flutter app widget that configures Riverpod state management, keyboard shortcuts, and routing. Sets up theme, fullscreen controls, and provides the root MaterialApp with navigation configuration.
// Usage: ACTIVE - Root widget instantiated in main.dart and used throughout app lifecycle

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/services/window_service.dart';
import '../utils/error_logger.dart';
import 'router/app_router.dart';

class LuxeNailsApp extends StatelessWidget {
  const LuxeNailsApp({super.key});

  @override
  Widget build(BuildContext context) {
    ErrorLogger.logInfo('Starting Luxe Nails POS App with Riverpod Architecture');

    return ProviderScope(
      child: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.f11): const ToggleFullscreenIntent(),
          LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.enter): const ToggleFullscreenIntent(),
          LogicalKeySet(LogicalKeyboardKey.escape): const ExitAppIntent(),
        },
        child: Actions(
          actions: {
            ToggleFullscreenIntent: CallbackAction<ToggleFullscreenIntent>(
              onInvoke: (intent) async {
                await WindowService.instance.toggleFullscreen();
                return null;
              },
            ),
            ExitAppIntent: CallbackAction<ExitAppIntent>(
              onInvoke: (intent) async {
                await WindowService.instance.exitApp();
                return null;
              },
            ),
          },
          child: MaterialApp.router(
            title: 'Luxe Nails POS',
            theme: AppTheme.lightTheme(),
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}

/// Intent for toggling fullscreen mode
class ToggleFullscreenIntent extends Intent {
  const ToggleFullscreenIntent();
}

/// Intent for exiting the application
class ExitAppIntent extends Intent {
  const ExitAppIntent();
}