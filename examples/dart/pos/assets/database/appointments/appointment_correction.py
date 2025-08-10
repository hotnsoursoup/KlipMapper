#!/usr/bin/env python3
"""
Appointment Correction Script
Fixes appointment data by ensuring service-technician compatibility.
"""

import sqlite3
import json
import random
from datetime import datetime
from typing import Dict, List, Any, Set, Tuple

class AppointmentCorrector:
    def __init__(self, db_path: str):
        self.db_path = db_path
        self.conn = sqlite3.connect(db_path)
        self.conn.row_factory = sqlite3.Row
        
        # Load reference data
        self.services = self._load_services()
        self.employees = self._load_employees()
        self.employee_categories = self._load_employee_categories()
        self.service_categories = self._load_service_categories()
        
        # Create category mappings
        self.category_id_to_name = {cat_id: name.lower() for cat_id, name in self.service_categories.items()}
        self.category_name_to_id = {name.lower(): cat_id for cat_id, name in self.service_categories.items()}
        
        # Group services by category for easy substitution
        self.services_by_category = {}
        for service_id, service_data in self.services.items():
            cat_id = service_data['category_id']
            if cat_id not in self.services_by_category:
                self.services_by_category[cat_id] = []
            self.services_by_category[cat_id].append(service_data)
    
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
            employee_cats[emp_id].add(row['category_name'])
        return employee_cats
    
    def _load_service_categories(self) -> Dict[int, str]:
        cursor = self.conn.execute("SELECT * FROM service_categories")
        return {row['id']: row['name'] for row in cursor.fetchall()}
    
    def find_compatible_technician(self, services: List[Dict], exclude_emp_id: int = None) -> int:
        """Find a technician who can perform all the services in the list"""
        required_categories = set()
        for service in services:
            cat_id = service.get('category_id')
            if cat_id and cat_id in self.category_id_to_name:
                required_categories.add(self.category_id_to_name[cat_id])
        
        # Find technicians who can handle all required categories
        compatible_technicians = []
        for emp_id, emp_categories in self.employee_categories.items():
            if exclude_emp_id and emp_id == exclude_emp_id:
                continue
            if required_categories.issubset(emp_categories):
                compatible_technicians.append(emp_id)
        
        return random.choice(compatible_technicians) if compatible_technicians else None
    
    def find_compatible_services(self, emp_id: int, original_services: List[Dict]) -> List[Dict]:
        """Find compatible services for a technician based on their specializations"""
        if emp_id not in self.employee_categories:
            return original_services
        
        emp_categories = self.employee_categories[emp_id]
        compatible_services = []
        
        for service in original_services:
            cat_id = service.get('category_id')
            if cat_id and cat_id in self.category_id_to_name:
                cat_name = self.category_id_to_name[cat_id]
                
                if cat_name in emp_categories:
                    # Service is compatible
                    compatible_services.append(service)
                else:
                    # Find a replacement service from technician's specializations
                    replacement = self.find_replacement_service(emp_categories, service)
                    if replacement:
                        compatible_services.append(replacement)
        
        return compatible_services if compatible_services else original_services
    
    def find_replacement_service(self, emp_categories: Set[str], original_service: Dict) -> Dict:
        """Find a replacement service from the technician's specializations"""
        # Get available categories for this technician
        available_cat_ids = []
        for cat_name in emp_categories:
            if cat_name in self.category_name_to_id:
                cat_id = self.category_name_to_id[cat_name]
                available_cat_ids.append(cat_id)
        
        # Try to find a service with similar price/duration
        original_price = original_service.get('price', 0)
        original_duration = original_service.get('duration', 30)
        
        best_replacement = None
        best_score = float('inf')
        
        for cat_id in available_cat_ids:
            if cat_id in self.services_by_category:
                for service_data in self.services_by_category[cat_id]:
                    # Score based on price and duration similarity
                    price_diff = abs(service_data['base_price'] - original_price)
                    duration_diff = abs(service_data['duration_minutes'] - original_duration)
                    score = price_diff + duration_diff
                    
                    if score < best_score:
                        best_score = score
                        best_replacement = {
                            'id': service_data['id'],
                            'name': service_data['name'],
                            'duration': service_data['duration_minutes'],
                            'price': float(service_data['base_price']),
                            'category_id': service_data['category_id']
                        }
        
        return best_replacement
    
    def correct_appointments(self, strategy: str = 'reassign_services') -> Dict[str, Any]:
        """
        Correct appointments using the specified strategy:
        - 'reassign_services': Keep technicians, change incompatible services
        - 'reassign_technicians': Keep services, change technicians
        - 'mixed': Use best approach for each case
        """
        print(f"Starting appointment correction with strategy: {strategy}")
        
        # Load appointments that need correction
        cursor = self.conn.execute("""
            SELECT * FROM appointments 
            ORDER BY start_datetime
        """)
        appointments = [dict(row) for row in cursor.fetchall()]
        
        corrections = []
        
        for appointment in appointments:
            apt_id = appointment['id']
            emp_id = appointment['employee_id']
            services_json = appointment['services']
            
            if not services_json or services_json in ['[]', '', 'null']:
                continue
            
            try:
                services = json.loads(services_json)
                if not services:
                    continue
            except json.JSONDecodeError:
                continue
            
            # Check if correction is needed
            needs_correction = False
            if emp_id in self.employee_categories:
                emp_categories = self.employee_categories[emp_id]
                for service in services:
                    if isinstance(service, dict):  # Skip integer services for now
                        cat_id = service.get('category_id')
                        if cat_id and cat_id in self.category_id_to_name:
                            cat_name = self.category_id_to_name[cat_id]
                            if cat_name not in emp_categories:
                                needs_correction = True
                                break
            
            if not needs_correction:
                continue
            
            # Apply correction strategy
            correction = {'appointment_id': apt_id, 'original_employee_id': emp_id, 'original_services': services}
            
            if strategy == 'reassign_services':
                # Keep technician, change services
                new_services = self.find_compatible_services(emp_id, services)
                correction['new_employee_id'] = emp_id
                correction['new_services'] = new_services
                correction['change_type'] = 'services_changed'
                
            elif strategy == 'reassign_technicians':
                # Keep services, change technician
                new_emp_id = self.find_compatible_technician(services, exclude_emp_id=emp_id)
                if new_emp_id:
                    correction['new_employee_id'] = new_emp_id
                    correction['new_services'] = services
                    correction['change_type'] = 'technician_changed'
                else:
                    # Fallback to service reassignment
                    new_services = self.find_compatible_services(emp_id, services)
                    correction['new_employee_id'] = emp_id
                    correction['new_services'] = new_services
                    correction['change_type'] = 'services_changed_fallback'
            
            elif strategy == 'mixed':
                # Choose best approach per case
                new_emp_id = self.find_compatible_technician(services, exclude_emp_id=emp_id)
                new_services = self.find_compatible_services(emp_id, services)
                
                # Prefer keeping original services if possible
                if new_emp_id:
                    correction['new_employee_id'] = new_emp_id
                    correction['new_services'] = services
                    correction['change_type'] = 'technician_changed'
                else:
                    correction['new_employee_id'] = emp_id
                    correction['new_services'] = new_services
                    correction['change_type'] = 'services_changed'
            
            corrections.append(correction)
        
        return {
            'strategy': strategy,
            'total_corrections': len(corrections),
            'corrections': corrections
        }
    
    def apply_corrections(self, corrections: Dict[str, Any], dry_run: bool = True):
        """Apply the corrections to the database"""
        if dry_run:
            print("DRY RUN - No changes will be made to the database")
        
        print(f"Applying {corrections['total_corrections']} corrections...")
        
        for correction in corrections['corrections']:
            apt_id = correction['appointment_id']
            new_emp_id = correction['new_employee_id']
            new_services = correction['new_services']
            
            new_services_json = json.dumps(new_services)
            
            if not dry_run:
                self.conn.execute("""
                    UPDATE appointments 
                    SET employee_id = ?, services = ?, updated_at = datetime('now')
                    WHERE id = ?
                """, (new_emp_id, new_services_json, apt_id))
        
        if not dry_run:
            self.conn.commit()
            print("Corrections applied successfully!")
        else:
            print("Dry run completed. Use dry_run=False to apply changes.")
    
    def generate_correction_report(self, corrections: Dict[str, Any]):
        """Generate a detailed correction report"""
        print("\n" + "="*80)
        print("APPOINTMENT CORRECTION REPORT")
        print("="*80)
        print(f"Strategy: {corrections['strategy']}")
        print(f"Total corrections: {corrections['total_corrections']}")
        
        change_types = {}
        for correction in corrections['corrections']:
            change_type = correction['change_type']
            change_types[change_type] = change_types.get(change_type, 0) + 1
        
        print("\nChange type summary:")
        for change_type, count in change_types.items():
            print(f"  - {change_type}: {count}")
        
        print("\nDetailed corrections:")
        for i, correction in enumerate(corrections['corrections'][:10]):  # Show first 10
            apt_id = correction['appointment_id']
            orig_emp = correction['original_employee_id']
            new_emp = correction['new_employee_id']
            
            orig_emp_name = f"{self.employees[orig_emp]['first_name']} {self.employees[orig_emp]['last_name']}" if orig_emp in self.employees else f"Employee {orig_emp}"
            new_emp_name = f"{self.employees[new_emp]['first_name']} {self.employees[new_emp]['last_name']}" if new_emp in self.employees else f"Employee {new_emp}"
            
            print(f"\n  Appointment {apt_id}:")
            print(f"    Original technician: {orig_emp_name}")
            print(f"    New technician: {new_emp_name}")
            print(f"    Change type: {correction['change_type']}")
            
            # Show service changes if any
            orig_services = [s.get('name', f"Service {s.get('id', '?')}") for s in correction['original_services'] if isinstance(s, dict)]
            new_services = [s.get('name', f"Service {s.get('id', '?')}") for s in correction['new_services'] if isinstance(s, dict)]
            
            if orig_services != new_services:
                print(f"    Original services: {', '.join(orig_services)}")
                print(f"    New services: {', '.join(new_services)}")
        
        if len(corrections['corrections']) > 10:
            print(f"\n  ... and {len(corrections['corrections']) - 10} more corrections")
        
        print("\n" + "="*80)

def main():
    corrector = AppointmentCorrector('/mnt/d/ClaudeProjects/POSflutter/pos/assets/database/pos.db')
    
    # Test different strategies
    strategies = ['reassign_services', 'reassign_technicians', 'mixed']
    
    for strategy in strategies:
        print(f"\n{'='*60}")
        print(f"TESTING STRATEGY: {strategy.upper()}")
        print(f"{'='*60}")
        
        corrections = corrector.correct_appointments(strategy=strategy)
        corrector.generate_correction_report(corrections)
        
        # Save corrections to file for review
        filename = f'/mnt/d/ClaudeProjects/POSflutter/pos/corrections_{strategy}.json'
        import json
        with open(filename, 'w') as f:
            json.dump(corrections, f, indent=2)
        
        print(f"\nCorrections saved to: {filename}")
    
    print(f"\n{'='*60}")
    print("RECOMMENDATION:")
    print("Review the correction files and choose the strategy that best fits your business needs.")
    print("Then run this script with apply_corrections(corrections, dry_run=False) to apply changes.")
    print(f"{'='*60}")

if __name__ == "__main__":
    main()