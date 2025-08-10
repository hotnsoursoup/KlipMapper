// lib/core/auth/widgets/pin_management_example.dart
// Example widget demonstrating PIN management dialog functionality for testing and development purposes. Shows how to integrate PIN creation, validation, and management workflows.
// Usage: ORPHANED - Development/testing example not used in production app

import 'package:flutter/material.dart';
import 'pin_management_dialog.dart';

/// Example usage of PinManagementDialog for testing and demonstration
class PinManagementExample extends StatelessWidget {
  const PinManagementExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PIN Management Examples')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'PIN Management Dialog Examples',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            
            // Set New PIN
            ElevatedButton.icon(
              onPressed: () => _showSetNewPinDialog(context),
              icon: const Icon(Icons.lock_outline),
              label: const Text('Set New PIN'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),
            
            // Change Existing PIN
            ElevatedButton.icon(
              onPressed: () => _showChangePinDialog(context),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Change Existing PIN'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),
            
            // Manager Reset PIN
            ElevatedButton.icon(
              onPressed: () => _showManagerResetDialog(context),
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text('Manager Reset PIN'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            
            const SizedBox(height: 40),
            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text(
              '• Set New PIN - For employees who don\'t have a PIN yet\n'
              '• Change Existing PIN - Requires current PIN verification first\n'
              '• Manager Reset - Requires manager authentication to reset employee PIN\n'
              '• Default PIN for testing: 1234',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  void _showSetNewPinDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PinManagementDialog.setNew(
        employeeId: 999, // Test employee ID
        employeeName: 'Test Employee',
        onComplete: (success) {
          _showResultSnackBar(context, success, 'PIN setup');
        },
      ),
    );
  }

  void _showChangePinDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PinManagementDialog.changeExisting(
        employeeId: 1, // Existing employee with PIN
        employeeName: 'Jenny Lo',
        onComplete: (success) {
          _showResultSnackBar(context, success, 'PIN change');
        },
      ),
    );
  }

  void _showManagerResetDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PinManagementDialog.managerReset(
        employeeId: 2, // Employee to reset PIN for
        employeeName: 'Lynn Smith',
        managerEmployeeId: 1, // Manager doing the reset
        onComplete: (success) {
          _showResultSnackBar(context, success, 'PIN reset');
        },
      ),
    );
  }

  void _showResultSnackBar(BuildContext context, bool success, String operation) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success 
              ? '$operation completed successfully!' 
              : '$operation failed. Please try again.',
        ),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}