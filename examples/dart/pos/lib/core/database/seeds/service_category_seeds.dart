// lib/core/database/seeds/service_category_seeds.dart
// Default service category seed data for database initialization. Provides predefined categories with names, colors, and icons for salon services like manicure, pedicure, waxing, etc.
// Usage: ACTIVE - Used during database setup to populate initial service categories

import '../database.dart';
import 'package:drift/drift.dart';
import '../../utils/logger.dart';

/// Default service categories to seed the database
class ServiceCategorySeeds {
  static final List<ServiceCategoriesCompanion> defaultCategories = [
    const ServiceCategoriesCompanion(
      name: Value('Mani-Pedi'),
      color: Value('#FF6B9D'), // Soft pink
      icon: Value('pan_tool'), // Hand icon for manicure/pedicure
    ),
    const ServiceCategoriesCompanion(
      name: Value('Gel Nails'),
      color: Value('#4ECDC4'), // Teal
      icon: Value('brush'), // Brush icon for gel application
    ),
    const ServiceCategoriesCompanion(
      name: Value('Acrylics'),
      color: Value('#9B59B6'), // Purple
      icon: Value('format_paint'), // Paint icon for acrylics
    ),
    const ServiceCategoriesCompanion(
      name: Value('Waxing'),
      color: Value('#F39C12'), // Orange
      icon: Value('spa'), // Spa icon for waxing services
    ),
    const ServiceCategoriesCompanion(
      name: Value('Facial'),
      color: Value('#52B788'), // Green
      icon: Value('face_retouching_natural'), // Face icon for facials
    ),
    const ServiceCategoriesCompanion(
      name: Value('SNS'),
      color: Value('#FF9F1C'), // Bright orange
      icon: Value('layers'), // Layers icon for SNS/Dip powder
    ),
  ];

  /// Seed the database with default categories if they don't exist
  static Future<void> seedCategories(PosDatabase database) async {
    try {
      // Check if categories already exist
      final existingCategories = await database.select(database.serviceCategories).get();
      
      if (existingCategories.isEmpty) {
        // Insert all default categories
        await database.batch((batch) {
          for (final category in defaultCategories) {
            batch.insert(database.serviceCategories, category);
          }
        });
        
        Logger.success('Seeded ${defaultCategories.length} service categories');
      } else {
        Logger.info('Service categories already exist, skipping seed');
      }
    } catch (e) {
      Logger.error('Error seeding service categories', e);
      rethrow;
    }
  }

  /// Update existing categories with new colors and icons if needed
  static Future<void> updateCategoryColorsAndIcons(PosDatabase database) async {
    try {
      // Map of category names to their intended colors and icons
      final categoryDataMap = {
        'Mani-Pedi': {'color': '#FF6B9D', 'icon': 'pan_tool'},
        'Gel Nails': {'color': '#4ECDC4', 'icon': 'brush'},
        'Acrylics': {'color': '#9B59B6', 'icon': 'format_paint'},
        'Waxing': {'color': '#F39C12', 'icon': 'spa'},
        'Facial': {'color': '#52B788', 'icon': 'face_retouching_natural'},
        'SNS': {'color': '#FF9F1C', 'icon': 'layers'},
      };

      // Get all categories
      final categories = await database.select(database.serviceCategories).get();
      
      // Update colors and icons where needed
      for (final category in categories) {
        final categoryData = categoryDataMap[category.name];
        if (categoryData != null) {
          final needsUpdate = category.color != categoryData['color'] || 
                             category.icon != categoryData['icon'];
          
          if (needsUpdate) {
            await (database.update(database.serviceCategories)
              ..where((c) => c.id.equals(category.id)))
              .write(ServiceCategoriesCompanion(
                color: Value(categoryData['color']!),
                icon: Value(categoryData['icon']!),
              ),);
            
            Logger.success('Updated ${category.name}: color=${categoryData['color']}, icon=${categoryData['icon']}');
          }
        }
      }
    } catch (e) {
      Logger.error('Error updating category colors', e);
      rethrow;
    }
  }

  /// Get the numeric ID for a category name (for backward compatibility)
  static int? getCategoryIdByName(String name) {
    switch (name.toLowerCase()) {
      case 'mani-pedi':
      case 'manicure':
      case 'pedicure':
      case 'nails':
        return 1;
      case 'gel nails':
      case 'gel':
        return 2;
      case 'acrylics':
      case 'acrylic':
        return 3;
      case 'waxing':
      case 'wax':
        return 4;
      case 'facial':
      case 'facials':
        return 5;
      case 'sns':
      case 'dip':
      case 'dip powder':
        return 6;
      default:
        return null;
    }
  }
}
