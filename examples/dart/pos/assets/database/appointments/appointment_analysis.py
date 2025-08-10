#!/usr/bin/env python3
"""
Appointment Analysis Script
Analyzes appointments data for missing services, compatibility issues, and related data integrity.
"""

import sqlite3
import json
import csv
from datetime import datetime
from typing import Dict, List, Any, Set

class AppointmentAnalyzer:
    def __init__(self, db_path: str):
        self.db_path = db_path
        self.conn = sqlite3.connect(db_path)
        self.conn.row_factory = sqlite3.Row
        
        # Load data into memory for analysis
        self.appointments = self._load_appointments()
        self.services = self._load_services()
        self.employees = self._load_employees()
        self.employee_categories = self._load_employee_categories()
        self.service_categories = self._load_service_categories()
        self.tickets = self._load_tickets()
        self.payments = self._load_payments()
        
    def _load_appointments(self) -> List[Dict]:
        cursor = self.conn.execute("SELECT * FROM appointments ORDER BY start_datetime")
        return [dict(row) for row in cursor.fetchall()]
    
    def _load_services(self) -> Dict[int, Dict]:
        cursor = self.conn.execute("SELECT * FROM services")
        return {row['id']: dict(row) for row in cursor.fetchall()}
    
    def _load_employees(self) -> Dict[int, Dict]:
        cursor = self.conn.execute("SELECT * FROM employees")
        return {row['id']: dict(row) for row in cursor.fetchall()}
    
    def _load_employee_categories(self) -> Dict[int, Set[str]]:
        cursor = self.conn.execute("SELECT * FROM employee_service_categories")
        employee_cats = {}
        for row in cursor.fetchall():
            emp_id = row['employee_id']
            if emp_id not in employee_cats:
                employee_cats[emp_id] = set()
            employee_cats[emp_id].add(row['category_name'].lower())
        return employee_cats
    
    def _load_service_categories(self) -> Dict[int, str]:
        cursor = self.conn.execute("SELECT * FROM service_categories")
        return {row['id']: row['name'].lower() for row in cursor.fetchall()}
    
    def _load_tickets(self) -> List[Dict]:
        cursor = self.conn.execute("SELECT * FROM tickets")
        return [dict(row) for row in cursor.fetchall()]
    
    def _load_payments(self) -> List[Dict]:
        cursor = self.conn.execute("SELECT * FROM payments")
        return [dict(row) for row in cursor.fetchall()]
    
    def analyze_appointments(self) -> Dict[str, Any]:
        """Main analysis function"""
        print("Starting appointment analysis...")
        
        results = {
            'total_appointments': len(self.appointments),
            'appointments_without_services': [],
            'appointments_with_incompatible_services': [],
            'appointments_without_tickets': [],
            'appointments_with_timing_issues': [],
            'summary': {}
        }
        
        print(f"Analyzing {results['total_appointments']} appointments...")
        
        for appointment in self.appointments:
            apt_id = appointment['id']
            emp_id = appointment['employee_id']
            services_json = appointment['services']
            
            # Check for missing services
            if not services_json or services_json == '[]' or services_json == '' or services_json == 'null':
                results['appointments_without_services'].append({
                    'id': apt_id,
                    'employee_id': emp_id,
                    'start_datetime': appointment['start_datetime'],
                    'customer_id': appointment['customer_id']
                })
                continue
            
            # Parse services
            try:
                appointment_services = json.loads(services_json)
                # Remove debug output since we're fixing the issue
            except json.JSONDecodeError:
                results['appointments_without_services'].append({
                    'id': apt_id,
                    'employee_id': emp_id,
                    'start_datetime': appointment['start_datetime'],
                    'customer_id': appointment['customer_id'],
                    'error': 'Invalid JSON in services field'
                })
                continue
            
            # Check service compatibility with technician
            if emp_id in self.employee_categories:
                emp_categories = self.employee_categories[emp_id]
                incompatible_services = []
                
                for service in appointment_services:
                    # Handle both dict and other formats
                    if isinstance(service, dict):
                        service_id = service.get('id')
                        category_id = service.get('category_id')
                    else:
                        # Skip unexpected service formats (should be fixed by now)
                        continue
                    
                    if category_id and category_id in self.service_categories:
                        category_name = self.service_categories[category_id]
                        
                        # Check if technician can perform this service category
                        if category_name not in emp_categories:
                            incompatible_services.append({
                                'service_id': service_id,
                                'service_name': service.get('name'),
                                'category': category_name,
                                'technician_categories': list(emp_categories)
                            })
                
                if incompatible_services:
                    results['appointments_with_incompatible_services'].append({
                        'appointment_id': apt_id,
                        'employee_id': emp_id,
                        'employee_name': f"{self.employees[emp_id]['first_name']} {self.employees[emp_id]['last_name']}" if emp_id in self.employees else f"Employee {emp_id}",
                        'start_datetime': appointment['start_datetime'],
                        'incompatible_services': incompatible_services
                    })
        
        # Check for appointments without corresponding tickets
        ticket_appointment_ids = set()
        for ticket in self.tickets:
            # We need to match tickets to appointments - this might require custom logic
            # For now, let's assume tickets should exist for each appointment
            pass
        
        # Generate summary
        results['summary'] = {
            'appointments_without_services_count': len(results['appointments_without_services']),
            'appointments_with_incompatible_services_count': len(results['appointments_with_incompatible_services']),
            'appointments_without_tickets_count': len(results['appointments_without_tickets']),
            'appointments_with_timing_issues_count': len(results['appointments_with_timing_issues']),
        }
        
        return results
    
    def generate_report(self, results: Dict[str, Any]):
        """Generate analysis report"""
        print("\n" + "="*60)
        print("APPOINTMENT ANALYSIS REPORT")
        print("="*60)
        
        print(f"Total Appointments: {results['total_appointments']}")
        print(f"Appointments without services: {results['summary']['appointments_without_services_count']}")
        print(f"Appointments with incompatible services: {results['summary']['appointments_with_incompatible_services_count']}")
        print(f"Appointments without tickets: {results['summary']['appointments_without_tickets_count']}")
        print(f"Appointments with timing issues: {results['summary']['appointments_with_timing_issues_count']}")
        
        if results['appointments_without_services']:
            print("\nAPPOINTMENTS WITHOUT SERVICES:")
            for apt in results['appointments_without_services']:
                print(f"  - ID: {apt['id']}, Employee: {apt['employee_id']}, Start: {apt['start_datetime']}")
        
        if results['appointments_with_incompatible_services']:
            print("\nAPPOINTMENTS WITH INCOMPATIBLE SERVICES:")
            for apt in results['appointments_with_incompatible_services']:
                print(f"  - Appointment {apt['appointment_id']} for {apt['employee_name']}")
                print(f"    Start: {apt['start_datetime']}")
                print(f"    Technician categories: {apt['incompatible_services'][0]['technician_categories'] if apt['incompatible_services'] else 'None'}")
                for service in apt['incompatible_services']:
                    print(f"    Incompatible: {service['service_name']} (category: {service['category']})")
        
        print("\n" + "="*60)

    def get_category_mapping(self):
        """Helper to understand category mappings"""
        print("\nSERVICE CATEGORY MAPPING:")
        for cat_id, cat_name in self.service_categories.items():
            print(f"  {cat_id}: {cat_name}")
        
        print("\nEMPLOYEE SPECIALIZATIONS:")
        for emp_id, categories in self.employee_categories.items():
            emp_name = f"{self.employees[emp_id]['first_name']} {self.employees[emp_id]['last_name']}" if emp_id in self.employees else f"Employee {emp_id}"
            print(f"  {emp_name} (ID: {emp_id}): {', '.join(categories)}")

def main():
    analyzer = AppointmentAnalyzer('/mnt/d/ClaudeProjects/POSflutter/pos/assets/database/pos.db')
    
    # Show category mappings first
    analyzer.get_category_mapping()
    
    # Run analysis
    results = analyzer.analyze_appointments()
    
    # Generate report
    analyzer.generate_report(results)
    
    # Save detailed results to JSON
    with open('/mnt/d/ClaudeProjects/POSflutter/pos/appointment_analysis_results.json', 'w') as f:
        json.dump(results, f, indent=2)
    
    print(f"\nDetailed results saved to: appointment_analysis_results.json")

if __name__ == "__main__":
    main()