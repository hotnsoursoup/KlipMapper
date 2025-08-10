# POS Dashboard Business Rules & Logic Requirements

*Generated: January 2025*
*Status: In Progress - Refactoring Analysis*

## 🎯 **Core Business Requirements**

Based on user requirements and existing implementation analysis:

### **Technician Card Logic**
**Display Rules:**
- Show technician cards for **clocked-in employees only**
- Card status reflects current work state:
  - **Available** (green): Clocked in, no assigned tickets
  - **Assigned** (yellow): Has assigned ticket but hasn't started service  
  - **Busy** (red): Currently working on ticket (in-service status)

**Status Priority (Highest to Lowest):**
1. **In-Service** - Currently working on ticket
2. **Assigned** - Has ticket assigned but not started
3. **Available** - No tickets, ready for work

**Current Ticket Display:**
- Show current ticket number if technician has one
- Priority: in-service ticket > assigned ticket > queued ticket with assignment

### **Queue Card Logic**
**What appears in queue:**
- Tickets with status: `'queued'`
- Tickets with "Any" technician assignment:
  - `assignedTechnicianId` is `null`, `''`, `'0'`, or `'-1'`
- Tickets NOT assigned to specific available technicians

**What does NOT appear in queue:**
- Tickets assigned to available, clocked-in technicians
- Tickets with status: `'in-service'`, `'completed'`, `'paid'`, `'voided'`, `'canceled'`

### **Ticket Assignment Flow**

**New Ticket Creation:**
```
1. Customer checks in → Ticket created with status 'queued'
2. IF assigned to specific technician AND technician is available/clocked-in:
   → Goes directly to technician card (bypasses queue)
3. ELSE (assigned to "Any" or technician unavailable):
   → Goes to queue for manual or auto-assignment
```

**Auto-Assignment Rules:**
- **Trigger**: When available technicians exist + unassigned tickets in queue
- **Selection**: Oldest ticket (by check-in time) goes to first available technician
- **Requirements**: Technician must be clocked-in AND status 'available'
- **Action**: Assign ticket AND immediately start service (status: 'queued' → 'in-service')

### **Upcoming Appointments Logic**
**Display Rules:**
- Show appointments with status: `'scheduled'`, `'confirmed'`, `'unconfirmed'`
- Hide appointments with status: `'arrived'`, `'in-service'`, `'completed'`, `'no-show'`, `'canceled'`
- Filter: Today's appointments only (not future dates)

## 🐛 **Current Issues Identified**

### **Issue 1: Technician Specializations Bug**
**Problem**: `_loadTechnicianSpecializations()` returns hardcoded `['nails', 'gel']`
**Location**: `dashboard_store.dart:1057-1067`
**Root Cause**: Method not implemented - should query `employee_service_categories` table
**Impact**: All technicians show same specializations regardless of actual capabilities

**Fix Required:**
```dart
Future<List<String>> _loadTechnicianSpecializations(int employeeId) async {
  // Query employee_service_categories table
  final categories = await database.employeeServiceCategories
      .select()
      .where((t) => t.employeeId.equals(employeeId))
      .get();
  
  return categories.map((c) => c.categoryName ?? '').where((c) => c.isNotEmpty).toList();
}
```

### **Issue 2: Monolithic Store Architecture**
**Problem**: Single `DashboardStore` manages everything (violates MobX UI Bible)
**Impact**: 
- Full screen rebuilds for minor changes
- Poor performance with large datasets
- Difficult to test and maintain

### **Issue 3: Manual Data Reloading**
**Problem**: `loadDataFromDatabase()` called 12+ times per user action
**Impact**: 
- Expensive database queries
- UI lag during busy periods
- Inefficient resource usage

## 📋 **Detailed Business Logic Mapping**

### **Technician Status Calculation**
**Current Implementation** (`dashboard_store.dart:820-857`):
```dart
// Priority logic:
1. Check for in-service tickets (status = 'busy')
2. Check for assigned tickets (status = 'assigned') 
3. Check for queued tickets with assignment (status = 'assigned')
4. Default to 'available'
```

**Clock-in Status Integration:**
- `isOff = !emp.isClockedIn` (Employee model)
- Clocked-out technicians don't show cards

### **Queue Management Logic**
**Current Implementation** (`dashboard_store.dart:1211-1219`):
```dart
final unassignedTickets = queueTickets.where((ticket) =>
  ticket.status == 'queued' && 
  TechnicianLookupService.isAnyTechnician(ticket.assignedTechnicianId)
).toList()
```

**Filter Types:**
- 'All': Show all queue tickets
- Additional filters: Priority, Walk-in, Service type (not currently implemented)

### **Auto-Assignment Logic**
**Current Implementation** (`dashboard_store.dart:1199-1240`):
```dart
1. Find available technicians (clocked-in + status 'available')
2. Find unassigned tickets (oldest first by check-in time)
3. Assign oldest ticket to first available technician
4. Start service immediately (assignTicket + checkInCustomer)
5. Reload all data (expensive!)
```

## 🎯 **Target Architecture Requirements**

### **Granular Store Responsibilities:**
1. **TechnicianStatusStore**: Technician states + current tickets only
2. **QueueManagementStore**: Queue tickets + filtering only  
3. **TicketAssignmentStore**: Assignment logic + auto-assignment only
4. **AppointmentDisplayStore**: Upcoming appointments filtering only
5. **DashboardUIStore**: UI state (dialogs, layouts) only

### **Reactive Data Flow:**
- Stores observe each other's state changes
- No manual `loadDataFromDatabase()` calls
- Immediate UI updates on state changes

### **Performance Goals:**
- 60fps with 50+ queue items
- <100ms response time for assignments
- Minimal widget rebuilds (surgical updates only)

## 📝 **Implementation Notes**

**"Any" Technician Handling:**
- Use `TechnicianLookupService.isAnyTechnician()` consistently
- Values: `null`, `''`, `'0'`, `'-1'` all represent "Any"
- Never default to technician ID `'1'`

**Database Schema Requirements:**
- `employee_service_categories` table exists
- Supports many-to-many employee → service category mapping
- Contains `employeeId` (int) and `categoryName` (string) fields

**MobX UI Bible Compliance:**
- Immutable state objects using Freezed
- Strategic Observer placement (not whole-screen)
- RepaintBoundary around expensive components
- Const constructors for static widgets

---

*This document will be updated as refactoring progresses*