# Checkout Implementation Analysis

*Created: January 2025*

## Overview

This document provides a comprehensive analysis of the checkout interface functionality observed in the web version at `http://localhost:3008/#/checkout`. This analysis serves as the specification for implementing the checkout dialog in the Flutter POS application.

## Current State

### Flutter Implementation
- **Location**: `lib/features/checkout/presentation/screens/checkout_screen.dart`
- **Status**: Placeholder implementation with TODO comments
- **Current Behavior**: Shows SnackBar messages instead of actual checkout dialog

### Web Implementation  
- **Status**: Fully functional checkout interface
- **URL**: `http://localhost:3008/#/checkout`
- **Features**: Complete payment processing, ticket selection, tips, discounts, multiple payment methods

## Web Checkout Interface Analysis

### 1. Main Checkout Screen

**Layout**: Two-column layout with left sidebar and main content area

**Left Sidebar** (approximately 30% width):
- Header: "Checkout" title with shopping cart icon
- Quick Sale tab/button (switches to standalone mode)
- Selected tickets summary card showing:
  - Number of tickets selected
  - Total amount preview
  - "Clear Selection" option

**Main Content Area** (approximately 70% width):
- **Ticket Grid**: 2-3 column responsive grid of ticket cards
- **Each Ticket Card**:
  - White background with subtle border
  - Top section: Ticket number (large, bold) + status badge
  - Customer name (medium text, secondary color)
  - Services list (compact, bulleted or comma-separated)
  - Price (large, primary color, right-aligned)
  - Checkbox (bottom-right corner)
  - "Modify" button (small, secondary style)

**Bottom Bar**:
- Sticky footer with order summary
- Left side: "X tickets selected" count
- Center: Subtotal breakdown (Subtotal: $X.XX, Tax: $X.XX)
- Right side: Large "Proceed to Payment" button (primary color, disabled when no selection)

**Responsive Behavior**:
- Desktop: Two-column layout as described
- Tablet: Sidebar collapses to top bar
- Mobile: Single column, sticky summary moves to bottom sheet

### 2. Payment Dialog

**Trigger**: Clicking "Proceed to Payment" with selected tickets

**Layout**: Full-screen modal overlay (not a small dialog) with comprehensive payment interface

**Header Section**:
- "Payment Processing" title with close (X) button
- Selected tickets summary (collapsible list)

**Main Content Layout**: Three-column layout on desktop, single column on mobile

#### 2.1 Left Column: Services & Items (33% width)
- **Header**: "Order Details" with ticket count
- **Services List**: 
  - Grouped by ticket if multiple tickets selected
  - Each service shows: name, duration, price
  - Ticket headers with ticket number and customer name
  - Scrollable if many services
- **Visual Style**: Clean list with alternating background colors

#### 2.2 Center Column: Adjustments (33% width)
**Tip Section**:
- **Header**: "Add Tip" with tip calculator icon
- **Tip Buttons**: 4 buttons in 2x2 grid
  - "15%" "18%" on top row
  - "20%" "Other" on bottom row
- **Custom Tip**: Number input field (appears when "Other" selected)
- **Tip Display**: Shows calculated amount in real-time

**Discount Section**:
- **Header**: "Apply Discount" with discount icon
- **Discount Button**: Opens discount form modal
- **Applied Discount Display**: Shows when discount active
  - Discount reason
  - Discount amount
  - "Remove" button

#### 2.3 Right Column: Payment & Totals (33% width)
**Order Summary**:
- **Breakdown Section** (top):
  ```
  Subtotal:     $25.00
  Tip (18%):    +$4.50
  Discount:     -$2.50
  Tax (8.75%):  +$2.36
  ─────────────────────
  Total:        $29.36
  ```

**Payment Methods** (middle):
- Three large buttons stacked vertically:
  - "Cash" (with cash icon)
  - "Card" (with card icon) 
  - "Other" (with generic payment icon)
- Selected method highlighted with primary color

**Action Buttons** (bottom):
- "Cancel" button (secondary style, left)
- "Process Payment" button (primary style, right, full width when payment method selected)

#### 2.4 Discount Form Modal
**Layout**: Smaller modal over the payment dialog
- **Header**: "Apply Discount"
- **Form Fields** (stacked vertically):
  - Discount reason (text input, full width)
  - Discount type (radio buttons: Percentage / Fixed Amount)
  - Discount value (number input with % or $ symbol)
  - Technician PIN (4-digit password input)
- **Buttons**: "Cancel" and "Apply Discount"

#### 2.5 Visual Design Notes
- **Color Scheme**: Light backgrounds, primary blue accents
- **Typography**: Clear hierarchy with large totals, medium headers, small details
- **Spacing**: Generous padding between sections
- **Interactive Elements**: Hover states, disabled states for incomplete forms
- **Real-time Updates**: All calculations update immediately when values change

### 3. Quick Sale Interface

**Access**: "Quick Sale" tab/button in left sidebar (replaces ticket selection)

**Layout**: Replaces main content area when activated

**Visual Transition**: 
- Left sidebar updates to show "Quick Sale" as active tab
- Main content area slides/fades to show service selection grid
- Bottom bar updates to show "Add to Cart" instead of "Proceed to Payment"

**Service Selection Grid**:
- **Layout**: 3-4 column grid of service/product cards
- **Each Card**: 
  - Square aspect ratio with service image/icon
  - Service name (bold, center-aligned)
  - Price (large, primary color)
  - Category badge (small, top-right corner)
  - Quick-add "+" button (bottom-right)

**Categories Filter Bar**:
- Horizontal scrollable tabs above the grid
- "All", "Services", "Products", "Gift Cards"
- Active category highlighted

**Selected Items Panel** (replaces left sidebar content):
- **Header**: "Cart" with item count
- **Item List**: Selected services/products with:
  - Item name and price
  - Quantity controls (+/- buttons)
  - Technician dropdown (services only)
  - Remove button
- **Customer Selection**: Optional dropdown for customer association

**Bottom Action Bar**:
- Left: "Clear Cart" button
- Center: Running total display
- Right: "Proceed to Payment" button (enabled when valid items selected)

**Visual States**:
- **Empty State**: Large icon with "Select services to get started" message
- **Validation State**: Services without technicians highlighted in red
- **Ready State**: All requirements met, proceed button active

## Flutter Layout Implementation

### 1. Main Checkout Screen Widget Structure

```dart
class CheckoutDialog extends StatefulWidget {
  // Factory constructors as previously defined
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        body: Row(
          children: [
            // Left Sidebar (30% width)
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: _buildLeftSidebar(),
            ),
            // Main Content Area (70% width)
            Expanded(
              child: _buildMainContent(),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildLeftSidebar() {
    return Container(
      color: Colors.grey[50],
      child: Column(
        children: [
          _buildSidebarHeader(),
          _buildModeToggle(), // Tickets vs Quick Sale
          Expanded(
            child: widget.isQuickSale 
              ? _buildQuickSaleCart()
              : _buildSelectedTicketsSummary(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return widget.isQuickSale 
      ? _buildQuickSaleGrid()
      : _buildTicketsGrid();
  }
}
```

### 2. Payment Dialog Widget Structure

```dart
class PaymentDialog extends StatefulWidget {
  final CheckoutState checkoutState;
  final Function(PaymentResult) onPaymentComplete;
}

class _PaymentDialogState extends State<PaymentDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Payment Processing'),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 900) {
              return _buildDesktopLayout();
            } else {
              return _buildMobileLayout();
            }
          },
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Services & Items (33%)
        Expanded(
          flex: 1,
          child: _buildServicesColumn(),
        ),
        // Center Column: Adjustments (33%)
        Expanded(
          flex: 1,
          child: _buildAdjustmentsColumn(),
        ),
        // Right Column: Payment & Totals (33%)
        Expanded(
          flex: 1,
          child: _buildPaymentColumn(),
        ),
      ],
    );
  }

  Widget _buildServicesColumn() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Details',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 16),
          Expanded(
            child: _buildServicesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustmentsColumn() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(right: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          _buildTipSection(),
          SizedBox(height: 24),
          _buildDiscountSection(),
        ],
      ),
    );
  }

  Widget _buildTipSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calculate, color: AppColors.primaryBlue),
                SizedBox(width: 8),
                Text('Add Tip', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 16),
            // 2x2 grid of tip buttons
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.5,
              children: [
                _buildTipButton('15%', 0.15),
                _buildTipButton('18%', 0.18),
                _buildTipButton('20%', 0.20),
                _buildTipButton('Other', null),
              ],
            ),
            if (_showCustomTipInput) 
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Custom tip amount',
                    prefixText: '\$',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: _updateCustomTip,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

### 3. Responsive Design Breakpoints

```dart
class CheckoutLayoutConstants {
  static const double desktopBreakpoint = 900;
  static const double tabletBreakpoint = 600;
  
  // Layout proportions
  static const double sidebarWidthRatio = 0.3;
  static const double paymentColumnRatio = 0.33;
  
  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  // Card dimensions
  static const double ticketCardHeight = 120.0;
  static const double serviceCardAspectRatio = 1.2;
}

Widget _buildResponsiveLayout(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  
  if (screenWidth > CheckoutLayoutConstants.desktopBreakpoint) {
    return _buildDesktopLayout();
  } else if (screenWidth > CheckoutLayoutConstants.tabletBreakpoint) {
    return _buildTabletLayout();
  } else {
    return _buildMobileLayout();
  }
}
```

## Implementation Requirements

### 1. Core Dialog Structure

```dart
class CheckoutDialog extends StatefulWidget {
  final List<Ticket>? selectedTickets; // Nullable for Quick Sale mode
  final bool isQuickSale;
  final Function(PaymentResult) onPaymentComplete;
  
  const CheckoutDialog({
    this.selectedTickets,
    this.isQuickSale = false,
    required this.onPaymentComplete,
  });
  
  // Factory constructors for different modes
  factory CheckoutDialog.fromTickets({
    required List<Ticket> tickets,
    required Function(PaymentResult) onPaymentComplete,
  }) => CheckoutDialog(
    selectedTickets: tickets,
    isQuickSale: false,
    onPaymentComplete: onPaymentComplete,
  );
  
  factory CheckoutDialog.quickSale({
    required Function(PaymentResult) onPaymentComplete,
  }) => CheckoutDialog(
    selectedTickets: null,
    isQuickSale: true,
    onPaymentComplete: onPaymentComplete,
  );
}
```

### 2. State Management

**Required State Variables**:
- Selected tickets list (null for Quick Sale)
- Quick Sale items with technician assignments
- Modified tickets tracking (for add-ons/services)
- Subtotal, tax, tip, discount amounts
- Payment method selection
- Tip percentage/amount
- Discount form data
- Payment processing status
- Available technicians list
- Customer selection (optional for Quick Sale)
- Available services for modification/quick sale

### 3. UI Components Needed

#### 3.1 Mode Selection & Item Display
**Ticket Mode**:
- Checkbox list of available tickets
- Ticket summary cards with "Modify" button
- Real-time total calculation
- Add services/add-ons functionality

**Quick Sale Mode**:
- Service/product/gift card selection grid
- Technician assignment dropdown for services only
- Products and gift cards without technician assignment
- Customer selection (optional)
- Add/remove items functionality

**Ticket Modification**:
```dart
Widget _buildTicketCard(Ticket ticket) {
  return Card(
    child: Column(
      children: [
        // Existing ticket display
        Text('Ticket #${ticket.ticketNumber}'),
        Text(ticket.customer.name),
        Text('\$${ticket.totalAmount?.toStringAsFixed(2)}'),
        
        // Services list with add option
        ...ticket.services.map((service) => 
          ListTile(
            title: Text(service.name),
            subtitle: Text('\$${service.price.toStringAsFixed(2)}'),
          )
        ).toList(),
        
        // Modify ticket button
        TextButton.icon(
          icon: Icon(Icons.add),
          label: Text('Add Services'),
          onPressed: () => _showTicketModificationDialog(ticket),
        ),
        
        // Checkout checkbox
        Checkbox(
          value: _selectedTickets.contains(ticket.id),
          onChanged: (selected) => _toggleTicketSelection(ticket.id),
        ),
      ],
    ),
  );
}

void _showTicketModificationDialog(Ticket ticket) {
  showDialog(
    context: context,
    builder: (context) => TicketDetailsDialog(
      ticket: ticket,
      mode: TicketDialogMode.modify,
      onTicketUpdated: (updatedTicket) {
        _refreshTicketDisplay(updatedTicket);
        Navigator.of(context).pop();
      },
    ),
  );
}
```

```dart
Widget _buildQuickSaleItem(QuickSaleItem item) {
  return Card(
    child: Column(
      children: [
        Text(item.serviceName),
        Text('\$${item.price.toStringAsFixed(2)}'),
        
        // Only show technician assignment for services
        if (item.type == ServiceType.service)
          DropdownButton<String>(
            value: item.assignedTechnicianId,
            hint: Text('Assign Technician'),
            items: availableTechnicians.map((tech) =>
              DropdownMenuItem(
                value: tech.id,
                child: Text(tech.name),
              ),
            ).toList(),
            onChanged: (techId) => _assignTechnician(item.id, techId),
          )
        else
          // Products and gift cards don't need technician assignment
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
              item.type == ServiceType.product ? 'Product Sale' : 'Gift Card',
              style: TextStyle(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () => _removeQuickSaleItem(item.id),
        ),
      ],
    ),
  );
}
```

#### 3.2 Payment Summary Section
```dart
Widget _buildPaymentSummary() {
  return Column(
    children: [
      _buildLineItem('Subtotal', subtotal),
      if (tipAmount > 0) _buildLineItem('Tip', tipAmount),
      if (discountAmount > 0) _buildLineItem('Discount', -discountAmount),
      _buildLineItem('Tax (8.75%)', taxAmount),
      Divider(),
      _buildLineItem('Total', totalAmount, isTotal: true),
    ],
  );
}
```

#### 3.3 Tip Selection Interface
```dart
Widget _buildTipSelection() {
  return Row(
    children: [
      _buildTipButton('15%', 0.15),
      _buildTipButton('18%', 0.18),
      _buildTipButton('20%', 0.20),
      _buildCustomTipButton(),
    ],
  );
}
```

#### 3.4 Discount Form
```dart
class DiscountForm extends StatefulWidget {
  final Function(DiscountData) onDiscountApplied;
}

class DiscountData {
  final String reason;
  final DiscountType type; // percentage or fixed
  final double value;
  final String technicianPin;
}
```

#### 3.5 Payment Method Selection
```dart
enum PaymentMethod { cash, card, other }

Widget _buildPaymentMethods() {
  return Column(
    children: [
      _buildPaymentMethodButton(PaymentMethod.cash, 'Cash'),
      _buildPaymentMethodButton(PaymentMethod.card, 'Card'),
      _buildPaymentMethodButton(PaymentMethod.other, 'Other'),
    ],
  );
}
```

### 4. Business Logic Requirements

#### 4.1 Tax Calculation
- **Rate**: 8.75% (configurable)
- **Applied To**: Subtotal + tip - discount
- **Formula**: `(subtotal + tip - discount) * 0.0875`

#### 4.2 Tip Calculation
- **Base Amount**: Subtotal only (before tax and discount)
- **Percentage Tips**: Standard rates (15%, 18%, 20%)
- **Custom Tips**: User-defined amount or percentage

#### 4.3 Discount Authorization
- **Security**: Technician PIN required
- **Types**: Percentage or fixed amount
- **Validation**: PIN verification against employee database
- **Audit**: Log discount applications with technician ID

#### 4.4 Payment Processing
- **Cash**: Simple amount entry and change calculation
- **Card**: Integration with payment processor
- **Other**: Flexible payment method handling

### 5. Data Models

#### 5.1 Quick Sale Item
```dart
class QuickSaleItem {
  final String id;
  final String serviceId;
  final String serviceName;
  final double price;
  final String? assignedTechnicianId;
  final ServiceType type; // service, product, giftCard
  
  const QuickSaleItem({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.price,
    this.assignedTechnicianId,
    required this.type,
  });
  
  QuickSaleItem copyWith({
    String? assignedTechnicianId,
  }) => QuickSaleItem(
    id: id,
    serviceId: serviceId,
    serviceName: serviceName,
    price: price,
    assignedTechnicianId: assignedTechnicianId ?? this.assignedTechnicianId,
    type: type,
  );
}

enum ServiceType { service, product, giftCard }
```

#### 5.2 Payment Result
```dart
class PaymentResult {
  final String paymentId;
  final List<String>? ticketIds; // Null for Quick Sale
  final List<QuickSaleItem>? quickSaleItems; // Null for Ticket mode
  final PaymentMethod method;
  final double subtotal;
  final double tipAmount;
  final double discountAmount;
  final double taxAmount;
  final double totalAmount;
  final DateTime processedAt;
  final String? technicianPin;
  final String? discountReason;
  final String? customerId; // Optional for Quick Sale
  final bool isQuickSale;
}
```

#### 5.3 Checkout State
```dart
class CheckoutState {
  final List<Ticket>? selectedTickets; // Null for Quick Sale
  final List<QuickSaleItem> quickSaleItems;
  final double tipPercentage;
  final double customTipAmount;
  final DiscountData? discount;
  final PaymentMethod? selectedPaymentMethod;
  final bool isProcessing;
  final String? errorMessage;
  final bool isQuickSale;
  final String? selectedCustomerId; // Optional for Quick Sale
  
  // Validation
  bool get allServicesAssigned {
    if (isQuickSale) {
      // Only services require technician assignment
      return quickSaleItems
        .where((item) => item.type == ServiceType.service)
        .every((item) => item.assignedTechnicianId?.isNotEmpty == true);
    }
    return true; // Tickets already have assignments
  }
}
```

### 6. Integration Points

#### 6.1 Existing Code Integration
- **Ticket Repository**: Update ticket status to 'paid', add services to tickets
- **Payment Repository**: Store payment records
- **Settings Service**: Tax rate configuration
- **Employee Repository**: PIN verification
- **Service Repository**: Load available services for modification/quick sale
- **TicketDetailsDialog**: Integrate for ticket modification within checkout flow

#### 6.2 Navigation Flow
```dart
// From dashboard ticket details (Ticket Mode)
void _showCheckoutDialog() {
  showDialog(
    context: context,
    builder: (context) => CheckoutDialog.fromTickets(
      tickets: [widget.ticket],
      onPaymentComplete: (result) {
        _updateTicketStatus(result);
        Navigator.of(context).pop();
      },
    ),
  );
}

// From checkout screen "Quick Sale" button
void _showQuickSaleDialog() {
  showDialog(
    context: context,
    builder: (context) => CheckoutDialog.quickSale(
      onPaymentComplete: (result) {
        _processQuickSalePayment(result);
        Navigator.of(context).pop();
      },
    ),
  );
}

// Quick Sale processing
void _processQuickSalePayment(PaymentResult result) {
  // Validate only services have technicians assigned
  final servicesWithoutTechnician = result.quickSaleItems
    ?.where((item) => 
      item.type == ServiceType.service && 
      item.assignedTechnicianId == null)
    .toList();
    
  if (servicesWithoutTechnician?.isNotEmpty == true) {
    _showError('All services must be assigned to a technician');
    return;
  }
  
  // Create commission records for services only
  for (final item in result.quickSaleItems ?? []) {
    if (item.type == ServiceType.service && item.assignedTechnicianId != null) {
      _createTechnicianCommission(
        technicianId: item.assignedTechnicianId!,
        serviceId: item.serviceId,
        amount: item.price,
        paymentId: result.paymentId,
      );
    }
    // Products and gift cards are recorded without technician commission
  }
  
  // Record payment
  _recordPayment(result);
}
```

### 7. File Structure

```
lib/features/checkout/
├── data/
│   ├── models/
│   │   ├── payment_result.dart
│   │   ├── discount_data.dart
│   │   ├── quick_sale_item.dart
│   │   └── checkout_state.dart
│   └── repositories/
│       └── payment_repository.dart
├── presentation/
│   ├── widgets/
│   │   ├── checkout_dialog.dart
│   │   ├── ticket_modification_section.dart
│   │   ├── quick_sale_section.dart
│   │   ├── payment_summary.dart
│   │   ├── tip_selection.dart
│   │   ├── discount_form.dart
│   │   └── payment_method_selector.dart
│   └── screens/
│       └── checkout_screen.dart (existing)
└── domain/
    └── services/
        └── checkout_service.dart
```

### 8. Implementation Priority

1. **Phase 1**: Basic checkout dialog with ticket selection and payment summary
2. **Phase 2**: Ticket modification integration (add services/add-ons via TicketDetailsDialog)
3. **Phase 3**: Tip functionality with percentage and custom options
4. **Phase 4**: Discount system with PIN authorization
5. **Phase 5**: Multiple payment methods
6. **Phase 6**: Quick sale integration with technician assignment requirements

### 9. Testing Requirements

- Unit tests for calculation logic
- Widget tests for UI components  
- Integration tests for payment flow
- Ticket modification workflow testing
- Quick sale technician assignment validation
- PIN validation testing
- Edge case handling (zero amounts, large tips, etc.)
- Service assignment validation for all transaction types

### 10. Configuration

**Settings to Add**:
- Tax rate (default: 8.75%)
- Default tip percentages
- PIN requirements for discounts
- Payment method availability

## Next Steps

1. Create the basic checkout dialog structure
2. Integrate ticket modification functionality (TicketDetailsDialog)
3. Implement payment calculations
4. Add technician assignment validation for Quick Sale
5. Add tip and discount functionality
6. Integrate with existing payment systems
7. Add comprehensive testing
8. Update related screens to use the new checkout dialog

## Key Business Rules

### Technician Assignment Requirements
- **Only services require technician assignment** - products and gift cards do not need technician assignment
- **Quick Sale invalidates ticket selection** - switching to Quick Sale clears any selected tickets
- **Ticket modification** - users can add services/add-ons to existing tickets via the checkout screen
- **Commission tracking** - service sales track technician commissions, products/gift cards do not

### Validation Rules
- Quick Sale cannot proceed without technician assignments for all services (products/gift cards exempt)
- Ticket modifications update the original ticket before payment processing
- All payment calculations include tax (8.75%) applied after discounts and tips

---

*This analysis is based on the web interface observed at http://localhost:3008/#/checkout and provides the foundation for implementing equivalent functionality in the Flutter application.*