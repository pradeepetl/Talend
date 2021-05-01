SELECT

VendorID,
passenger_count,
trip_distance,

CASE WHEN 
PULocationID=B.LocationID
THEN B.Latitude 
END pickup_longitude,

CASE WHEN 
PULocationID=B.LocationID
THEN B.Longitude 
END pickup_latitude,

CASE WHEN 
PULocationID=B.LocationID
THEN B.Latitude 
END pickup_longitude,

CASE WHEN 
DOLocationID=B.LocationID
THEN B.Longitude 
END dropoff_longitude,

CASE WHEN 
DOLocationID=B.LocationID
THEN B.Latitude 
END dropoff_latitude,

payment_type,
fare_amount,
extra,
tip_amount,
total_amount,
ratecodeid,

tpep_pickup_datetime,
tpep_dropoff_datetime,


CASE WHEN dropoff_latitude > 41.4
THEN 'Out'
WHEN dropoff_latitude < 40.630
THEN 'Out'
ELSE 'In'
END In_or_out,


CASE WHEN TipPercentage < 0 THEN 'No Tip'
WHEN TipPercentage BETWEEN 0 AND 5 THEN 'Less but still a Tip'
WHEN TipPercentage BETWEEN 5 AND 10 THEN 'Decent Tip'
WHEN TipPercentage > 10 THEN 'Good Tip'
ELSE 'Something different'
END AS TipRange,
Hr,
Wk,
TripMonth,
Trips,
Tips,
AverageSpeed,
AverageDistance,
TipPercentage,
Tipbin
FROM
(
    
SELECT
EXTRACT(HOUR from tpep_pickup_datetime) As Hr,
EXTRACT(DAYOFWEEK from tpep_pickup_datetime) As Wk,
Extract (MONTH from tpep_pickup_datetime) As TripMonth,
 
VendorID,
passenger_count,
trip_distance,
payment_type,
fare_amount,
extra,
tip_amount,
total_amount,
ratecodeid,
    
PULocationID,
DOLocationID,
    
tpep_pickup_datetime,
tpep_dropoff_datetime,

 
case when tip_amount=0 then 'No Tip'
when (tip_amount > 0 and tip_amount <=5) then '0-5'
when (tip_amount > 5 and tip_amount <=10) then '5-10'
when (tip_amount > 10 and tip_amount <=20) then '10-20'
when tip_amount > 20 then '> 20'
else 'other'
end as Tipbin,
COUNT(*) Trips,
SUM(tip_amount) as Tips,
ROUND(AVG(trip_distance         /
timediff(second,tpep_dropoff_datetime,tpep_pickup_datetime))*3600,1) as AverageSpeed,
ROUND(AVG(trip_distance),1) as AverageDistance,
ROUND(avg((tip_amount)/(total_amount-tip_amount))*100,3) as TipPercentage
FROM DEMO_DB.PUBLIC.YELLOW_TAXI_2019
WHERE trip_distance >0
AND fare_amount/trip_distance BETWEEN 2 AND 10
AND tpep_dropoff_datetime > tpep_pickup_datetime
 
group by 1,2,3,tip_amount,total_amount,tipbin,VendorID,
passenger_count,
trip_distance,
payment_type,
fare_amount,
extra,
tip_amount,
total_amount,
ratecodeid,
PULocationID,
DOLocationID,tpep_pickup_datetime,
tpep_dropoff_datetime) A
LEFT JOIN 
demo_db.public.taxi_zones B
ON
A.PULocationID=B.LocationID
AND
A.DOLocationID=B.LocationID;
