# Luxe Nails POS - Database Schema Documentation

**Schema Version:** 15  
**Generated:** August 2025  
**Database:** SQLite with Drift ORM

## Overview

This document describes the complete database schema for the Luxe Nails POS system. The database uses SQLite for local storage with Drift (formerly Moor) as the ORM layer.

## Key Features

- **Type Converters:** JSON serialization for complex data types
- **Foreign Key Constraints:** Enabled for data integrity
- **Performance Indexes:** Optimized for common queries
- **Migration Strategy:** Handles schema evolution gracefully
- **Data Validation:** Built-in constraints and validation rules

---

## Table Definitions

### 1. Employees Table

Core table for staff management and authentication.

| Column | Type | SQLite Name | Nullable | Description |
|--------|------|-------------|----------|-------------|
| id | INTEGER | id | No | Primary key, auto-increment |
| firstName | TEXT | first_name | No | Employee first name |
| lastName | TEXT | last_name | No | Employee last name |
| email | TEXT | email | Yes | Employee email address |
| phone | TEXT | phone | Yes | Employee phone number |
| socialSecurityNumber | TEXT | social_security_number | Yes | SSN (encrypted) |
| role | TEXT | role | No | Employee role/position |
| commissionRate | REAL | commission_rate | Yes | Commission percentage |
| hourlyRate | REAL | hourly_rate | Yes | Hourly wage |
| hireDate | TEXT | hire_date | No | ISO8601 hire date |
| isActive | INTEGER | is_active | Yes | 0/1 - Employee active status |
| createdAt | TEXT | created_at | Yes | ISO8601 creation timestamp |
| updatedAt | TEXT | updated_at | Yes | ISO8601 last update timestamp |
| clockedInAt | DATETIME | clocked_in_at | Yes | Clock-in timestamp |
| clockedOutAt | DATETIME | clocked_out_at | Yes | Clock-out timestamp |
| isClockedIn | INTEGER | is_clocked_in | Yes | 0/1 - Currently clocked in |
| pin | TEXT | pin | Yes | Hashed 4-6 digit PIN |
| pinSalt | TEXT | pin_salt | Yes | Salt for PIN hashing |
| pinCreatedAt | TEXT | pin_created_at | Yes | PIN creation timestamp |
| pinLastUsedAt | TEXT | pin_last_used_at | Yes | PIN last used timestamp |

### 2. Customers Table

Customer information and preferences.

| Column | Type | SQLite Name | Nullable | Description |
|--------|------|-------------|----------|-------------|
| id | TEXT | id | No | Primary key (string UUID) |
| firstName | TEXT | first_name | No | Customer first name |
| lastName | TEXT | last_name | No | Customer last name |
| email | TEXT | email | Yes | Customer email address |
| phone | TEXT | phone | Yes | Customer phone number |
| dateOfBirth | TEXT | date_of_birth | Yes | ISO8601 date of birth |
| gender | TEXT | gender | Yes | Customer gender |
| address | TEXT | address | Yes | Street address |
| city | TEXT | city | Yes | City |
| state | TEXT | state | Yes | State/province |
| zipCode | TEXT | zip_code | Yes | ZIP/postal code |
| loyaltyPoints | INTEGER | loyalty_points | Yes | Loyalty program points |
| lastVisit | TEXT | last_visit | Yes | ISO8601 last visit date |
| preferredTechnician | TEXT | preferred_technician | Yes | Preferred technician name |
| notes | TEXT | notes | Yes | Customer notes/preferences |
| allergies | TEXT | allergies | Yes | Known allergies |
| emailOptIn | INTEGER | email_opt_in | Yes | 0/1 - Email marketing consent |
| smsOptIn | INTEGER | sms_opt_in | Yes | 0/1 - SMS marketing consent |
| status | TEXT | status | Yes | Customer status |
| isActive | INTEGER | is_active | Yes | 0/1 - Customer active status |
| createdAt | TEXT | created_at | Yes | ISO8601 creation timestamp |
| updatedAt | TEXT | updated_at | Yes | ISO8601 last update timestamp |

### 3. Tickets Table

Service tickets for walk-in customers and appointment conversions.

| Column | Type | SQLite Name | Nullable | Description |
|--------|------|-------------|----------|-------------|
| id | TEXT | id | No | Primary key (string UUID) |
| customerId | TEXT | customer_id | Yes | Foreign key to customers.id |
| employeeId | INTEGER | employee_id | No | Foreign key to employees.id |
| ticketNumber | INTEGER | ticket_number | No | Sequential ticket number |
| customerName | TEXT | customer_name | No | Customer display name |
| services | TEXT | services | No | JSON array of services |
| priority | INTEGER | priority | Yes | Ticket priority (1-5) |
| notes | TEXT | notes | Yes | Service notes |
| status | TEXT | status | Yes | queued/assigned/in-service/completed/paid |
| createdAt | TEXT | created_at | Yes | ISO8601 creation timestamp |
| updatedAt | TEXT | updated_at | Yes | ISO8601 last update timestamp |
| businessDate | TEXT | business_date | No | ISO8601 business date |
| checkInTime | TEXT | check_in_time | Yes | ISO8601 check-in timestamp |
| assignedTechnicianId | INTEGER | assigned_technician_id | Yes | Assigned technician ID |
| totalAmount | REAL | total_amount | Yes | Total service amount |
| paymentStatus | TEXT | payment_status | Yes | Payment status |
| isGroupService | INTEGER | is_group_service | Yes | 0/1 - Group service indicator |
| groupSize | INTEGER | group_size | Yes | Number in group |
| appointmentId | TEXT | appointment_id | Yes | Link to appointment if applicable |

### 4. Services Table

Service catalog with pricing and duration.

| Column | Type | SQLite Name | Nullable | Description |
|--------|------|-------------|----------|-------------|
| id | INTEGER | id | No | Primary key, auto-increment |
| name | TEXT | name | No | Service name |
| description | TEXT | description | Yes | Service description |
| categoryId | INTEGER | category_id | Yes | Foreign key to service_categories.id |
| durationMinutes | INTEGER | duration_minutes | No | Service duration in minutes |
| basePrice | REAL | base_price | No | Base service price |
| isActive | INTEGER | is_active | Yes | 0/1 - Service active status |
| createdAt | TEXT | created_at | Yes | ISO8601 creation timestamp |
| updatedAt | TEXT | updated_at | Yes | ISO8601 last update timestamp |

### 5. Invoices Table

Consolidated invoices for multi-ticket payments.

| Column | Type | SQLite Name | Nullable | Description |
|--------|------|-------------|----------|-------------|
| id | TEXT | id | No | Primary key (string UUID) |
| invoiceNumber | TEXT | invoice_number | No | Human-readable invoice number |
| ticketIds | TEXT | ticket_ids | No | JSON array of ticket IDs |
| customerName | TEXT | customer_name | Yes | Main customer name |
| subtotal | REAL | subtotal | No | Pre-tax/tip subtotal |
| taxAmount | REAL | tax_amount | No | Tax amount |
| tipAmount | REAL | tip_amount | No | Tip amount |
| discountAmount | REAL | discount_amount | No | Discount amount |
| totalAmount | REAL | total_amount | No | Final total amount |
| paymentMethod | TEXT | payment_method | No | Payment method used |
| discountType | TEXT | discount_type | Yes | Type of discount applied |
| discountCode | TEXT | discount_code | Yes | Discount code used |
| discountReason | TEXT | discount_reason | Yes | Reason for discount |
| cardType | TEXT | card_type | Yes | Credit card type |
| lastFourDigits | TEXT | last_four_digits | Yes | Last 4 digits of card |
| transactionId | TEXT | transaction_id | Yes | Payment processor transaction ID |
| authorizationCode | TEXT | authorization_code | Yes | Authorization code |
| processedAt | TEXT | processed_at | No | ISO8601 processing timestamp |
| processedBy | TEXT | processed_by | No | Employee who processed payment |
| notes | TEXT | notes | Yes | Payment notes |
| createdAt | TEXT | created_at | No | ISO8601 creation timestamp |
| updatedAt | TEXT | updated_at | No | ISO8601 last update timestamp |

### 6. Payments Table

Individual payment records linked to tickets or invoices.

| Column | Type | SQLite Name | Nullable | Description |
|--------|------|-------------|----------|-------------|
| id | TEXT | id | No | Primary key (string UUID) |
| ticketId | TEXT | ticket_id | No | Foreign key to tickets.id |
| invoiceId | TEXT | invoice_id | Yes | Foreign key to invoices.id |
| paymentMethod | TEXT | payment_method | No | Payment method |
| amount | REAL | amount | No | Payment amount |
| tipAmount | REAL | tip_amount | Yes | Tip amount |
| taxAmount | REAL | tax_amount | Yes | Tax amount |
| discountAmount | REAL | discount_amount | Yes | Discount amount |
| totalAmount | REAL | total_amount | Yes | Total payment amount |
| discountType | TEXT | discount_type | Yes | Discount type |
| discountCode | TEXT | discount_code | Yes | Discount code |
| discountReason | TEXT | discount_reason | Yes | Discount reason |
| cardType | TEXT | card_type | Yes | Credit card type |
| lastFourDigits | TEXT | last_four_digits | Yes | Last 4 card digits |
| transactionId | TEXT | transaction_id | Yes | Transaction ID |
| authorizationCode | TEXT | authorization_code | Yes | Authorization code |
| processedAt | TEXT | processed_at | Yes | ISO8601 processing timestamp |
| processedBy | TEXT | processed_by | Yes | Processing employee |
| notes | TEXT | notes | Yes | Payment notes |
| createdAt | TEXT | created_at | Yes | ISO8601 creation timestamp |
| updatedAt | TEXT | updated_at | Yes | ISO8601 last update timestamp |

### 7. Appointments Table

Scheduled appointments with booking information.

| Column | Type | SQLite Name | Nullable | Description |
|--------|------|-------------|----------|-------------|
| id | TEXT | id | No | Primary key (string UUID) |
| customerId | TEXT | customer_id | No | Foreign key to customers.id |
| employeeId | INTEGER | employee_id | No | Foreign key to employees.id |
| appointmentStartDateTime | TEXT | start_datetime | No | ISO8601 start timestamp |
| appointmentEndDateTime | TEXT | end_datetime | No | ISO8601 end timestamp |
| services | TEXT | services | No | JSON array of services |
| status | TEXT | status | Yes | Appointment status |
| notes | TEXT | notes | Yes | Appointment notes |
| isGroupBooking | INTEGER | is_group_booking | Yes | 0/1 - Group booking indicator |
| groupSize | INTEGER | group_size | Yes | Group size |
| createdAt | TEXT | created_at | No | ISO8601 creation timestamp |
| updatedAt | TEXT | updated_at | No | ISO8601 last update timestamp |
| lastModifiedBy | TEXT | last_modified_by | Yes | Last modifier |
| lastModifiedDevice | TEXT | last_modified_device | Yes | Last modifying device |
| confirmedAt | TEXT | confirmed_at | Yes | ISO8601 confirmation timestamp |
| confirmationType | TEXT | confirmation_type | Yes | Confirmation method |

### 8. ServiceCategories Table

Service categorization for organization and filtering.

| Column | Type | SQLite Name | Nullable | Description |
|--------|------|-------------|----------|-------------|
| id | TEXT | id | Yes | Primary key (string) |
| name | TEXT | name | No | Category name |
| color | TEXT | color | Yes | Hex color code |
| icon | TEXT | icon | Yes | Icon identifier |

### 9. EmployeeServiceCategories Table

Many-to-many relationship between employees and service categories.

| Column | Type | SQLite Name | Nullable | Description |
|--------|------|-------------|----------|-------------|
| id | TEXT | id | Yes | Primary key (string UUID) |
| employeeId | INTEGER | employee_id | No | Foreign key to employees.id |
| categoryName | TEXT | category_name | Yes | Category name |

### 10. Settings Table

System and user configuration settings.

| Column | Type | SQLite Name | Nullable | Description |
|--------|------|-------------|----------|-------------|
| key | TEXT | key | No | Primary key - setting identifier |
| value | TEXT | value | No | Setting value (serialized) |
| category | TEXT | category | Yes | Setting category |
| dataType | TEXT | data_type | Yes | Data type hint |
| description | TEXT | description | Yes | Human-readable description |
| isSystem | INTEGER | is_system | Yes | 0/1 - System vs user setting |
| createdAt | TEXT | created_at | Yes | ISO8601 creation timestamp |
| updatedAt | TEXT | updated_at | Yes | ISO8601 last update timestamp |

**Setting Categories:**
- `dashboard` - Dashboard display settings
- `store` - Store operation settings
- `general` - General application settings
- `salon` - Salon-specific settings

### 11. TechnicianSchedules Table

Employee work schedules and time-off tracking.

| Column | Type | SQLite Name | Nullable | Description |
|--------|------|-------------|----------|-------------|
| id | TEXT | id | No | Primary key (string UUID) |
| employeeId | INTEGER | employee_id | No | Foreign key to employees.id |
| dayOfWeek | TEXT | day_of_week | No | monday, tuesday, etc. |
| isScheduledOff | INTEGER | is_scheduled_off | No | 0/1 - Scheduled day off |
| startTime | INTEGER | start_time | Yes | Minutes since midnight |
| endTime | INTEGER | end_time | Yes | Minutes since midnight |
| effectiveDate | TEXT | effective_date | Yes | ISO8601 effective date |
| notes | TEXT | notes | Yes | Schedule notes |
| isActive | INTEGER | is_active | No | 0/1 - Schedule active |
| createdAt | TEXT | created_at | Yes | ISO8601 creation timestamp |
| updatedAt | TEXT | updated_at | Yes | ISO8601 last update timestamp |

### 12. TimeEntries Table

Employee time tracking and clock-in/out records.

| Column | Type | SQLite Name | Nullable | Description |
|--------|------|-------------|----------|-------------|
| id | TEXT | id | No | Primary key (string UUID) |
| employeeId | INTEGER | employee_id | No | Foreign key to employees.id |
| clockIn | TEXT | clock_in | No | ISO8601 clock-in timestamp |
| clockOut | TEXT | clock_out | Yes | ISO8601 clock-out timestamp |
| breakMinutes | INTEGER | break_minutes | No | Break time in minutes (default: 0) |
| totalHours | REAL | total_hours | Yes | Calculated total hours |
| status | TEXT | status | No | active/completed/edited (default: active) |
| editedBy | TEXT | edited_by | Yes | Employee who edited entry |
| editReason | TEXT | edit_reason | Yes | Reason for editing |
| createdAt | TEXT | created_at | No | ISO8601 creation timestamp |
| updatedAt | TEXT | updated_at | No | ISO8601 last update timestamp |

---

## Type Converters

### ServicesJsonConverter
Converts service arrays between JSON strings and List<Map<String, dynamic>>.

**Usage:**
- Tickets.services field
- Appointments.services field

### SettingsJsonConverter
Converts settings data between JSON strings and Map<String, dynamic>.

**Usage:**
- Settings.value field for complex settings

---

## Data Types & Storage

| Dart Type | SQLite Storage | Notes |
|-----------|----------------|-------|
| String | TEXT | UTF-8 text |
| int | INTEGER | 64-bit signed integer |
| double | REAL | 64-bit floating point |
| bool | INTEGER | 0 = false, 1 = true |
| DateTime | TEXT | ISO8601 format |
| List<Map> | TEXT | JSON serialized |
| Map | TEXT | JSON serialized |

---

## Common Patterns

### Timestamps
All timestamps are stored as TEXT in ISO8601 format:
- `2025-08-06T14:30:00.000Z` (UTC)
- `2025-08-06T14:30:00.000-05:00` (with timezone)

### Boolean Values
Stored as INTEGER where:
- `0` = false
- `1` = true

### UUIDs
Text-based primary keys use UUID format:
- `550e8400-e29b-41d4-a716-446655440000`

### Time Storage
Times within a day stored as minutes since midnight:
- `540` = 9:00 AM (9 * 60)
- `1080` = 6:00 PM (18 * 60)

---

## Performance Optimizations

### Indexes
The database includes performance indexes on frequently queried columns:
- Ticket status and business date
- Appointment date ranges
- Employee time entries
- Customer lookups

### Foreign Key Constraints
Enabled with `PRAGMA foreign_keys = ON` for referential integrity.

### Schema Versioning
Current version: **15** with comprehensive migration strategy for schema evolution.

---

## Migration History

| Version | Changes |
|---------|---------|
| 1 | Initial schema |
| 2 | Performance indexes |
| 3 | Appointment column migrations |
| 4 | Employee SSN field |
| 5 | Settings table |
| 6 | Store settings structure |
| 7 | Ticket status column |
| 8 | Appointment confirmation tracking |
| 9 | Assigned technician ID type change |
| 10 | Technician schedules table |
| 11 | Time entries table |
| 12 | Employee PIN authentication |
| 13 | Invoices table |
| 14 | Service category icons |
| 15 | Appointment ID in tickets |

---

*This schema documentation is automatically maintained and reflects the current state of the production database.*