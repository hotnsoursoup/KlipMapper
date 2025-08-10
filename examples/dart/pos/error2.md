
This document summarizes the build errors, listing each file and its associated errors.

---

### General Errors

- **`CUSTOMBUILD`**: `error : Couldn't resolve the package 'provider' in 'package:provider/provider.dart'.`
- **`Microsoft.CppCommon.targets(254,5)`**: `error MSB8066: Custom build for 'D:\ClaudeProjects\POSflutter\pos\build\windows\x64\CMakeFiles\...' exited with code 1.`

---

### File-Specific Errors

#### `lib/core/auth/pin_auth_service.dart`
- `error G75B77105: Member not found: 'PosDatabase.ensureInitialized'.` (7 occurrences)

#### `lib/core/database/tables/appointment_services.dart`
- `error G4127D1E8: The getter 'Appointments' isn't defined for the class 'AppointmentServices'.`
- `error G4127D1E8: The getter 'Services' isn't defined for the class 'AppointmentServices'.`
- `error G4127D1E8: The getter 'Employees' isn't defined for the class 'AppointmentServices'.`

#### `lib/core/database/tables/appointments.dart`
- `error G4127D1E8: The getter 'Customers' isn't defined for the class 'Appointments'.`
- `error G4127D1E8: The getter 'Employees' isn't defined for the class 'Appointments'.` (2 occurrences)

#### `lib/core/database/tables/customers.dart`
- `error G4127D1E8: The getter 'Employees' isn't defined for the class 'Customers'.`

#### `lib/core/database/tables/employee_service_categories.dart`
- `error G4127D1E8: The getter 'Employees' isn't defined for the class 'EmployeeServiceCategories'.`
- `error G4127D1E8: The getter 'ServiceCategories' isn't defined for the class 'EmployeeServiceCategories'.`

#### `lib/core/database/tables/invoice_tickets.dart`
- `error G4127D1E8: The getter 'Invoices' isn't defined for the class 'InvoiceTickets'.`
- `error G4127D1E8: The getter 'Tickets' isn't defined for the class 'InvoiceTickets'.`

#### `lib/core/database/tables/invoices.dart`
- `error G4127D1E8: The getter 'Employees' isn't defined for the class 'Invoices'.`

#### `lib/core/database/tables/payments.dart`
- `error G4127D1E8: The getter 'Tickets' isn't defined for the class 'Payments'.`
- `error G4127D1E8: The getter 'Invoices' isn't defined for the class 'Payments'.`
- `error G4127D1E8: The getter 'Employees' isn't defined for the class 'Payments'.`

#### `lib/core/database/tables/services.dart`
- `error G4127D1E8: The getter 'ServiceCategories' isn't defined for the class 'Services'.`

#### `lib/core/database/tables/technician_schedules.dart`
- `error G4127D1E8: The getter 'Employees' isn't defined for the class 'TechnicianSchedules'.`

#### `lib/core/database/tables/ticket_services.dart`
- `error G4127D1E8: The getter 'Tickets' isn't defined for the class 'TicketServices'.`
- `error G4127D1E8: The getter 'Services' isn't defined for the class 'TicketServices'.`
- `error G4127D1E8: The getter 'Employees' isn't defined for the class 'TicketServices'.`

#### `lib/core/database/tables/tickets.dart`
- `error G4127D1E8: The getter 'Customers' isn't defined for the class 'Tickets'.`
- `error G4127D1E8: The getter 'Employees' isn't defined for the class 'Tickets'.` (2 occurrences)
- `error G4127D1E8: The getter 'Appointments' isn't defined for the class 'Tickets'.`

#### `lib/core/database/tables/time_entries.dart`
- `error G4127D1E8: The getter 'Employees' isn't defined for the class 'TimeEntries'.` (2 occurrences)

#### `lib/core/services/cache_coordination_service.dart`
- `error GFAA2A68C: Error when reading 'lib/features/tickets/providers/tickets_provider.dart': The system cannot find the file specified.`
- `error GFAA2A68C: Error when reading 'lib/features/services/providers/service_categories_provider.dart': The system cannot find the file specified.`
- `error G4127D1E8: The getter 'ticketsProvider' isn't defined for the class 'CacheCoordinator'.` (4 occurrences)
- `error G4127D1E8: The getter 'customersProvider' isn't defined for the class 'CacheCoordinator'.` (3 occurrences)
- `error G4127D1E8: The getter 'serviceCategoriesProvider' isn't defined for the class 'CacheCoordinator'.` (4 occurrences)

#### `lib/core/widgets/async_value_widget.dart`
- `error G5FE39F1E: Type 'ProviderListenable' not found.`
- `error GE8981870: 'ProviderListenable' isn't a type.`

#### `lib/features/appointments/presentation/screens/appointments_screen.dart`
- `error G311314CC: Method not found: 'StateProvider'.`
- `error G4127D1E8: The getter 'appointmentsMasterProvider' isn't defined for the class 'AppointmentsScreen'.` (2 occurrences)
- `error G4127D1E8: The getter 'length' isn't defined for the class 'AsyncValue<List<Appointment>>'.`
- `error G4127D1E8: The getter 'isEmpty' isn't defined for the class 'AsyncValue<List<Appointment>>'.`
- `error GC2F972A8: The argument type 'AsyncValue<List<Appointment>>' can't be assigned to the parameter type 'List<Appointment>'.`
- `error G75B77105: Member not found: 'headline4'.`
- `error G4127D1E8: The getter 'startDateTime' isn't defined for the class 'Appointment'.`
- `error G4127D1E8: The getter 'todayCount' isn't defined for the class 'AppointmentStatistics'.`
- `error G4127D1E8: The getter 'upcomingCount' isn't defined for the class 'AppointmentStatistics'.`
- `error G4127D1E8: The getter 'confirmedCount' isn't defined for the class 'AppointmentStatistics'.`
- `error G4127D1E8: The getter 'cancelledCount' isn't defined for the class 'AppointmentStatistics'.`

#### `lib/features/appointments/presentation/widgets/appointment_calendar_grid.dart`
- `error GFAA2A68C: Error when reading 'lib/features/appointments/providers/appointment_providers_updated.dart': The system cannot find the file specified.`
- `error G4127D1E8: The getter 'selectedDateProvider' isn't defined for the class '_AppointmentCalendarGridState'.`
- `error G4127D1E8: The getter 'storeHoursSettingProvider' isn't defined for the class '_AppointmentCalendarGridState'.`

#### `lib/features/appointments/presentation/widgets/appointment_card.dart`
- `error G4127D1E8: The getter 'parsedValue' isn't defined for the class 'StoreSetting'.` (2 occurrences)

#### `lib/features/appointments/presentation/widgets/appointment_week_chart_view.dart`
- `error GFAA2A68C: Error when reading 'lib/features/settings/data/settings_store.dart': The system cannot find the file specified.`
- `error G832450DD: Not found: 'package:provider/provider.dart'`
- `error GFAA2A68C: Error when reading 'lib/features/appointments/data/stores/appointments_store.dart': The system cannot find the file specified.`
- `error G5FE39F1E: Type 'AppointmentsStore' not found.`
- `error G86E656EB: 'AppointmentsStore' isn't a type.` (2 occurrences)
- `error G4127D1E8: The getter 'Provider' isn't defined for the class '_AppointmentWeekChartViewState'.` (2 occurrences)
- `error GE5CFE876: The method 'Observer' isn't defined for the class '_AppointmentWeekChartViewState'.`
- `error G4A624820: 'SettingsStore' isn't a type.`

#### `lib/features/appointments/presentation/widgets/appointment_week_view.dart`
- `error GFAA2A68C: Error when reading 'lib/features/settings/data/settings_store.dart': The system cannot find the file specified.`
- `error G832450DD: Not found: 'package:provider/provider.dart'`
- `error GFAA2A68C: Error when reading 'lib/features/appointments/data/stores/appointments_store.dart': The system cannot find the file specified.`
- `error G5FE39F1E: Type 'AppointmentsStore' not found.` (2 occurrences)
- `error G86E656EB: 'AppointmentsStore' isn't a type.` (4 occurrences)
- `error G4A624820: 'SettingsStore' isn't a type.` (3 occurrences)
- `error G4127D1E8: The getter 'Provider' isn't defined for the class '_AppointmentWeekViewState'.` (4 occurrences)
- `error GE5CFE876: The method 'Observer' isn't defined for the class '_AppointmentWeekViewState'.`

#### `lib/features/appointments/presentation/widgets/comprehensive_appointment_dialog.dart`
- `error G4127D1E8: The getter 'servicesListProvider' isn't defined for the class '_ComprehensiveAppointmentDialogState'.`
- `error GC6690633: No named parameter with the name 'value'.`

#### `lib/features/appointments/presentation/widgets/technician_column.dart`
- `error GFAA2A68C: Error when reading 'lib/features/appointments/providers/appointments_provider.dart': The system cannot find the file specified.`
- `error G4127D1E8: The getter 'appointmentsMasterProvider' isn't defined for the class '_TechnicianColumnState'.`

#### `lib/features/appointments/providers/appointment_providers.dart`
- `error G0A556F40: The return type of the method 'TodaysAppointments.update' is 'Future<void>', which does not match the return type, 'Future<List<Appointment>>', of the overridden method...`
- `error G4906CC7E: The parameter 'appointment' of the method 'TodaysAppointments.update' has type 'Appointment', which does not match the corresponding type...`
- `error GE5CFE876: The method 'TodaysAppointments.update' has fewer named arguments than those of overridden method...`
- `error GE5CFE876: The method 'getCustomerAppointments' isn't defined for the class 'DriftAppointmentRepository'.`
- `error G7AD6136F: Method 'any' cannot be called on 'List<Service>?' because it is potentially null.`

#### `lib/features/appointments/providers/technician_providers.dart`
- `error G4127D1E8: The getter 'isActive' isn't defined for the class 'Employee'.`

#### `lib/features/checkout/presentation/screens/checkout_screen.dart`
- `error G832450DD: Not found: 'package:provider/provider.dart'`
- `error GFAA2A68C: Error when reading 'lib/features/tickets/data/tickets_store.dart': The system cannot find the file specified.`
- `error GFAA2A68C: Error when reading 'lib/features/checkout/data/stores/multi_checkout_store.dart': The system cannot find the file specified.`
- `error G5FE39F1E: Type 'TicketsStore' not found.`
- `error G5FE39F1E: Type 'MultiCheckoutStore' not found.`
- `error G95103D54: 'TicketsStore' isn't a type.` (2 occurrences)
- `error G4E4E8E74: 'MultiCheckoutStore' isn't a type.`
- `error G4127D1E8: The getter 'Provider' isn't defined for the class '_CheckoutScreenState'.`
- `error GE5CFE876: The method 'MultiCheckoutStore' isn't defined for the class '_CheckoutScreenState'.`
- `error GE5CFE876: The method 'Observer' isn't defined for the class '_CheckoutScreenState'.` (6 occurrences)

#### `lib/features/checkout/presentation/widgets/order_summary_panel.dart`
- `error GFAA2A68C: Error when reading 'lib/features/checkout/data/stores/multi_checkout_store.dart': The system cannot find the file specified.`
- `error G5FE39F1E: Type 'MultiCheckoutStore' not found.`
- `error G4E4E8E74: 'MultiCheckoutStore' isn't a type.`
- `error GE5CFE876: The method 'Observer' isn't defined for the class '_OrderSummaryPanelState'.` (5 occurrences)

#### `lib/features/customers/presentation/screens/customers_screen.dart`
- `error GC2F972A8: The argument type 'Map<String, Customer>' can't be assigned to the parameter type 'List<Customer>'.`
- `error G4127D1E8: The getter 'fullName' isn't defined for the class 'Customer'.` (5 occurrences)
- `error GC6690633: No named parameter with the name 'onSave'.` (2 occurrences)

#### `lib/features/customers/presentation/widgets/new_customer_dialog.dart`
- `error G4127D1E8: The getter 'customerCollectionSettingsProvider' isn't defined for the class '_NewCustomerDialogState'.` (2 occurrences)
- `error GC2F972A8: The argument type 'Object' can't be assigned to the parameter type 'DateTime'.`
- `error GC2F972A8: The argument type 'String' can't be assigned to the parameter type 'DateTime'.`
- `error G4127D1E8: The getter 'customersListProvider' isn't defined for the class '_NewCustomerDialogState'.`

#### `lib/features/customers/providers/customer_details_provider.dart`
- `error G76B49859: The non-abstract class 'CustomerDetails' is missing implementations for these members:`
- `error GE5CFE876: The method 'getCustomerTickets' isn't defined for the class 'DriftTicketRepository'.`

#### `lib/features/customers/providers/customers_provider.dart`
- `error G76B49859: The non-abstract class 'CustomerFiltersState' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'CustomerStatistics' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'SelectedCustomerAnalytics' is missing implementations for these members:`

#### `lib/features/dashboard/presentation/screens/dashboard_screen.dart`
- `error GFAA2A68C: Error when reading 'lib/features/dashboard/presentation/widgets/customer_queue_card_stub.dart': The system cannot find the file specified.`
- `error G4127D1E8: The getter 'parsedValue' isn't defined for the class 'StoreSetting'.` (8 occurrences)
- `error G4127D1E8: The getter 'showUpcomingAppointments' isn't defined for the class 'DashboardUIState'.` (3 occurrences)
- `error G4127D1E8: The getter 'isTimelineExpanded' isn't defined for the class 'DashboardUIState'.`
- `error GE5CFE876: The method 'toggleTimelineExpanded' isn't defined for the class 'DashboardUI'.`
- `error G4127D1E8: The getter 'technicianFilter' isn't defined for the class 'DashboardUIState'.` (4 occurrences)
- `error GE5CFE876: The method 'setTechnicianFilter' isn't defined for the class 'DashboardUI'.` (3 occurrences)
- `error G4127D1E8: The getter 'queueFilter' isn't defined for the class 'DashboardUIState'.` (4 occurrences)
- `error GE5CFE876: The method 'setQueueFilter' isn't defined for the class 'DashboardUI'.` (3 occurrences)
- `error G4127D1E8: The getter 'employeeStates' isn't defined for the class 'Object?'.`
- `error G4127D1E8: The getter 'queueTickets' isn't defined for the class 'Object?'.`
- `error GE5CFE876: The method 'CustomerQueueCard' isn't defined for the class '_DashboardScreenState'.`
- `error G4127D1E8: The getter 'isEmpty' isn't defined for the class 'Object?'.`
- `error G4127D1E8: The getter 'length' isn't defined for the class 'Object?'.`
- `error GE90CF69D: The operator '[]' isn't defined for the class 'Object?'.`
- `error GE5CFE876: The method 'updateTicket' isn't defined for the class 'QueueManagement'.`
- `error GE5CFE876: The method 'addTicket' isn't defined for the class 'QueueManagement'.` (2 occurrences)

#### `lib/features/dashboard/presentation/widgets/ticket_details/components/customer_selection_view.dart`
- `error G4127D1E8: The getter 'fullName' isn't defined for the class 'Customer'.` (3 occurrences)

#### `lib/features/dashboard/presentation/widgets/ticket_details/components/service_selection_view.dart`
- `error G036AE10F: Required named parameter 'turnNumber' must be provided.`
- `error G4127D1E8: The getter 'fullName' isn't defined for the class 'Customer'.` (2 occurrences)
- `error G4127D1E8: The getter 'categoryName' isn't defined for the class 'Service'.`

#### `lib/features/dashboard/presentation/widgets/ticket_details/components/ticket_actions_view.dart`
- `error G4127D1E8: The getter 'fullName' isn't defined for the class 'Customer'.`

#### `lib/features/dashboard/presentation/widgets/ticket_details/components/ticket_details_header.dart`
- `error G4127D1E8: The getter 'fullName' isn't defined for the class 'Customer'.`

#### `lib/features/dashboard/presentation/widgets/todays_schedule_widget.dart`
- `error G4127D1E8: The getter 'isTimelineExpanded' isn't defined for the class 'DashboardUIState'.`
- `error G4127D1E8: The getter 'scheduledStartTime' isn't defined for the class 'Appointment'.`
- `error G4127D1E8: The getter 'customerName' isn't defined for the class 'Appointment'.`

#### `lib/features/dashboard/providers/dashboard_ui_provider.dart`
- `error G5FE39F1E: Type 'HasOpenDialogsRef' not found.`
- `error G76B49859: The non-abstract class 'DashboardUIState' is missing implementations for these members:`
- `error G694F1090: 'HasOpenDialogsRef' isn't a type.`

#### `lib/features/dashboard/providers/employee_status_provider.dart`
- `error G76B49859: The non-abstract class 'EmployeeStatusState' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'EmployeeState' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'EmployeeStatusCalculation' is missing implementations for these members:`
- `error G4127D1E8: The getter 'ticketRepositoryProvider' isn't defined for the class 'EmployeeStatus'.`
- `error G4127D1E8: The getter 'future' isn't defined for the class 'AsyncValue<List<Employee>>'.`

#### `lib/features/dashboard/providers/queue_management_provider.dart`
- `error G5FE39F1E: Type 'TicketRepositoryRef' not found.`
- `error G5FE39F1E: Type 'FilteredQueueTicketsRef' not found.`
- `error G5FE39F1E: Type 'QueueLengthRef' not found.`
- `error G5FE39F1E: Type 'WaitingCustomersCountRef' not found.`
- `error G5FE39F1E: Type 'NextTicketRef' not found.`
- `error G5FE39F1E: Type 'PriorityTicketsRef' not found.`
- `error G5FE39F1E: Type 'WalkInTicketsRef' not found.`
- `error G5FE39F1E: Type 'AppointmentTicketsRef' not found.`
- `error G5FE39F1E: Type 'TicketsByServiceCategoryRef' not found.`
- `error G5FE39F1E: Type 'HasUnassignedTicketsRef' not found.`
- `error G5FE39F1E: Type 'EstimatedWaitTimeRef' not found.`
- `error G5FE39F1E: Type 'GetTicketByIdRef' not found.`
- `error G5FE39F1E: Type 'GetQueuePositionRef' not found.`
- `error G5FE39F1E: Type 'GetTicketsForTechnicianCategoriesRef' not found.`
- `error G76B49859: The non-abstract class 'QueueManagementState' is missing implementations for these members:`
- `error G3D8C6583: 'TicketRepositoryRef' isn't a type.`
- `error G9B1946AE: 'FilteredQueueTicketsRef' isn't a type.`
- `error GE1258F5E: 'QueueLengthRef' isn't a type.`
- `error GA58EE3F6: 'WaitingCustomersCountRef' isn't a type.`
- `error G03DE3ED8: 'NextTicketRef' isn't a type.`
- `error G848F5E30: 'PriorityTicketsRef' isn't a type.`
- `error GDD70FC02: 'WalkInTicketsRef' isn't a type.`
- `error G71660399: 'AppointmentTicketsRef' isn't a type.`
- `error G4E158692: 'TicketsByServiceCategoryRef' isn't a type.`
- `error G948F2F5B: 'HasUnassignedTicketsRef' isn't a type.`
- `error G6147077D: 'EstimatedWaitTimeRef' isn't a type.`
- `error G44B35B99: 'GetTicketByIdRef' isn't a type.`
- `error GD31BCE83: 'GetQueuePositionRef' isn't a type.`
- `error G16E05C61: 'GetTicketsForTechnicianCategoriesRef' isn't a type.`

#### `lib/features/dashboard/providers/ticket_assignment_provider.dart`
- `error G76B49859: The non-abstract class 'TicketAssignmentState' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'AssignmentResult' is missing implementations for these members:`
- `error GE5CFE876: The method 'updateTechnicianStatus' isn't defined for the class 'EmployeeStatus'.`

#### `lib/features/employees/presentation/screens/employees_screen.dart`
- `error GFAA2A68C: Error when reading 'lib/features/employees/widgets/employee_grid_card.dart': The system cannot find the path specified.`
- `error GFAA2A68C: Error when reading 'lib/features/employees/widgets/employee_details_dialog.dart': The system cannot find the path specified.`
- `error G4127D1E8: The getter 'employeeStatusFilterProvider' isn't defined for the class 'EmployeesScreen'.`
- `error GE5CFE876: The method 'EmployeeGridCard' isn't defined for the class 'EmployeesScreen'.`
- `error GE5CFE876: The method 'EmployeeDetailsDialog' isn't defined for the class 'EmployeesScreen'.` (2 occurrences)

#### `lib/features/employees/providers/employees_provider.dart`
- `error GE5CFE876: The method 'getAllEmployees' isn't defined for the class 'DriftEmployeeRepository'.`
- `error GE5CFE876: The method 'updateEmployeeStatus' isn't defined for the class 'DriftEmployeeRepository'.`
- `error GC6690633: No named parameter with the name 'hireDate'.`
- `error G4127D1E8: The getter 'timeEntryRepositoryProvider' isn't defined for the class 'ClockInOrder'.`

#### `lib/features/reports/data/models/report_data.dart`
- `error G76B49859: The non-abstract class 'DailyRevenue' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'ServiceRevenue' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'ServiceMetrics' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'ServiceTrend' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'TechnicianMetrics' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'TechnicianRevenue' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'CustomerSegment' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'CustomerRetention' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'HourlyBooking' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'AppointmentType' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'PaymentTrend' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'TrendPoint' is missing implementations for these members:`

#### `lib/features/reports/presentation/screens/business_overview_screen.dart`
- `error GFAA2A68C: Error when reading 'lib/features/reports/data/reports_store.dart': The system cannot find the file specified.`
- `error G5FE39F1E: Type 'ReportsStore' not found.`
- `error G8215D8CA: 'ReportsStore' isn't a type.` (2 occurrences)
- `error GE5CFE876: The method 'Observer' isn't defined for the class 'BusinessOverviewScreen'.` (4 occurrences)

#### `lib/features/reports/presentation/screens/reports_screen.dart`
- `error GFAA2A68C: Error when reading 'lib/features/reports/data/reports_store.dart': The system cannot find the file specified.`
- `error G5FE39F1E: Type 'ReportsStore' not found.`
- `error G8215D8CA: 'ReportsStore' isn't a type.`
- `error GE5CFE876: The method 'ReportsStore' isn't defined for the class '_ReportsScreenState'.`
- `error GE5CFE876: The method 'CacheCoordinationService' isn't defined for the class '_ReportsScreenState'.`
- `error GE5CFE876: The method 'Observer' isn't defined for the class '_ReportsScreenState'.` (5 occurrences)

#### `lib/features/reports/presentation/screens/sales_reports_screen.dart`
- `error GFAA2A68C: Error when reading 'lib/features/reports/data/reports_store.dart': The system cannot find the file specified.`
- `error G5FE39F1E: Type 'ReportsStore' not found.` (8 occurrences)
- `error G8215D8CA: 'ReportsStore' isn't a type.` (6 occurrences)

#### `lib/features/services/presentation/screens/services_screen.dart`
- `error GFAA2A68C: Error when reading 'lib/features/core/database/drift_database.dart': The system cannot find the path specified.`
- `error G5FE39F1E: Type 'db.ServiceCategory' not found.` (4 occurrences)
- `error GC2F972A8: The argument type 'String?' can't be assigned to the parameter type 'String' because 'String?' is nullable and 'String' isn't.` (2 occurrences)
- `error G4127D1E8: The getter 'asData' isn't defined for the class 'Map<int, List<Service>>'.`
- `error G311314CC: Method not found: 'ServiceCategory'.`
- `error G4127D1E8: The getter 'isLoading' isn't defined for the class 'Map<int, List<Service>>'.`
- `error G4127D1E8: The getter 'hasError' isn't defined for the class 'Map<int, List<Service>>'.`
- `error G4127D1E8: The getter 'value' isn't defined for the class 'Map<int, List<Service>>'.`
- `error G9D0681AD: 'ServiceCategory' isn't a type.` (4 occurrences)
- `error GC6690633: No named parameter with the name 'price'.` (2 occurrences)
- `error GC2F972A8: The argument type 'Service?' can't be assigned to the parameter type 'ServiceDomain?'.`
- `error GC2F972A8: The argument type 'List<ServiceCategory>' can't be assigned to the parameter type 'List<ServiceCategoryWithCount>'.` (2 occurrences)
- `error GC2F972A8: The argument type 'String' can't be assigned to the parameter type 'int'.`
- `error G4127D1E8: The getter 'value' isn't defined for the class 'String'.`

#### `lib/features/services/providers/services_provider.dart`
- `error GE5CFE876: The method 'getAllServices' isn't defined for the class 'DriftServiceRepository'.`
- `error GE5CFE876: The method 'insertService' isn't defined for the class 'DriftServiceRepository'.`
- `error GC2F972A8: The argument type 'int' can't be assigned to the parameter type 'String'.`
- `error GE5CFE876: The method 'insertServiceCategory' isn't defined for the class 'DriftServiceRepository'.`
- `error GE5CFE876: The method 'updateServiceCategory' isn't defined for the class 'DriftServiceRepository'.`
- `error GE5CFE876: The method 'deleteServiceCategory' isn't defined for the class 'DriftServiceRepository'.`

#### `lib/features/settings/presentation/screens/settings_screen.dart`
- `error GFAA2A68C: Error when reading 'lib/features/settings/data/settings_store.dart': The system cannot find the file specified.`
- `error G5FE39F1E: Type 'SettingsStore' not found.`
- `error G4A624820: 'SettingsStore' isn't a type.`
- `error GE5CFE876: The method 'SettingsStore' isn't defined for the class '_SettingsScreenState'.`
- `error GE5CFE876: The method 'Observer' isn't defined for the class '_SettingsScreenState'.` (7 occurrences)
- `error G4127D1E8: The getter 'BackgroundType' isn't defined for the class '_SettingsScreenState'.` (6 occurrences)

#### `lib/features/settings/providers/settings_provider.dart`
- `error G76B49859: The non-abstract class 'DashboardSettings' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'StoreSettings' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'GeneralSettings' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'SalonSettings' is missing implementations for these members:`
- `error GE5CFE876: The method 'updateSetting' isn't defined for the class 'DriftSettingsRepository'.`
- `error GE5CFE876: The method 'resetToDefaults' isn't defined for the class 'DriftSettingsRepository'.`

#### `lib/features/shared/data/models/appointment_model.dart`
- `error G76B49859: The non-abstract class 'Appointment' is missing implementations for these members:`

#### `lib/features/shared/data/models/customer_model.dart`
- `error G76B49859: The non-abstract class 'Customer' is missing implementations for these members:`

#### `lib/features/shared/data/models/employee_model.dart`
- `error G76B49859: The non-abstract class 'Employee' is missing implementations for these members:`

#### `lib/features/shared/data/models/payment_model.dart`
- `error G76B49859: The non-abstract class 'Payment' is missing implementations for these members:`

#### `lib/features/shared/data/models/setting_model.dart`
- `error G76B49859: The non-abstract class 'StoreSetting' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'StoreHours' is missing implementations for these members:`
- `error G76B49859: The non-abstract class 'DayHours' is missing implementations for these members:`

#### `lib/features/shared/data/models/time_entry_model.dart`
- `error G76B49859: The non-abstract class 'TimeEntry' is missing implementations for these members:`

#### `lib/features/shared/data/repositories/drift_employee_repository.dart`
- `error G5FE39F1E: Type 'db.EmployeeDao' not found.`
- `error GE64A6C4E: 'EmployeeDao' isn't a type.`
- `error G4127D1E8: The getter '_database' isn't defined for the class 'DriftEmployeeRepository'.` (26 occurrences)
- `error GC6690633: No named parameter with the name 'commissionRate'.` (2 occurrences)
- `error GC6690633: No named parameter with the name 'id'.`
- `error G4127D1E8: The getter 'isNotEmpty' isn't defined for the class 'DateTime'.` (2 occurrences)
- `error GC2F972A8: The argument type 'DateTime' can't be assigned to the parameter type 'String'.` (2 occurrences)
- `error G4127D1E8: The getter 'categoryName' isn't defined for the class 'EmployeeServiceCategory'.` (3 occurrences)
- `error G4127D1E8: The getter 'commissionRate' isn't defined for the class 'Employee'.`
- `error GC2F972A8: The argument type 'String' can't be assigned to the parameter type 'DateTime'.` (2 occurrences)

#### `lib/features/shared/data/repositories/drift_payment_repository.dart`
- `error GC6690633: No named parameter with the name 'taxAmount'.`
- `error G4127D1E8: The getter 'taxAmount' isn't defined for the class 'Payment'.`
- `error G4127D1E8: The getter 'discountAmount' isn't defined for the class 'Payment'.`
- `error G4127D1E8: The getter 'totalAmount' isn't defined for the class 'Payment'.`
- `error G4127D1E8: The getter 'discountType' isn't defined for the class 'Payment'.`
- `error G4127D1E8: The getter 'discountCode' isn't defined for the class 'Payment'.`
- `error G4127D1E8: The getter 'discountReason' isn't defined for the class 'Payment'.`
- `error G4127D1E8: The getter 'lastFourDigits' isn't defined for the class 'Payment'.`
- `error G4127D1E8: The getter 'authorizationCode' isn't defined for the class 'Payment'.`
- `error G4127D1E8: The getter 'processedAt' isn't defined for the class 'Payment'.`
- `error G4127D1E8: The getter 'processedBy' isn't defined for the class 'Payment'.`
- `error G4127D1E8: The getter 'notes' isn't defined for the class 'Payment'.`

#### `lib/features/shared/presentation/widgets/customer_search_widget.dart`
- `error GC6690633: No named parameter with the name 'onSave'.`

#### `lib/features/tickets/presentation/screens/tickets_screen.dart`
- `error GFAA2A68C: Error when reading 'lib/debug_database_tickets.dart': The system cannot find the file specified.`
- `error G4127D1E8: The getter 'DatabaseTicketsDebugger' isn't defined for the class '_TicketsScreenState'.`
- `error GC2F972A8: The argument type 'void Function(RangeValues?, dynamic)' can't be assigned to the parameter type 'void Function(RangeValues?)'.`

#### `lib/features/tickets/providers/ticket_details_provider.dart`
- `error G4127D1E8: The getter 'notes' isn't defined for the class 'Ticket'.`
- `error GC6690633: No named parameter with the name 'notes'.` (2 occurrences)

#### `lib/features/tickets/providers/tickets_efficient_provider.dart`
- `error GE5CFE876: The method 'call' isn't defined for the class 'DriftTicketRepository'.`
- `error GE5CFE876: The method 'getActiveTickets' isn't defined for the class 'DriftTicketRepository'.`
- `error GE5CFE876: The method 'updateTicketStatus' isn't defined for the class 'DriftTicketRepository'.`
- `error GE5CFE876: The method 'getTicketCount' isn't defined for the class 'DriftTicketRepository'.`
- `error GC6690633: No named parameter with the name 'search'.`
- `error GE5CFE876: The method 'getTicketsByDateRange' isn't defined for the class 'DriftTicketRepository'.`
