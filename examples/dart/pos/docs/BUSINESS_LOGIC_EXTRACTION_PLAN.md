# 🎯 Business Logic Extraction & Implementation Plan

*Breaking Down Dashboard Logic into Granular Riverpod + MobX Stores*

## 📋 Overview

This plan extracts the business logic from the monolithic `DashboardStore` and implements it correctly in the new granular store architecture, based on your specifications:

- **Customer Queue**: Today's "in queue" status tickets
- **Technician Status**: Clock-in + ticket assignment availability
- **Assignment Logic**: FIFO + service capability matching  
- **Appointments**: Today's "scheduled/confirmed/unconfirmed" status
- **Service Matching**: Category-based technician capability filtering

---

## 🎯 TASK 1: Customer Queue Logic Extraction

**Goal**: Extract ticket filtering and implement reactive queue management

### Subtasks:
1. **Analyze Current Ticket Filtering**
   - Review `DashboardStore.queueTickets` implementation
   - Identify current status filtering logic
   - Document existing FIFO ordering mechanism

2. **Identify Database Status Values**
   - Examine tickets table schema for status field
   - Confirm "in queue", "queued", or similar status values
   - Document all possible ticket statuses

3. **Extract Date Filtering Logic**
   - Find current "today's tickets" filtering
   - Extract business date vs calendar date logic
   - Implement proper timezone handling

4. **Extract FIFO Ordering Logic**
   - Analyze current check-in time ordering
   - Document priority vs regular customer handling
   - Extract queue position calculation

5. **Implement in QueueManagementStore**
   - Use `getTickets(status: 'queued')` from repository
   - Add reactive `filteredTickets` computed property
   - Implement `queueLength` computed property

6. **Add Queue Operations**
   - Implement `nextTicket` computed property
   - Add queue filtering by service type/priority
   - Handle "Any" technician filtering integration

7. **Handle Edge Cases**
   - Empty queue states
   - Invalid ticket statuses
   - Date boundary edge cases

8. **Test Reactive Updates**
   - Verify queue updates when tickets added/removed
   - Test filtering changes trigger UI updates
   - Validate queue ordering maintains FIFO

---

## 🎯 TASK 2: Technician Status Logic Extraction

**Goal**: Extract technician availability logic and implement status management

### Subtasks:
1. **Analyze Current Technician Loading**
   - Review `DashboardStore.technicians` implementation
   - Extract employee → technician conversion logic
   - Document current status calculation

2. **Extract Clock-In Status Logic**
   - Find current "clocked in" determination
   - Extract work shift/schedule checking
   - Document clock-in data sources

3. **Extract Assignment Status Detection** 
   - Analyze current ticket assignment checking
   - Extract "busy" vs "available" logic
   - Document status priority rules

4. **Implement Status Priority Logic**
   - Implement: `in-service > assigned > available`
   - Handle status transitions properly
   - Add status change notifications

5. **Extract Specialization Loading**
   - Fix current hardcoded specializations
   - Use `employeeServiceCategories` table properly
   - Load from `_loadTechnicianSpecializations()`

6. **Implement Computed Properties**
   - Add `availableCount`, `busyCount` computeds
   - Create `availableTechnicians`, `busyTechnicians` lists
   - Implement `allTechnicians` property

7. **Handle Status Transitions**
   - Implement `updateTechnicianStatus()` action
   - Handle assignment → busy transitions
   - Manage completion → available transitions

8. **Test Status Reactivity**
   - Verify status changes trigger UI updates
   - Test computed properties update correctly
   - Validate assignment changes affect availability

---

## 🎯 TASK 3: Ticket Assignment Business Logic

**Goal**: Extract assignment algorithm and implement smart matching system

### Subtasks:
1. **Analyze Current Assignment Algorithm**
   - Review `DashboardStore` assignment logic
   - Extract technician selection criteria
   - Document current auto-assignment triggers

2. **Extract Service-Capability Matching**
   - Find service category → technician mapping
   - Extract qualification checking logic
   - Document capability filtering rules

3. **Implement FIFO with Capability**
   - Combine queue order with technician capabilities
   - Implement smart technician selection
   - Handle "no qualified techs" scenarios

4. **Handle Ticket Creation Flows**
   - Extract appointment → ticket conversion
   - Extract walk-in → ticket creation
   - Document service selection validation

5. **Extract Auto-Assignment Triggers**
   - Identify when auto-assignment runs
   - Extract trigger conditions (queue changes, tech availability)
   - Implement reactive assignment monitoring

6. **Implement Smart Selection Logic**
   - Priority 1: Service specialization match
   - Priority 2: Workload balancing
   - Priority 3: FIFO availability

7. **Handle Assignment Results**
   - Implement success/failure result types
   - Handle edge cases (no techs, conflicts)
   - Add assignment history/logging

8. **Test Assignment Reactivity**
   - Verify assignments trigger when techs become available
   - Test service matching works correctly
   - Validate FIFO order maintained

---

## 🎯 TASK 4: Appointment Display Logic Extraction

**Goal**: Extract appointment filtering and implement display management

### Subtasks:
1. **Analyze Current Appointment Filtering**
   - Review `DashboardStore.appointments` logic
   - Extract current filtering implementation
   - Document appointment display rules

2. **Extract Today's Date Filtering**
   - Find current date filtering logic
   - Handle appointment date vs time logic
   - Implement proper date boundary handling

3. **Filter Valid Status Values**
   - Implement "scheduled", "confirmed", "unconfirmed" filtering
   - Document all appointment status values
   - Handle status transitions properly

4. **Extract Sorting Logic**
   - Find current appointment ordering
   - Extract time-based sorting rules
   - Implement proper chronological display

5. **Implement Overdue Detection**
   - Extract overdue appointment logic
   - Add overdue flagging for UI
   - Handle timezone considerations

6. **Add Computed Properties**
   - Implement `upcomingCount` property
   - Add `todaysAppointments` filtered list
   - Create `overdueAppointments` list

7. **Handle Status Updates**
   - React to appointment status changes
   - Update display when appointments confirmed
   - Handle appointment cancellations

8. **Test Appointment Reactivity**
   - Verify appointment list updates reactively
   - Test status filtering works correctly
   - Validate sorting maintains chronological order

---

## 🎯 TASK 5: Service-Category-Technician Matching

**Goal**: Extract service matching logic and implement capability system

### Subtasks:
1. **Analyze Service Category Mapping**
   - Review current service → category mapping
   - Extract category assignment logic
   - Document service categorization rules

2. **Extract Technician Specializations**
   - Fix `employeeServiceCategories` table usage
   - Extract specialization loading logic
   - Document technician capability assignment

3. **Implement Capability Checking**
   - Create service capability validation
   - Implement category-based matching
   - Handle multiple category assignments

4. **Handle Edge Cases**
   - No qualified technicians scenario
   - Service without category assignment
   - Technician without specializations

5. **Extract Service Filtering**
   - Filter available services by technician
   - Filter available technicians by service
   - Implement bi-directional capability checking

6. **Generate Qualified Lists**
   - Create qualified technician list for services
   - Create available service list for technicians
   - Implement capability intersection logic

7. **Handle Dynamic Updates**
   - React to technician capability changes
   - Update when service categories change
   - Handle specialization assignments

8. **Test Capability Matching**
   - Verify service-tech matching works
   - Test edge cases handle gracefully
   - Validate capability updates propagate

---

## 📋 Implementation Sequence

### Phase 1: Data Foundation (Week 1)
- **Task 2**: Technician Status Logic (foundational)
- **Task 5**: Service-Category Matching (supports assignments)

### Phase 2: Core Business Logic (Week 2)  
- **Task 1**: Customer Queue Logic
- **Task 4**: Appointment Display Logic

### Phase 3: Advanced Logic (Week 3)
- **Task 3**: Ticket Assignment Logic (depends on Tasks 1, 2, 5)

### Phase 4: Integration & Testing (Week 4)
- Integration testing across all stores
- Performance optimization
- Business logic validation

---

## 🔧 Implementation Guidelines

### Code Extraction Pattern
```dart
// 1. Find in DashboardStore
@computed
List<Ticket> get queueTickets => _tickets.where((t) => 
  t.status == 'queued' && _isToday(t.checkInTime)).toList();

// 2. Extract to QueueManagementStore  
@computed
List<Ticket> get filteredTickets => queueTickets.where((ticket) {
  if (ticket.status != 'queued') return false;
  if (!_isToday(ticket.checkInTime)) return false;
  return true;
}).toList()..sort((a, b) => a.checkInTime.compareTo(b.checkInTime));
```

### Testing Strategy
```dart
// Test each extracted piece
test('queue filters only queued tickets for today', () {
  final store = QueueManagementStore();
  // Add test tickets with different statuses/dates
  expect(store.filteredTickets, hasLength(expectedCount));
});
```

### Business Rule Validation
- Each extracted rule should be documented
- Edge cases should be explicitly handled  
- Original behavior must be preserved exactly
- Performance should be equal or better

---

## 🎯 Success Criteria

### Functional Requirements
- [ ] Customer queue shows only today's "queued" tickets in FIFO order
- [ ] Technician status reflects clock-in + assignment state correctly
- [ ] Assignment logic matches service capabilities with FIFO ordering
- [ ] Appointments display today's scheduled/confirmed/unconfirmed only
- [ ] Service matching filters technicians by capability correctly

### Technical Requirements  
- [ ] All business logic extracted from DashboardStore
- [ ] Reactive updates work for all computed properties
- [ ] Performance is equal or better than current implementation
- [ ] All existing edge cases handled properly
- [ ] Code is maintainable and well-documented

### Validation Tests
- [ ] Queue updates when tickets added/removed/status changed
- [ ] Technician availability changes when assignments made
- [ ] Assignment logic selects correct technician for services
- [ ] Appointment list updates when statuses change
- [ ] Service filtering works bidirectionally (service→tech, tech→service)

---

**This plan will modernize your data architecture while preserving all existing business logic and UI behavior! 🚀**