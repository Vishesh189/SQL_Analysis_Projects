CREATE TABLE billings (
    date TIMESTAMP,
    time TIME,
    booking_id VARCHAR(20),
    booking_status VARCHAR(50),
    customer_id VARCHAR(20),
    vehicle_type VARCHAR(30),
    pickup_location VARCHAR(100),
    drop_location VARCHAR(100),
    v_tat INTEGER,
    c_tat INTEGER,
    canceled_rides_by_customer TEXT,
    canceled_rides_by_driver TEXT,
    incomplete_rides TEXT,
    incomplete_rides_reason TEXT,
    booking_value NUMERIC(10, 2),
    payment_method VARCHAR(30),
    ride_distance NUMERIC(10, 2),
    driver_ratings NUMERIC(3, 1),
    customer_rating NUMERIC(3, 1)
);

-- SQL Questions:
-- 1. Retrieve all successful bookings:

CREATE VIEW Successful_Bookings AS
SELECT *
FROM billings 
WHERE booking_status = 'Success';

SELECT * FROM Successful_Bookings;

-- 2. Find the average ride distance for each vehicle type:

CREATE VIEW  Average_Ride_Distance AS
SELECT vehicle_type, AVG(ride_distance) AS avg_distance 
FROM billings
GROUP BY vehicle_type;

SELECT * FROM Average_Ride_Distance;
 
-- 3. Get the total number of cancelled rides by customers:

CREATE VIEW Customer_Canceled_Rides AS
SELECT COUNT(*) AS canceled_ridecount
FROM billings
WHERE booking_status = 'Canceled by Customer';

SELECT * FROM Customer_Canceled_Rides;

-- 4. List the top 5 customers who booked the highest number of rides:

CREATE VIEW Top_5_Customers AS
SELECT customer_id, COUNT(booking_id) AS total_booking
FROM billings 
GROUP BY customer_id
ORDER BY total_booking DESC 
LIMIT 5;

SELECT * FROM Top_5_Customers;

-- 5. Get the number of rides cancelled by drivers due to personal and car-related issues:

CREATE VIEW Driver_Canceled_Rides AS
SELECT COUNT(*) AS Driver_Canceled_Rides
FROM billings
WHERE canceled_rides_by_driver = 'Personal & Car related issue';

SELECT * FROM Driver_Canceled_Rides;

-- 6. Find the maximum and minimum driver ratings for Prime Sedan bookings:

SELECT MAX(driver_ratings) AS max_driver_ratings, MIN(driver_ratings) AS min_driver_ratings
FROM billings
WHERE vehicle_type = 'Prime Sedan';

-- 7. Retrieve all rides where payment was made using UPI:

SELECT * 
FROM billings
WHERE payment_method = 'UPI'

-- 8. Find the average customer rating per vehicle type:

SELECT vehicle_type, ROUND(AVG(customer_rating),2) 
FROM billings
GROUP BY vehicle_type

-- 9. Calculate the total booking value of rides completed successfully:

SELECT SUM(booking_value) AS total_booking_value
FROM billings
WHERE  = 'Success';

-- 10. List all incomplete rides along with the reason:

SELECT * 
FROM billings
WHERE incomplete_rides = 'Yes';
