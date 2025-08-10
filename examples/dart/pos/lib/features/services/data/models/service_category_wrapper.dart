// lib/features/services/data/models/service_category_wrapper.dart
// Wrapper class for ServiceCategory to resolve MobX code generation issues with Drift types.
// Provides property delegation and conversion methods between Drift database objects and wrapper instances.
// Usage: ACTIVE - Required for MobX stores that use ServiceCategory, resolves type generation conflicts

import '../../../../core/database/database.dart' as db;

/// Wrapper class for ServiceCategory to avoid MobX code generation issues
class ServiceCategoryWrapper {
  final db.ServiceCategory category;
  
  ServiceCategoryWrapper(this.category);
  
  // Delegate properties
  int get id => category.id;
  String get name => category.name;
  String? get color => category.color;
  
  // Convert from db.ServiceCategory
  static ServiceCategoryWrapper fromDb(db.ServiceCategory category) {
    return ServiceCategoryWrapper(category);
  }
  
  // Convert to db.ServiceCategory
  db.ServiceCategory toDb() => category;
}
