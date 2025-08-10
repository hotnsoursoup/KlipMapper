// lib/features/tickets/providers/ticket_details_provider.dart
// Pure Riverpod provider for ticket detail form state management following UI Bible patterns for dialog forms.
// Manages customer selection, service selection, technician assignment, and form validation without direct repository interaction.
// Usage: ACTIVE - Used by ticket detail dialogs and check-in forms for state management and form building

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/data/models/customer_model.dart';
import '../../shared/data/models/service_model.dart';
import '../../shared/data/models/technician_model.dart';
import '../../shared/data/models/ticket_model.dart';

part 'ticket_details_provider.g.dart';

/// Pure Riverpod implementation following the UI Bible patterns
/// This provider ONLY manages the dialog form state
/// It does NOT directly interact with other providers
@riverpod
class TicketDetails extends _$TicketDetails {
  /// The build method takes parameters to create a family provider
  /// Each unique combination of parameters gets its own state instance
  @override
  TicketDetailsState build({
    Ticket? ticket,
    Customer? customer,
    bool isNewCheckIn = false,
    List<Service> availableServices = const [],
    List<Technician> availableTechnicians = const [],
  }) {
    // Initialize state based on parameters
    return TicketDetailsState(
      ticket: ticket,
      selectedCustomer: customer ?? ticket?.customer,
      isNewCheckIn: isNewCheckIn,
      availableServices: availableServices,
      availableTechnicians: availableTechnicians,
      selectedServices: ticket?.services ?? [],
      selectedTechnicianId: ticket?.assignedTechnicianId,
      selectedTechnicianName: ticket?.requestedTechnicianName,
      customerConfirmed: customer != null || ticket?.customer != null,
      notes: ticket?.notes ?? '',
      isGroupService: ticket?.isGroupService ?? false,
      groupSize: ticket?.groupSize ?? 1,
    );
  }

  void selectCustomer(Customer customer) {
    state = state.copyWith(selectedCustomer: customer, customerConfirmed: true);
  }

  void confirmCustomer() {
    if (state.selectedCustomer != null) {
      state = state.copyWith(customerConfirmed: true);
    }
  }

  void editCustomer() {
    state = state.copyWith(customerConfirmed: false);
  }

  void toggleService(Service service) {
    final services = List<Service>.from(state.selectedServices);
    final index = services.indexWhere((s) => s.id == service.id);

    if (index >= 0) {
      services.removeAt(index);
    } else {
      services.add(service);
    }

    state = state.copyWith(selectedServices: services);
  }

  void selectTechnician(String? technicianId, String? technicianName) {
    state = state.copyWith(
      selectedTechnicianId: technicianId,
      selectedTechnicianName: technicianName,
    );
  }

  void updateNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  void toggleGroupService(bool isGroup) {
    state = state.copyWith(isGroupService: isGroup, groupSize: isGroup ? 2 : 1);
  }

  void updateGroupSize(int size) {
    state = state.copyWith(groupSize: size);
  }

  /// Builds a ticket from the current form state
  /// This is a pure function that returns the ticket based on state
  /// The UI will pass this to the appropriate provider for saving
  Ticket buildTicket() {
    final now = DateTime.now();
    final customer = state.selectedCustomer;

    if (customer == null) {
      throw Exception('Customer is required');
    }

    if (state.ticket != null) {
      // Update existing ticket
      return state.ticket!.copyWith(
        customer: customer,
        services: state.selectedServices,
        assignedTechnicianId: state.selectedTechnicianId,
        requestedTechnicianName: state.selectedTechnicianName,
        isGroupService: state.isGroupService,
        groupSize: state.groupSize,
      );
    } else {
      // Create new ticket
      return Ticket(
        id: now.millisecondsSinceEpoch.toString(),
        ticketNumber: '1001', // Will be overridden by the queue provider
        customer: customer,
        services: state.selectedServices,
        type: state.isNewCheckIn ? 'walk-in' : 'appointment',
        status: 'queued',
        checkInTime: now,
        assignedTechnicianId: state.selectedTechnicianId,
        requestedTechnicianName: state.selectedTechnicianName,
        isGroupService: state.isGroupService,
        groupSize: state.groupSize,
      );
    }
  }

  /// Validation method to check if the form is ready to save
  bool canSave() {
    return state.selectedCustomer != null &&
        state.customerConfirmed &&
        state.selectedServices.isNotEmpty;
  }
}

class TicketDetailsState {
  final Ticket? ticket;
  final Customer? selectedCustomer;
  final bool isNewCheckIn;
  final List<Service> availableServices;
  final List<Technician> availableTechnicians;
  final List<Service> selectedServices;
  final String? selectedTechnicianId;
  final String? selectedTechnicianName;
  final bool customerConfirmed;
  final String notes;
  final bool isGroupService;
  final int groupSize;

  TicketDetailsState({
    this.ticket,
    this.selectedCustomer,
    this.isNewCheckIn = false,
    this.availableServices = const [],
    this.availableTechnicians = const [],
    this.selectedServices = const [],
    this.selectedTechnicianId,
    this.selectedTechnicianName,
    this.customerConfirmed = false,
    this.notes = '',
    this.isGroupService = false,
    this.groupSize = 1,
  });

  TicketDetailsState copyWith({
    Ticket? ticket,
    Customer? selectedCustomer,
    bool? isNewCheckIn,
    List<Service>? availableServices,
    List<Technician>? availableTechnicians,
    List<Service>? selectedServices,
    String? selectedTechnicianId,
    String? selectedTechnicianName,
    bool? customerConfirmed,
    String? notes,
    bool? isGroupService,
    int? groupSize,
  }) {
    return TicketDetailsState(
      ticket: ticket ?? this.ticket,
      selectedCustomer: selectedCustomer ?? this.selectedCustomer,
      isNewCheckIn: isNewCheckIn ?? this.isNewCheckIn,
      availableServices: availableServices ?? this.availableServices,
      availableTechnicians: availableTechnicians ?? this.availableTechnicians,
      selectedServices: selectedServices ?? this.selectedServices,
      selectedTechnicianId: selectedTechnicianId ?? this.selectedTechnicianId,
      selectedTechnicianName:
          selectedTechnicianName ?? this.selectedTechnicianName,
      customerConfirmed: customerConfirmed ?? this.customerConfirmed,
      notes: notes ?? this.notes,
      isGroupService: isGroupService ?? this.isGroupService,
      groupSize: groupSize ?? this.groupSize,
    );
  }
}
