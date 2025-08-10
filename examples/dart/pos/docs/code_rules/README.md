# Code Rules Documentation

This directory contains business rules and architectural documentation for the Flutter POS application, organized by features and file types.

## File Organization

### Feature-Based Files
- **`dashboard_feature.json`** - Main dashboard functionality, technician cards, customer queue
- **`tickets_feature.json`** - Ticket management, ticket details, and related stores
- **`checkout_feature.json`** - Payment processing and checkout functionality
- **`employees_feature.json`** - Employee management and clock-in services
- **`appointments_feature.json`** - Appointment scheduling and management (placeholder)

### Type-Based Files
- **`core_files.json`** - Core application infrastructure (database, services, utilities, main.dart)
- **`repository_files.json`** - Data access layer using Drift ORM
- **`shared_models.json`** - Common data models used across features

## File Type Classifications

Each file is classified with a `file_type` field:

- **`database`** - Database schema and configuration files
- **`service`** - Business logic services (singletons, utilities)
- **`repository`** - Data access layer using Drift ORM
- **`store`** - MobX state management stores
- **`widget`** - UI presentation components (screens, widgets, dialogs)
- **`model`** - Data models and DTOs
- **`utility`** - Utility classes and helper functions
- **`entry_point`** - Main application entry point

## JSON Structure

Each JSON file follows this structure:

```json
{
  "category": "Feature/Type Name",
  "description": "Brief description of the category",
  "files": {
    "/path/to/file.dart": {
      "file_type": "widget|store|service|repository|model|utility|database|entry_point",
      "imports": ["list", "of", "import", "statements"],
      "components": [
        {
          "ComponentName": "Description of what this component does"
        }
      ],
      "rules": [
        "Business rule or architectural constraint",
        "Another important rule or behavior"
      ]
    }
  }
}
```

## Usage

These files serve as:
1. **Documentation** - Understand the purpose and behavior of each file
2. **Architectural Reference** - See how components interact and depend on each other
3. **Business Rules** - Understand the business logic and constraints
4. **Code Review Guide** - Reference for maintaining consistency
5. **New Developer Onboarding** - Quick way to understand the codebase structure

## Migration from business_rules.json

This structure replaces the monolithic `business_rules.json` file to:
- Improve maintainability and searchability
- Organize by logical groupings (features and types)
- Enable parallel development and documentation updates
- Provide better context for specific areas of the codebase

## Future Expansion

As new files are analyzed from `dart_file_tracker.json`, they should be added to the appropriate feature or type-based JSON files. New categories can be created as needed for additional features or specialized file types.