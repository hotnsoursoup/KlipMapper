-- Generate Appointments for POS System
-- Created: 2025-08-06
-- This script adds appointments for 8/9 and the following week with varied distribution

-- Appointments for August 9, 2025 (Saturday - End of Week)
-- Morning appointments (9:00 AM - 12:00 PM)

INSERT INTO appointments (id, customer_id, employee_id, start_datetime, end_datetime, services, status, created_at, updated_at) VALUES
-- Jenny Lo (Tech 1) - Acrylics & Waxing specialist
(2001, 5, 1, '2025-08-09 09:00:00', '2025-08-09 10:30:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2002, 12, 1, '2025-08-09 10:45:00', '2025-08-09 11:00:00', '[{"id": 20, "name": "Eyebrow Wax", "duration": 15, "price": 20.0, "category_id": 4}]', 'scheduled', datetime('now'), datetime('now')),
(2003, 8, 1, '2025-08-09 11:15:00', '2025-08-09 12:15:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),

-- Lynn Smith (Tech 2) - Acrylics specialist
(2004, 3, 2, '2025-08-09 09:30:00', '2025-08-09 10:30:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2005, 15, 2, '2025-08-09 11:00:00', '2025-08-09 12:30:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'scheduled', datetime('now'), datetime('now')),

-- Rose Nguyen (Tech 5) - Facial & Waxing specialist
(2006, 7, 5, '2025-08-09 09:00:00', '2025-08-09 09:45:00', '[{"id": 23, "name": "Basic Facial", "duration": 45, "price": 60.0, "category_id": 5}]', 'confirmed', datetime('now'), datetime('now')),
(2007, 19, 5, '2025-08-09 10:00:00', '2025-08-09 10:20:00', '[{"id": 20, "name": "Eyebrow Wax", "duration": 15, "price": 20.0, "category_id": 4}, {"id": 21, "name": "Lip Wax", "duration": 10, "price": 15.0, "category_id": 4}]', 'scheduled', datetime('now'), datetime('now')),
(2008, 22, 5, '2025-08-09 10:30:00', '2025-08-09 11:30:00', '[{"id": 24, "name": "Deluxe Facial", "duration": 60, "price": 85.0, "category_id": 5}]', 'confirmed', datetime('now'), datetime('now')),

-- Afternoon appointments (12:00 PM - 5:00 PM)
-- Tony Li (Tech 4) - General services
(2009, 6, 4, '2025-08-09 12:30:00', '2025-08-09 13:15:00', '[{"id": 8, "name": "Collagen Manicure", "duration": 45, "price": 38.0, "category_id": 1}]', 'confirmed', datetime('now'), datetime('now')),
(2010, 24, 4, '2025-08-09 13:30:00', '2025-08-09 14:30:00', '[{"id": 2, "name": "Pedicure", "duration": 45, "price": 47.0, "category_id": 1}, {"id": 20, "name": "Eyebrow Wax", "duration": 15, "price": 20.0, "category_id": 4}]', 'scheduled', datetime('now'), datetime('now')),
(2011, 11, 4, '2025-08-09 14:45:00', '2025-08-09 15:35:00', '[{"id": 19, "name": "Dip Powder", "duration": 50, "price": 55.0, "category_id": 6}]', 'confirmed', datetime('now'), datetime('now')),

-- Kim Anh (Tech 7) - Acrylics & Waxing
(2012, 13, 7, '2025-08-09 13:00:00', '2025-08-09 14:00:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2013, 26, 7, '2025-08-09 14:15:00', '2025-08-09 14:25:00', '[{"id": 22, "name": "Chin Wax", "duration": 10, "price": 15.0, "category_id": 4}]', 'scheduled', datetime('now'), datetime('now')),
(2014, 2, 7, '2025-08-09 14:45:00', '2025-08-09 16:15:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),

-- Sophia Turner (Tech 10) - All services
(2015, 18, 10, '2025-08-09 12:00:00', '2025-08-09 12:45:00', '[{"id": 23, "name": "Basic Facial", "duration": 45, "price": 60.0, "category_id": 5}]', 'confirmed', datetime('now'), datetime('now')),
(2016, 9, 10, '2025-08-09 13:00:00', '2025-08-09 14:00:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'scheduled', datetime('now'), datetime('now')),
(2017, 25, 10, '2025-08-09 14:15:00', '2025-08-09 14:35:00', '[{"id": 20, "name": "Eyebrow Wax", "duration": 15, "price": 20.0, "category_id": 4}, {"id": 21, "name": "Lip Wax", "duration": 10, "price": 15.0, "category_id": 4}]', 'confirmed', datetime('now'), datetime('now')),

-- Late afternoon/Evening (5:00 PM - 7:00 PM)
-- David Nguyen (Tech 6) - General services
(2018, 14, 6, '2025-08-09 17:00:00', '2025-08-09 17:30:00', '[{"id": 1, "name": "Manicure", "duration": 30, "price": 37.0, "category_id": 1}]', 'confirmed', datetime('now'), datetime('now')),
(2019, 20, 6, '2025-08-09 17:45:00', '2025-08-09 18:45:00', '[{"id": 5, "name": "Deluxe Pedicure", "duration": 60, "price": 65.0, "category_id": 1}]', 'scheduled', datetime('now'), datetime('now')),

-- Jessica Pope (Tech 9) - Facial specialist
(2020, 23, 9, '2025-08-09 17:00:00', '2025-08-09 18:00:00', '[{"id": 24, "name": "Deluxe Facial", "duration": 60, "price": 85.0, "category_id": 5}]', 'confirmed', datetime('now'), datetime('now')),

-- =================================================================================
-- Next Week Appointments (August 11-17, 2025)
-- Monday, August 11 - Moderate day (50% capacity)
-- =================================================================================

-- Morning shift
(2021, 4, 1, '2025-08-11 09:00:00', '2025-08-11 10:00:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2022, 7, 2, '2025-08-11 09:30:00', '2025-08-11 11:00:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'scheduled', datetime('now'), datetime('now')),
(2023, 16, 5, '2025-08-11 10:00:00', '2025-08-11 10:45:00', '[{"id": 23, "name": "Basic Facial", "duration": 45, "price": 60.0, "category_id": 5}]', 'confirmed', datetime('now'), datetime('now')),
(2024, 21, 6, '2025-08-11 10:30:00', '2025-08-11 11:15:00', '[{"id": 2, "name": "Pedicure", "duration": 45, "price": 47.0, "category_id": 1}]', 'confirmed', datetime('now'), datetime('now')),

-- Afternoon shift
(2025, 10, 3, '2025-08-11 13:00:00', '2025-08-11 14:30:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2026, 1, 4, '2025-08-11 14:00:00', '2025-08-11 14:45:00', '[{"id": 3, "name": "Gel Manicure", "duration": 45, "price": 40.0, "category_id": 2}]', 'scheduled', datetime('now'), datetime('now')),
(2027, 25, 7, '2025-08-11 14:30:00', '2025-08-11 15:30:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2028, 17, 8, '2025-08-11 15:00:00', '2025-08-11 16:15:00', '[{"id": 15, "name": "SNS Full Set", "duration": 75, "price": 50.0, "category_id": 6}]', 'confirmed', datetime('now'), datetime('now')),

-- =================================================================================
-- Tuesday, August 12 - Busy day (75% capacity)
-- =================================================================================

-- Early morning
(2029, 3, 1, '2025-08-12 09:00:00', '2025-08-12 10:30:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2030, 6, 2, '2025-08-12 09:00:00', '2025-08-12 10:00:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2031, 12, 3, '2025-08-12 09:30:00', '2025-08-12 10:30:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'scheduled', datetime('now'), datetime('now')),
(2032, 8, 4, '2025-08-12 09:00:00', '2025-08-12 10:00:00', '[{"id": 4, "name": "Gel Pedicure", "duration": 60, "price": 55.0, "category_id": 2}]', 'confirmed', datetime('now'), datetime('now')),
(2033, 15, 5, '2025-08-12 09:30:00', '2025-08-12 10:30:00', '[{"id": 24, "name": "Deluxe Facial", "duration": 60, "price": 85.0, "category_id": 5}]', 'confirmed', datetime('now'), datetime('now')),

-- Mid-morning
(2034, 19, 1, '2025-08-12 10:45:00', '2025-08-12 11:45:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2035, 22, 2, '2025-08-12 10:15:00', '2025-08-12 11:45:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'scheduled', datetime('now'), datetime('now')),
(2036, 24, 3, '2025-08-12 10:45:00', '2025-08-12 11:45:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2037, 11, 5, '2025-08-12 10:45:00', '2025-08-12 11:05:00', '[{"id": 20, "name": "Eyebrow Wax", "duration": 15, "price": 20.0, "category_id": 4}, {"id": 21, "name": "Lip Wax", "duration": 10, "price": 15.0, "category_id": 4}]', 'confirmed', datetime('now'), datetime('now')),

-- Afternoon rush
(2038, 2, 6, '2025-08-12 13:00:00', '2025-08-12 14:00:00', '[{"id": 6, "name": "Hot Stone Pedicure", "duration": 60, "price": 70.0, "category_id": 1}]', 'confirmed', datetime('now'), datetime('now')),
(2039, 5, 7, '2025-08-12 13:30:00', '2025-08-12 15:00:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'scheduled', datetime('now'), datetime('now')),
(2040, 9, 8, '2025-08-12 14:00:00', '2025-08-12 14:30:00', '[{"id": 1, "name": "Manicure", "duration": 30, "price": 37.0, "category_id": 1}]', 'confirmed', datetime('now'), datetime('now')),
(2041, 13, 9, '2025-08-12 14:00:00', '2025-08-12 14:45:00', '[{"id": 23, "name": "Basic Facial", "duration": 45, "price": 60.0, "category_id": 5}]', 'confirmed', datetime('now'), datetime('now')),
(2042, 18, 10, '2025-08-12 13:00:00', '2025-08-12 14:00:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),

-- Late afternoon
(2043, 14, 11, '2025-08-12 16:00:00', '2025-08-12 16:45:00', '[{"id": 8, "name": "Collagen Manicure", "duration": 45, "price": 38.0, "category_id": 1}]', 'confirmed', datetime('now'), datetime('now')),
(2044, 20, 12, '2025-08-12 16:30:00', '2025-08-12 16:45:00', '[{"id": 20, "name": "Eyebrow Wax", "duration": 15, "price": 20.0, "category_id": 4}]', 'scheduled', datetime('now'), datetime('now')),
(2045, 23, 13, '2025-08-12 17:00:00', '2025-08-12 18:00:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),

-- =================================================================================
-- Wednesday, August 13 - Extremely busy day (80% capacity)
-- =================================================================================

-- Full morning schedule
(2046, 26, 1, '2025-08-13 09:00:00', '2025-08-13 10:00:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2047, 4, 2, '2025-08-13 09:00:00', '2025-08-13 10:30:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2048, 7, 3, '2025-08-13 09:00:00', '2025-08-13 10:00:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2049, 10, 4, '2025-08-13 09:15:00', '2025-08-13 10:30:00', '[{"id": 16, "name": "SNS P&W Ombre", "duration": 75, "price": 60.0, "category_id": 6}]', 'scheduled', datetime('now'), datetime('now')),
(2050, 16, 5, '2025-08-13 09:00:00', '2025-08-13 10:00:00', '[{"id": 24, "name": "Deluxe Facial", "duration": 60, "price": 85.0, "category_id": 5}]', 'confirmed', datetime('now'), datetime('now')),
(2051, 21, 6, '2025-08-13 09:30:00', '2025-08-13 10:30:00', '[{"id": 7, "name": "CBD Pedicure", "duration": 60, "price": 75.0, "category_id": 1}]', 'confirmed', datetime('now'), datetime('now')),
(2052, 1, 7, '2025-08-13 09:00:00', '2025-08-13 10:30:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),

-- Late morning
(2053, 25, 1, '2025-08-13 10:15:00', '2025-08-13 11:15:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2054, 17, 2, '2025-08-13 10:45:00', '2025-08-13 11:45:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'scheduled', datetime('now'), datetime('now')),
(2055, 3, 3, '2025-08-13 10:15:00', '2025-08-13 11:45:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2056, 6, 5, '2025-08-13 10:15:00', '2025-08-13 10:30:00', '[{"id": 20, "name": "Eyebrow Wax", "duration": 15, "price": 20.0, "category_id": 4}]', 'confirmed', datetime('now'), datetime('now')),

-- Lunch rush
(2057, 12, 8, '2025-08-13 12:00:00', '2025-08-13 12:45:00', '[{"id": 3, "name": "Gel Manicure", "duration": 45, "price": 40.0, "category_id": 2}]', 'confirmed', datetime('now'), datetime('now')),
(2058, 8, 9, '2025-08-13 12:30:00', '2025-08-13 13:30:00', '[{"id": 24, "name": "Deluxe Facial", "duration": 60, "price": 85.0, "category_id": 5}]', 'scheduled', datetime('now'), datetime('now')),
(2059, 15, 10, '2025-08-13 12:00:00', '2025-08-13 13:00:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),

-- Afternoon
(2060, 19, 11, '2025-08-13 14:00:00', '2025-08-13 15:00:00', '[{"id": 5, "name": "Deluxe Pedicure", "duration": 60, "price": 65.0, "category_id": 1}]', 'confirmed', datetime('now'), datetime('now')),
(2061, 22, 12, '2025-08-13 14:30:00', '2025-08-13 14:50:00', '[{"id": 20, "name": "Eyebrow Wax", "duration": 15, "price": 20.0, "category_id": 4}, {"id": 22, "name": "Chin Wax", "duration": 10, "price": 15.0, "category_id": 4}]', 'confirmed', datetime('now'), datetime('now')),
(2062, 24, 13, '2025-08-13 15:00:00', '2025-08-13 16:30:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'scheduled', datetime('now'), datetime('now')),
(2063, 11, 14, '2025-08-13 15:30:00', '2025-08-13 16:15:00', '[{"id": 23, "name": "Basic Facial", "duration": 45, "price": 60.0, "category_id": 5}]', 'confirmed', datetime('now'), datetime('now')),

-- Evening
(2064, 2, 15, '2025-08-13 17:00:00', '2025-08-13 17:50:00', '[{"id": 19, "name": "Dip Powder", "duration": 50, "price": 55.0, "category_id": 6}]', 'confirmed', datetime('now'), datetime('now')),
(2065, 5, 16, '2025-08-13 17:30:00', '2025-08-13 17:45:00', '[{"id": 20, "name": "Eyebrow Wax", "duration": 15, "price": 20.0, "category_id": 4}]', 'scheduled', datetime('now'), datetime('now')),

-- =================================================================================
-- Thursday, August 14 - Moderate day (60% capacity)
-- =================================================================================

(2066, 9, 1, '2025-08-14 09:30:00', '2025-08-14 10:30:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2067, 13, 2, '2025-08-14 10:00:00', '2025-08-14 11:30:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'scheduled', datetime('now'), datetime('now')),
(2068, 18, 4, '2025-08-14 10:30:00', '2025-08-14 11:30:00', '[{"id": 2, "name": "Pedicure", "duration": 45, "price": 47.0, "category_id": 1}, {"id": 1, "name": "Manicure", "duration": 30, "price": 37.0, "category_id": 1}]', 'confirmed', datetime('now'), datetime('now')),
(2069, 14, 5, '2025-08-14 11:00:00', '2025-08-14 11:45:00', '[{"id": 23, "name": "Basic Facial", "duration": 45, "price": 60.0, "category_id": 5}]', 'confirmed', datetime('now'), datetime('now')),
(2070, 20, 7, '2025-08-14 13:00:00', '2025-08-14 14:00:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2071, 23, 8, '2025-08-14 14:00:00', '2025-08-14 14:45:00', '[{"id": 3, "name": "Gel Manicure", "duration": 45, "price": 40.0, "category_id": 2}]', 'scheduled', datetime('now'), datetime('now')),
(2072, 26, 9, '2025-08-14 14:30:00', '2025-08-14 15:30:00', '[{"id": 24, "name": "Deluxe Facial", "duration": 60, "price": 85.0, "category_id": 5}]', 'confirmed', datetime('now'), datetime('now')),
(2073, 4, 10, '2025-08-14 15:00:00', '2025-08-14 16:00:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2074, 7, 11, '2025-08-14 16:00:00', '2025-08-14 17:00:00', '[{"id": 4, "name": "Gel Pedicure", "duration": 60, "price": 55.0, "category_id": 2}]', 'confirmed', datetime('now'), datetime('now')),
(2075, 10, 12, '2025-08-14 16:30:00', '2025-08-14 16:40:00', '[{"id": 21, "name": "Lip Wax", "duration": 10, "price": 15.0, "category_id": 4}]', 'scheduled', datetime('now'), datetime('now')),

-- =================================================================================
-- Friday, August 15 - Very busy day (75% capacity)
-- =================================================================================

-- Morning
(2076, 16, 1, '2025-08-15 09:00:00', '2025-08-15 10:30:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2077, 21, 2, '2025-08-15 09:00:00', '2025-08-15 10:00:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2078, 1, 3, '2025-08-15 09:30:00', '2025-08-15 10:30:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'scheduled', datetime('now'), datetime('now')),
(2079, 25, 4, '2025-08-15 09:00:00', '2025-08-15 10:00:00', '[{"id": 6, "name": "Hot Stone Pedicure", "duration": 60, "price": 70.0, "category_id": 1}]', 'confirmed', datetime('now'), datetime('now')),
(2080, 17, 5, '2025-08-15 09:15:00', '2025-08-15 10:00:00', '[{"id": 23, "name": "Basic Facial", "duration": 45, "price": 60.0, "category_id": 5}]', 'confirmed', datetime('now'), datetime('now')),

-- Mid-morning
(2081, 3, 1, '2025-08-15 10:45:00', '2025-08-15 11:45:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2082, 6, 2, '2025-08-15 10:15:00', '2025-08-15 11:45:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'scheduled', datetime('now'), datetime('now')),
(2083, 12, 3, '2025-08-15 10:45:00', '2025-08-15 11:45:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2084, 8, 5, '2025-08-15 10:15:00', '2025-08-15 10:30:00', '[{"id": 20, "name": "Eyebrow Wax", "duration": 15, "price": 20.0, "category_id": 4}]', 'confirmed', datetime('now'), datetime('now')),

-- Afternoon
(2085, 15, 6, '2025-08-15 13:00:00', '2025-08-15 13:30:00', '[{"id": 1, "name": "Manicure", "duration": 30, "price": 37.0, "category_id": 1}]', 'confirmed', datetime('now'), datetime('now')),
(2086, 19, 7, '2025-08-15 13:30:00', '2025-08-15 15:00:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'scheduled', datetime('now'), datetime('now')),
(2087, 22, 8, '2025-08-15 14:00:00', '2025-08-15 15:15:00', '[{"id": 15, "name": "SNS Full Set", "duration": 75, "price": 50.0, "category_id": 6}]', 'confirmed', datetime('now'), datetime('now')),
(2088, 24, 9, '2025-08-15 14:00:00', '2025-08-15 15:00:00', '[{"id": 24, "name": "Deluxe Facial", "duration": 60, "price": 85.0, "category_id": 5}]', 'confirmed', datetime('now'), datetime('now')),
(2089, 11, 10, '2025-08-15 13:00:00', '2025-08-15 14:00:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),

-- Late afternoon/Evening
(2090, 2, 11, '2025-08-15 16:00:00', '2025-08-15 17:00:00', '[{"id": 5, "name": "Deluxe Pedicure", "duration": 60, "price": 65.0, "category_id": 1}]', 'confirmed', datetime('now'), datetime('now')),
(2091, 5, 12, '2025-08-15 16:30:00', '2025-08-15 16:45:00', '[{"id": 20, "name": "Eyebrow Wax", "duration": 15, "price": 20.0, "category_id": 4}]', 'scheduled', datetime('now'), datetime('now')),
(2092, 9, 13, '2025-08-15 17:00:00', '2025-08-15 18:00:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2093, 13, 14, '2025-08-15 17:30:00', '2025-08-15 18:15:00', '[{"id": 23, "name": "Basic Facial", "duration": 45, "price": 60.0, "category_id": 5}]', 'confirmed', datetime('now'), datetime('now')),

-- =================================================================================
-- Saturday, August 16 - Weekend busy (70% capacity)
-- =================================================================================

-- Morning rush
(2094, 18, 1, '2025-08-16 09:00:00', '2025-08-16 10:00:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2095, 14, 2, '2025-08-16 09:00:00', '2025-08-16 10:30:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2096, 20, 3, '2025-08-16 09:30:00', '2025-08-16 10:30:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'scheduled', datetime('now'), datetime('now')),
(2097, 23, 4, '2025-08-16 09:00:00', '2025-08-16 09:45:00', '[{"id": 8, "name": "Collagen Manicure", "duration": 45, "price": 38.0, "category_id": 1}]', 'confirmed', datetime('now'), datetime('now')),
(2098, 26, 5, '2025-08-16 09:15:00', '2025-08-16 10:15:00', '[{"id": 24, "name": "Deluxe Facial", "duration": 60, "price": 85.0, "category_id": 5}]', 'confirmed', datetime('now'), datetime('now')),

-- Late morning
(2099, 4, 1, '2025-08-16 10:15:00', '2025-08-16 11:15:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2100, 7, 2, '2025-08-16 10:45:00', '2025-08-16 11:45:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'scheduled', datetime('now'), datetime('now')),
(2101, 10, 3, '2025-08-16 10:45:00', '2025-08-16 12:15:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2102, 16, 5, '2025-08-16 10:30:00', '2025-08-16 10:50:00', '[{"id": 20, "name": "Eyebrow Wax", "duration": 15, "price": 20.0, "category_id": 4}, {"id": 22, "name": "Chin Wax", "duration": 10, "price": 15.0, "category_id": 4}]', 'confirmed', datetime('now'), datetime('now')),

-- Afternoon
(2103, 21, 6, '2025-08-16 13:00:00', '2025-08-16 14:00:00', '[{"id": 7, "name": "CBD Pedicure", "duration": 60, "price": 75.0, "category_id": 1}]', 'confirmed', datetime('now'), datetime('now')),
(2104, 1, 7, '2025-08-16 13:30:00', '2025-08-16 14:30:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'scheduled', datetime('now'), datetime('now')),
(2105, 25, 8, '2025-08-16 14:00:00', '2025-08-16 15:15:00', '[{"id": 16, "name": "SNS P&W Ombre", "duration": 75, "price": 60.0, "category_id": 6}]', 'confirmed', datetime('now'), datetime('now')),
(2106, 17, 9, '2025-08-16 14:30:00', '2025-08-16 15:15:00', '[{"id": 23, "name": "Basic Facial", "duration": 45, "price": 60.0, "category_id": 5}]', 'confirmed', datetime('now'), datetime('now')),
(2107, 3, 10, '2025-08-16 13:00:00', '2025-08-16 14:30:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),

-- Late afternoon
(2108, 6, 11, '2025-08-16 16:00:00', '2025-08-16 16:45:00', '[{"id": 2, "name": "Pedicure", "duration": 45, "price": 47.0, "category_id": 1}]', 'confirmed', datetime('now'), datetime('now')),
(2109, 12, 12, '2025-08-16 16:30:00', '2025-08-16 16:45:00', '[{"id": 20, "name": "Eyebrow Wax", "duration": 15, "price": 20.0, "category_id": 4}]', 'scheduled', datetime('now'), datetime('now')),
(2110, 8, 13, '2025-08-16 17:00:00', '2025-08-16 18:30:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),

-- =================================================================================
-- Sunday, August 17 - Light day (40% capacity)
-- =================================================================================

(2111, 15, 1, '2025-08-17 10:00:00', '2025-08-17 11:00:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2112, 19, 2, '2025-08-17 10:30:00', '2025-08-17 12:00:00', '[{"id": 17, "name": "Acrylic Full Set", "duration": 90, "price": 65.0, "category_id": 3}]', 'scheduled', datetime('now'), datetime('now')),
(2113, 22, 4, '2025-08-17 11:00:00', '2025-08-17 11:30:00', '[{"id": 1, "name": "Manicure", "duration": 30, "price": 37.0, "category_id": 1}]', 'confirmed', datetime('now'), datetime('now')),
(2114, 24, 5, '2025-08-17 11:00:00', '2025-08-17 11:45:00', '[{"id": 23, "name": "Basic Facial", "duration": 45, "price": 60.0, "category_id": 5}]', 'confirmed', datetime('now'), datetime('now')),
(2115, 11, 7, '2025-08-17 13:00:00', '2025-08-17 14:00:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now')),
(2116, 2, 8, '2025-08-17 14:00:00', '2025-08-17 14:50:00', '[{"id": 19, "name": "Dip Powder", "duration": 50, "price": 55.0, "category_id": 6}]', 'scheduled', datetime('now'), datetime('now')),
(2117, 5, 9, '2025-08-17 14:30:00', '2025-08-17 15:30:00', '[{"id": 24, "name": "Deluxe Facial", "duration": 60, "price": 85.0, "category_id": 5}]', 'confirmed', datetime('now'), datetime('now')),
(2118, 9, 10, '2025-08-17 15:00:00', '2025-08-17 16:00:00', '[{"id": 18, "name": "Acrylic Fill", "duration": 60, "price": 50.0, "category_id": 3}]', 'confirmed', datetime('now'), datetime('now'));

-- Update stats
SELECT 'Added ' || COUNT(*) || ' new appointments' FROM appointments WHERE id >= 2001;