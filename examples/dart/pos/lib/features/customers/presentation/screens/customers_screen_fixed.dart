// lib/features/customers/presentation/screens/customers_screen_fixed.dart
// Simple customers screen using Riverpod with clean list display and async state handling. Shows customer name, phone, and email in a basic ListView with loading and error states.
// Usage: ACTIVE - Primary customers screen in the application using Riverpod architecture

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/presentation/widgets/standard_app_header.dart';
import '../../providers/customers_provider.dart';

class CustomersScreen extends ConsumerWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(customersMasterProvider);
    
    return Scaffold(
      appBar: StandardAppHeader(
        title: 'Customers',
      ),
      body: customersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (customers) => ListView.builder(
          itemCount: customers.length,
          itemBuilder: (context, index) {
            final customer = customers[index];
            return ListTile(
              title: Text(customer.fullName),
              subtitle: Text(customer.phone ?? ''),
              trailing: Text(customer.email ?? ''),
            );
          },
        ),
      ),
    );
  }
}