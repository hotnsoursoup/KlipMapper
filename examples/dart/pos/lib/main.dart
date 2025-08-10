// lib/main.dart
// Application entry point that initializes all core services and launches the Flutter POS app. Handles database connections, settings, window configuration, and service loading before starting the main UI.
// Usage: ACTIVE - Main entry point for the entire Flutter application

// agentmap:1
// gz64: H4sIAAAAAAAC/02LQQ7CIBBF7zLrpkBClbDyDrozLqCAkkAlpTGQpnd3Ztfd+2/e7PADDWLkMECIDtk3k0vylTmzbqx8K0vRsmziMpK5TUHOl5kbeijY148R+iSTWd6oqcVVewb9fA3QVh8q6P0YILqGALbf6UjG9kcvnhjHhpm4TlJxpaQ8/m8zPGKiAAAA
// total-bytes: 192 sha1:fa5729a8


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'core/config/service_categories.dart' as config;
import 'core/database/database.dart' as db;
import 'core/services/background_converter_service.dart';
import 'core/services/lookup_service.dart';
import 'core/services/settings_manager.dart';
import 'core/services/window_service.dart';
import 'core/utils/pin_bootstrap.dart';
import 'features/shared/data/repositories/drift_employee_repository.dart';
import 'features/shared/data/repositories/drift_service_repository.dart';
import 'core/utils/logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize file logging first
  await AppLogger.initialize();
  await AppLogger.initialize();  // Initialize the new dual-output logger
  
  AppLogger.info('=== POS Application Starting ===', 'MAIN');
  AppLogger.info('AppLogger file: ${AppLogger.currentLogFile ?? 'Console only'}', 'MAIN');
  AppLogger.info('AppLogger file: ${AppLogger.currentLogFile ?? 'Console only'}', 'MAIN');
  
  // Initialize settings manager before anything else
  // This ensures all user preferences are loaded before the first render
  try {
    AppLogger.logInfo('Initializing app settings...');
    await SettingsManager.instance.initialize();
    AppLogger.logInfo('Settings loaded successfully');
  } catch (e, stack) {
    AppLogger.logError('Failed to initialize settings', e, stack);
    // App will continue with default settings
  }
  
  // Set preferred orientations for desktop and mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  // Initialize window in maximized mode (but keep fullscreen functionality available)
  try {
    AppLogger.logInfo('Initializing window state...');
    await WindowService.instance.initializeWindow();
    AppLogger.logInfo('Window initialized successfully');
  } catch (e, stack) {
    AppLogger.logError('Failed to initialize window', e, stack);
    // App will continue with default window size
  }
  
  // Initialize background converter service
  try {
    AppLogger.logInfo('Processing background images...');
    await BackgroundConverterService.initialize();
    AppLogger.logInfo('Background processing completed');
  } catch (e, stack) {
    AppLogger.logError('Failed to process backgrounds', e, stack);
    // App will continue with original backgrounds
  }
  
  // Initialize PIN bootstrap for demo/development purposes
  // This sets default PIN "1234" for all employees who don't have PINs yet
  try {
    AppLogger.logInfo('Running PIN bootstrap for development...');
    await PinBootstrap.runBootstrapIfNeeded();
    AppLogger.logInfo('PIN bootstrap completed successfully');
  } catch (e, stack) {
    AppLogger.logError('Failed to run PIN bootstrap', e, stack);
    // App will continue but clock-in may not work without PINs
  }
  
  // Load service categories from database
  try {
    AppLogger.logInfo('Loading service categories from database...');
    final database = db.PosDatabase.instance;
    final categories = await database.select(database.serviceCategories).get();
    
    // Convert to the format expected by ServiceCategories
    final categoryData = categories.map((cat) => {
      'id': cat.id,
      'name': cat.name,
      'color': cat.color,
      'icon': cat.icon,
    },).toList();
    
    config.ServiceCategories.loadFromDatabase(categoryData);
    AppLogger.logInfo('Service categories loaded successfully');
  } catch (e, stack) {
    AppLogger.logError('Failed to load service categories', e, stack);
    // App will continue with default categories
  }
  
  // Initialize lookup service with employees and services
  try {
    AppLogger.logInfo('Initializing lookup service...');
    
    // Load employees/technicians
    final employeeRepo = DriftEmployeeRepository.instance;
    await employeeRepo.initialize();
    final employees = await employeeRepo.getTechnicians();
    LookupService.instance.updateTechniciansFromEmployees(employees);
    AppLogger.logInfo('Loaded ${employees.length} technicians into lookup service');
    
    // Load services
    final serviceRepo = DriftServiceRepository.instance;
    await serviceRepo.initialize();
    final services = await serviceRepo.getServices();
    LookupService.instance.updateServices(services);
    AppLogger.logInfo('Loaded ${services.length} services into lookup service');
    
    // Print debug info
    LookupService.instance.printDebugInfo();
  } catch (e, stack) {
    AppLogger.logError('Failed to initialize lookup service', e, stack);
    // App will continue but lookups may not work
  }
  
  runApp(const LuxeNailsApp());
}
