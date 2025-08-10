// lib/core/database/seeds/service_seeds.dart
// Default service seed data for database initialization with comprehensive salon services. Provides predefined services with pricing, duration, and category assignments for nail salon operations.
// Usage: ACTIVE - Used during database setup to populate initial service offerings

import '../database.dart';
import 'package:drift/drift.dart';
import '../../utils/logger.dart';

/// Default services to seed the database - based on actual salon services
class ServiceSeeds {
  static final List<ServicesCompanion> defaultServices = [
    // Mani-Pedi Services (Category ID: 1)
    const ServicesCompanion(
      name: Value('Manicure'),
      description: Value('Classic nail shaping, cuticle care, and polish application'),
      categoryId: Value(1),
      durationMinutes: Value(30),
      basePriceCents: Value(3700), // $37.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Pedicure'),
      description: Value('Foot soak, nail care, callus removal, and polish'),
      categoryId: Value(1),
      durationMinutes: Value(45),
      basePriceCents: Value(4700), // $47.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Deluxe Pedicure'),
      description: Value('Extended pedicure with exfoliation and massage'),
      categoryId: Value(1),
      durationMinutes: Value(60),
      basePriceCents: Value(6500), // $65.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Hot Stone Pedicure'),
      description: Value('Luxury pedicure with hot stone massage'),
      categoryId: Value(1),
      durationMinutes: Value(60),
      basePriceCents: Value(7000), // $70.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('CBD Pedicure'),
      description: Value('Therapeutic pedicure with CBD-infused products'),
      categoryId: Value(1),
      durationMinutes: Value(60),
      basePriceCents: Value(7500), // $75.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Collagen Manicure'),
      description: Value('Anti-aging manicure with collagen treatment'),
      categoryId: Value(1),
      durationMinutes: Value(45),
      basePriceCents: Value(3800), // $38.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Men\'s Manicure'),
      description: Value('Nail care and grooming for men'),
      categoryId: Value(1),
      durationMinutes: Value(25),
      basePriceCents: Value(3000), // $30.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Men\'s Pedicure'),
      description: Value('Foot care and grooming for men'),
      categoryId: Value(1),
      durationMinutes: Value(40),
      basePriceCents: Value(4200), // $42.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Kids Manicure'),
      description: Value('Fun nail service for children'),
      categoryId: Value(1),
      durationMinutes: Value(20),
      basePriceCents: Value(2000), // $20.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Kids Pedicure'),
      description: Value('Gentle foot care for children'),
      categoryId: Value(1),
      durationMinutes: Value(30),
      basePriceCents: Value(2500), // $25.00 in cents
      isActive: Value(true),
    ),

    // Gel Nails Services (Category ID: 2)
    const ServicesCompanion(
      name: Value('Gel Manicure'),
      description: Value('Long-lasting gel polish manicure'),
      categoryId: Value(2),
      durationMinutes: Value(45),
      basePriceCents: Value(4000), // $40.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Gel Pedicure'),
      description: Value('Long-lasting gel polish pedicure'),
      categoryId: Value(2),
      durationMinutes: Value(60),
      basePriceCents: Value(5500), // $55.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Gel Polish Change'),
      description: Value('Remove old gel and apply new gel polish'),
      categoryId: Value(2),
      durationMinutes: Value(20),
      basePriceCents: Value(2500), // $25.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Gel Extension'),
      description: Value('Nail extensions using gel system'),
      categoryId: Value(2),
      durationMinutes: Value(90),
      basePriceCents: Value(7500), // $75.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Gel Removal'),
      description: Value('Safe removal of gel polish'),
      categoryId: Value(2),
      durationMinutes: Value(15),
      basePriceCents: Value(1500), // $15.00 in cents
      isActive: Value(true),
    ),

    // Acrylics Services (Category ID: 3)
    const ServicesCompanion(
      name: Value('Acrylic Full Set'),
      description: Value('Complete set of acrylic nail extensions'),
      categoryId: Value(3),
      durationMinutes: Value(90),
      basePriceCents: Value(6500), // $65.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Acrylic Fill'),
      description: Value('Fill-in service for acrylic nails'),
      categoryId: Value(3),
      durationMinutes: Value(60),
      basePriceCents: Value(5000), // $50.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Acrylic Overlay'),
      description: Value('Acrylic coating over natural nails'),
      categoryId: Value(3),
      durationMinutes: Value(60),
      basePriceCents: Value(4500), // $45.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Acrylic Removal'),
      description: Value('Safe removal of acrylic nails'),
      categoryId: Value(3),
      durationMinutes: Value(30),
      basePriceCents: Value(2500), // $25.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Acrylic Repair'),
      description: Value('Repair broken acrylic nail'),
      categoryId: Value(3),
      durationMinutes: Value(15),
      basePriceCents: Value(1000), // $10.00 in cents
      isActive: Value(true),
    ),

    // Waxing Services (Category ID: 4)
    const ServicesCompanion(
      name: Value('Eyebrow Wax'),
      description: Value('Professional eyebrow shaping'),
      categoryId: Value(4),
      durationMinutes: Value(15),
      basePriceCents: Value(2000), // $20.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Lip Wax'),
      description: Value('Upper lip hair removal'),
      categoryId: Value(4),
      durationMinutes: Value(10),
      basePriceCents: Value(1500), // $15.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Chin Wax'),
      description: Value('Chin hair removal'),
      categoryId: Value(4),
      durationMinutes: Value(10),
      basePriceCents: Value(1500), // $15.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Full Face Wax'),
      description: Value('Complete facial hair removal'),
      categoryId: Value(4),
      durationMinutes: Value(30),
      basePriceCents: Value(4500), // $45.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Underarm Wax'),
      description: Value('Underarm hair removal'),
      categoryId: Value(4),
      durationMinutes: Value(15),
      basePriceCents: Value(2500), // $25.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Half Leg Wax'),
      description: Value('Lower leg hair removal'),
      categoryId: Value(4),
      durationMinutes: Value(30),
      basePriceCents: Value(3500), // $35.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Full Leg Wax'),
      description: Value('Complete leg hair removal'),
      categoryId: Value(4),
      durationMinutes: Value(45),
      basePriceCents: Value(6000), // $60.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Bikini Wax'),
      description: Value('Basic bikini line waxing'),
      categoryId: Value(4),
      durationMinutes: Value(20),
      basePriceCents: Value(3500), // $35.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Brazilian Wax'),
      description: Value('Complete bikini area waxing'),
      categoryId: Value(4),
      durationMinutes: Value(30),
      basePriceCents: Value(5500), // $55.00 in cents
      isActive: Value(true),
    ),

    // Facial Services (Category ID: 5)
    const ServicesCompanion(
      name: Value('Basic Facial'),
      description: Value('Deep cleansing facial treatment'),
      categoryId: Value(5),
      durationMinutes: Value(45),
      basePriceCents: Value(6000), // $60.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Deluxe Facial'),
      description: Value('Advanced facial with extractions and mask'),
      categoryId: Value(5),
      durationMinutes: Value(60),
      basePriceCents: Value(8500), // $85.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Anti-Aging Facial'),
      description: Value('Facial targeting fine lines and wrinkles'),
      categoryId: Value(5),
      durationMinutes: Value(75),
      basePriceCents: Value(9500), // $95.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Hydrating Facial'),
      description: Value('Intensive moisture treatment for dry skin'),
      categoryId: Value(5),
      durationMinutes: Value(60),
      basePriceCents: Value(8000), // $80.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Acne Treatment Facial'),
      description: Value('Specialized treatment for acne-prone skin'),
      categoryId: Value(5),
      durationMinutes: Value(60),
      basePriceCents: Value(7500), // $75.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Brightening Facial'),
      description: Value('Treatment to even skin tone and reduce dark spots'),
      categoryId: Value(5),
      durationMinutes: Value(60),
      basePriceCents: Value(8500), // $85.00 in cents
      isActive: Value(true),
    ),

    // SNS/Dip Powder Services (Category ID: 6)
    const ServicesCompanion(
      name: Value('SNS Full Set'),
      description: Value('Complete SNS dipping powder application'),
      categoryId: Value(6),
      durationMinutes: Value(75),
      basePriceCents: Value(5000), // $50.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('SNS P&W Ombre'),
      description: Value('Pink and white ombre SNS design'),
      categoryId: Value(6),
      durationMinutes: Value(75),
      basePriceCents: Value(6000), // $60.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('Dip Powder'),
      description: Value('Standard dip powder application'),
      categoryId: Value(6),
      durationMinutes: Value(50),
      basePriceCents: Value(5500), // $55.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('SNS Fill'),
      description: Value('Fill-in service for SNS nails'),
      categoryId: Value(6),
      durationMinutes: Value(60),
      basePriceCents: Value(4000), // $40.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('SNS Removal'),
      description: Value('Safe removal of SNS powder'),
      categoryId: Value(6),
      durationMinutes: Value(20),
      basePriceCents: Value(2000), // $20.00 in cents
      isActive: Value(true),
    ),
    const ServicesCompanion(
      name: Value('SNS French'),
      description: Value('French tip design with SNS powder'),
      categoryId: Value(6),
      durationMinutes: Value(75),
      basePriceCents: Value(5500), // $55.00 in cents
      isActive: Value(true),
    ),
  ];

  /// Seed the database with default services if they don't exist
  static Future<void> seedServices(PosDatabase database) async {
    try {
      // Check if services already exist
      final existingServices = await database.select(database.services).get();
      
      if (existingServices.isEmpty) {
        // Insert all default services
        await database.batch((batch) {
          for (final service in defaultServices) {
            batch.insert(database.services, service);
          }
        });
        
        Logger.success('Seeded ${defaultServices.length} services');
      } else {
        Logger.info('Services already exist (${existingServices.length} found), skipping seed');
      }
    } catch (e) {
      Logger.error('Error seeding services', e);
      rethrow;
    }
  }

  /// Update existing services with correct category IDs if needed
  static Future<void> updateServiceCategories(PosDatabase database) async {
    try {
      // Get all services
      final services = await database.select(database.services).get();
      
      // Map service names to their intended category IDs
      final serviceCategoryMap = {
        // Mani-Pedi services
        'Manicure': 1,
        'Pedicure': 1,
        'Deluxe Pedicure': 1,
        'Hot Stone Pedicure': 1,
        'CBD Pedicure': 1,
        'Collagen Manicure': 1,
        'Men\'s Manicure': 1,
        'Men\'s Pedicure': 1,
        'Kids Manicure': 1,
        'Kids Pedicure': 1,
        
        // Gel services
        'Gel Manicure': 2,
        'Gel Pedicure': 2,
        'Gel Polish Change': 2,
        'Gel Extension': 2,
        'Gel Removal': 2,
        
        // Acrylic services
        'Acrylic Full Set': 3,
        'Acrylic Fill': 3,
        'Acrylic Overlay': 3,
        'Acrylic Removal': 3,
        'Acrylic Repair': 3,
        
        // Waxing services
        'Eyebrow Wax': 4,
        'Lip Wax': 4,
        'Chin Wax': 4,
        'Full Face Wax': 4,
        'Underarm Wax': 4,
        'Half Leg Wax': 4,
        'Full Leg Wax': 4,
        'Bikini Wax': 4,
        'Brazilian Wax': 4,
        
        // Facial services
        'Basic Facial': 5,
        'Deluxe Facial': 5,
        'Anti-Aging Facial': 5,
        'Hydrating Facial': 5,
        'Acne Treatment Facial': 5,
        'Brightening Facial': 5,
        
        // SNS/Dip services
        'SNS Full Set': 6,
        'SNS P&W Ombre': 6,
        'Dip Powder': 6,
        'SNS Fill': 6,
        'SNS Removal': 6,
        'SNS French': 6,
      };
      
      // Update categories where needed
      for (final service in services) {
        final intendedCategoryId = serviceCategoryMap[service.name];
        if (intendedCategoryId != null && service.categoryId != intendedCategoryId) {
          await (database.update(database.services)
            ..where((s) => s.id.equals(service.id)))
            .write(ServicesCompanion(
              categoryId: Value(intendedCategoryId),
            ),);
          
          Logger.success('Updated category for ${service.name} to $intendedCategoryId');
        }
      }
    } catch (e) {
      Logger.error('Error updating service categories', e);
      rethrow;
    }
  }
}
