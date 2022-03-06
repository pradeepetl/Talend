USE DATABASE DEMO_DB;
USE SCHMEA PUBLIC;
USE WAREHOUSE DATA_LOAD;

TRUNCATE TABLE DEMO_DB.PUBLIC.YELLOW_TAXI_2009	;
TRUNCATE TABLE DEMO_DB.PUBLIC.YELLOW_TAXI_2010	;
TRUNCATE TABLE DEMO_DB.PUBLIC.YELLOW_TAXI_2011	;
TRUNCATE TABLE DEMO_DB.PUBLIC.YELLOW_TAXI_2012	;
TRUNCATE TABLE DEMO_DB.PUBLIC.YELLOW_TAXI_2013	;
TRUNCATE TABLE DEMO_DB.PUBLIC.YELLOW_TAXI_2014	;
TRUNCATE TABLE DEMO_DB.PUBLIC.YELLOW_TAXI_2015	;
TRUNCATE TABLE DEMO_DB.PUBLIC.YELLOW_TAXI_2016	;
TRUNCATE TABLE DEMO_DB.PUBLIC.YELLOW_TAXI_2017	;
TRUNCATE TABLE DEMO_DB.PUBLIC.YELLOW_TAXI_2018	;
TRUNCATE TABLE DEMO_DB.PUBLIC.YELLOW_TAXI_2019	;
TRUNCATE TABLE DEMO_DB.PUBLIC.YELLOW_TAXI_2020	;

insert into
   demo_db.public.yellow_taxi 
   SELECT
      vendor_name,
      passenger_count,
      trip_distance,
      start_lon,
      start_lat,
      end_lon,
      end_lat,
      payment_type,
      fare_amt,
      null extra,
      TIP_AMT,
      TOTAL_AMT,
      Rate_code,
      CASE
         WHEN
            end_lon > 41.4 
         THEN
            'Out' 
         WHEN
            end_lat < 40.630 
         THEN
            'Out' 
         ELSE
            'In' 
      END
      In_or_out, trip_pickup_datetime, TRIP_DROPOFF_DATETIME, 
      CASE
         WHEN
            TipPercentage < 0 
         THEN
            'No Tip' 
         WHEN
            TipPercentage BETWEEN 0 AND 5 
         THEN
            'Less but still a Tip' 
         WHEN
            TipPercentage BETWEEN 5 AND 10 
         THEN
            'Decent Tip' 
         WHEN
            TipPercentage > 10 
         THEN
            'Good Tip' 
         ELSE
            'Something different' 
      END
      AS TipRange, Hr, Wk, TripMonth, Trips, Tips, AverageSpeed, AverageDistance, TipPercentage, Tipbin 
   FROM
      (
         SELECT
            EXTRACT(HOUR 
         from
            TO_TIMESTAMP_NTZ(trip_pickup_datetime)) As Hr,
            EXTRACT(DAYOFWEEK 
         from
            TO_TIMESTAMP_NTZ(trip_pickup_datetime)) As Wk,
            Extract (MONTH 
         from
            TO_TIMESTAMP_NTZ(trip_pickup_datetime)) As TripMonth,
            vendor_name,
            passenger_count,
            trip_distance,
            start_lon,
            start_lat,
            end_lon,
            end_lat,
            payment_type,
            fare_amt,
            TIP_AMT,
            TOTAL_AMT,
            Rate_code,
            trip_pickup_datetime,
            trip_dropoff_datetime,
            case
               when
                  TIP_AMT = 0 
               then
                  'No Tip' 
               when
                  (
                     TIP_AMT > 0 
                     and TIP_AMT <= 5
                  )
               then
                  '0-5' 
               when
                  (
                     TIP_AMT > 5 
                     and TIP_AMT <= 10
                  )
               then
                  '5-10' 
               when
                  (
                     TIP_AMT > 10 
                     and TIP_AMT <= 20
                  )
               then
                  '10-20' 
               when
                  TIP_AMT > 20 
               then
                  '> 20' 
               else
                  'other' 
            end
            as Tipbin, COUNT(*) Trips, SUM(TIP_AMT) as Tips, ROUND(AVG(trip_distance / timediff(second, trip_dropoff_datetime, trip_pickup_datetime))*3600, 1) as AverageSpeed, ROUND(AVG(trip_distance), 1) as AverageDistance, ROUND(avg((TIP_AMT) / (TOTAL_AMT - TIP_AMT))*100, 3) as TipPercentage 
         FROM
            DEMO_DB.PUBLIC.YELLOW_TAXI_2009 
         WHERE
            trip_distance > 0 
            AND FARE_AMT / trip_distance BETWEEN 2 AND 10 
            AND trip_dropoff_datetime > trip_pickup_datetime 
         group by
            1, 2, 3, TIP_AMT, TOTAL_AMT, tipbin, VENDOR_NAME, passenger_count, trip_distance, start_lon, start_lat, end_lon, end_lat, payment_type, fare_amt, Rate_code, trip_pickup_datetime, TRIP_DROPOFF_DATETIME
      )
;
                                                                 
                                                                   
insert into
   demo_db.public.yellow_taxi 
   SELECT
      VENDOR_ID,
      passenger_count,
      trip_distance,
      PICKUP_LONGITUDE,
      PICKUP_LATITUDE,
      DROPOFF_LONGITUDE,
      DROPOFF_LATITUDE,
      payment_type,
      FARE_AMOUNT,
      null extra,
      TIP_AMOUNT,
      TOTAL_AMOUNT,
      Rate_code,
      CASE
         WHEN
            PICKUP_LONGITUDE > 41.4 
         THEN
            'Out' 
         WHEN
            DROPOFF_LATITUDE < 40.630 
         THEN
            'Out' 
         ELSE
            'In' 
      END
      In_or_out, PICKUP_DATETIME, DROPOFF_DATETIME, 
      CASE
         WHEN
            TipPercentage < 0 
         THEN
            'No Tip' 
         WHEN
            TipPercentage BETWEEN 0 AND 5 
         THEN
            'Less but still a Tip' 
         WHEN
            TipPercentage BETWEEN 5 AND 10 
         THEN
            'Decent Tip' 
         WHEN
            TipPercentage > 10 
         THEN
            'Good Tip' 
         ELSE
            'Something different' 
      END
      AS TipRange, Hr, Wk, TripMonth, Trips, Tips, AverageSpeed, AverageDistance, TipPercentage, Tipbin 
   FROM
      (
         SELECT
            EXTRACT(HOUR 
         from
            TO_TIMESTAMP_NTZ(PICKUP_DATETIME)) As Hr,
            EXTRACT(DAYOFWEEK 
         from
            TO_TIMESTAMP_NTZ(PICKUP_DATETIME)) As Wk,
            Extract (MONTH 
         from
            TO_TIMESTAMP_NTZ(PICKUP_DATETIME)) As TripMonth,
            VENDOR_ID,
            passenger_count,
            trip_distance,
            PICKUP_LONGITUDE,
            PICKUP_LATITUDE,
            DROPOFF_LONGITUDE,
            DROPOFF_LATITUDE,
            payment_type,
            FARE_AMOUNT,
            TIP_AMOUNT,
            TOTAL_AMOUNT,
            Rate_code,
            PICKUP_DATETIME,
            DROPOFF_DATETIME,
            case
               when
                  TIP_AMOUNT = 0 
               then
                  'No Tip' 
               when
                  (
                     TIP_AMOUNT > 0 
                     and TIP_AMOUNT <= 5
                  )
               then
                  '0-5' 
               when
                  (
                     TIP_AMOUNT > 5 
                     and TIP_AMOUNT <= 10
                  )
               then
                  '5-10' 
               when
                  (
                     TIP_AMOUNT > 10 
                     and TIP_AMOUNT <= 20
                  )
               then
                  '10-20' 
               when
                  TIP_AMOUNT > 20 
               then
                  '> 20' 
               else
                  'other' 
            end
            as Tipbin, COUNT(*) Trips, SUM(TIP_AMOUNT) as Tips, ROUND(AVG(trip_distance / timediff(second, DROPOFF_DATETIME, PICKUP_DATETIME))*3600, 1) as AverageSpeed, ROUND(AVG(trip_distance), 1) as AverageDistance, ROUND(avg((TIP_AMOUNT) / (TOTAL_AMOUNT - TIP_AMOUNT))*100, 3) as TipPercentage 
         FROM
            DEMO_DB.PUBLIC.YELLOW_TAXI_2010 
         WHERE
            trip_distance > 0 
            AND FARE_AMOUNT / trip_distance BETWEEN 2 AND 10 
            AND DROPOFF_DATETIME > PICKUP_DATETIME 
         group by
            1, 2, 3, TIP_AMOUNT, TOTAL_AMOUNT, tipbin, VENDOR_ID, passenger_count, trip_distance, PICKUP_LONGITUDE, PICKUP_LATITUDE, DROPOFF_LONGITUDE, DROPOFF_LATITUDE, payment_type, FARE_AMOUNT, Rate_code, PICKUP_DATETIME, DROPOFF_DATETIME
      )
;


insert into
   demo_db.public.yellow_taxi 
   SELECT
      VENDOR_ID,
      passenger_count,
      trip_distance,
      PICKUP_LONGITUDE,
      PICKUP_LATITUDE,
      DROPOFF_LONGITUDE,
      DROPOFF_LATITUDE,
      payment_type,
      FARE_AMOUNT,
      null extra,
      TIP_AMOUNT,
      TOTAL_AMOUNT,
      Rate_code,
      CASE
         WHEN
            PICKUP_LONGITUDE > 41.4 
         THEN
            'Out' 
         WHEN
            DROPOFF_LATITUDE < 40.630 
         THEN
            'Out' 
         ELSE
            'In' 
      END
      In_or_out, PICKUP_DATETIME, DROPOFF_DATETIME, 
      CASE
         WHEN
            TipPercentage < 0 
         THEN
            'No Tip' 
         WHEN
            TipPercentage BETWEEN 0 AND 5 
         THEN
            'Less but still a Tip' 
         WHEN
            TipPercentage BETWEEN 5 AND 10 
         THEN
            'Decent Tip' 
         WHEN
            TipPercentage > 10 
         THEN
            'Good Tip' 
         ELSE
            'Something different' 
      END
      AS TipRange, Hr, Wk, TripMonth, Trips, Tips, AverageSpeed, AverageDistance, TipPercentage, Tipbin 
   FROM
      (
         SELECT
            EXTRACT(HOUR 
         from
            TO_TIMESTAMP_NTZ(PICKUP_DATETIME)) As Hr,
            EXTRACT(DAYOFWEEK 
         from
            TO_TIMESTAMP_NTZ(PICKUP_DATETIME)) As Wk,
            Extract (MONTH 
         from
            TO_TIMESTAMP_NTZ(PICKUP_DATETIME)) As TripMonth,
            VENDOR_ID,
            passenger_count,
            trip_distance,
            PICKUP_LONGITUDE,
            PICKUP_LATITUDE,
            DROPOFF_LONGITUDE,
            DROPOFF_LATITUDE,
            payment_type,
            FARE_AMOUNT,
            TIP_AMOUNT,
            TOTAL_AMOUNT,
            Rate_code,
            PICKUP_DATETIME,
            DROPOFF_DATETIME,
            case
               when
                  TIP_AMOUNT = 0 
               then
                  'No Tip' 
               when
                  (
                     TIP_AMOUNT > 0 
                     and TIP_AMOUNT <= 5
                  )
               then
                  '0-5' 
               when
                  (
                     TIP_AMOUNT > 5 
                     and TIP_AMOUNT <= 10
                  )
               then
                  '5-10' 
               when
                  (
                     TIP_AMOUNT > 10 
                     and TIP_AMOUNT <= 20
                  )
               then
                  '10-20' 
               when
                  TIP_AMOUNT > 20 
               then
                  '> 20' 
               else
                  'other' 
            end
            as Tipbin, COUNT(*) Trips, SUM(TIP_AMOUNT) as Tips, ROUND(AVG(trip_distance / timediff(second, DROPOFF_DATETIME, PICKUP_DATETIME))*3600, 1) as AverageSpeed, ROUND(AVG(trip_distance), 1) as AverageDistance, ROUND(avg((TIP_AMOUNT) / (TOTAL_AMOUNT - TIP_AMOUNT))*100, 3) as TipPercentage 
         FROM
            DEMO_DB.PUBLIC.YELLOW_TAXI_2011 
         WHERE
            trip_distance > 0 
            AND FARE_AMOUNT / trip_distance BETWEEN 2 AND 10 
            AND DROPOFF_DATETIME > PICKUP_DATETIME 
         group by
            1, 2, 3, TIP_AMOUNT, TOTAL_AMOUNT, tipbin, VENDOR_ID, passenger_count, trip_distance, PICKUP_LONGITUDE, PICKUP_LATITUDE, DROPOFF_LONGITUDE, DROPOFF_LATITUDE, payment_type, FARE_AMOUNT, Rate_code, PICKUP_DATETIME, DROPOFF_DATETIME
      )
;
                                                                                                                                        
                                                                      
insert into
   demo_db.public.yellow_taxi 
   SELECT
      VENDOR_ID,
      passenger_count,
      trip_distance,
      PICKUP_LONGITUDE,
      PICKUP_LATITUDE,
      DROPOFF_LONGITUDE,
      DROPOFF_LATITUDE,
      payment_type,
      FARE_AMOUNT,
      null extra,
      TIP_AMOUNT,
      TOTAL_AMOUNT,
      Rate_code,
      CASE
         WHEN
            PICKUP_LONGITUDE > 41.4 
         THEN
            'Out' 
         WHEN
            DROPOFF_LATITUDE < 40.630 
         THEN
            'Out' 
         ELSE
            'In' 
      END
      In_or_out, PICKUP_DATETIME, DROPOFF_DATETIME, 
      CASE
         WHEN
            TipPercentage < 0 
         THEN
            'No Tip' 
         WHEN
            TipPercentage BETWEEN 0 AND 5 
         THEN
            'Less but still a Tip' 
         WHEN
            TipPercentage BETWEEN 5 AND 10 
         THEN
            'Decent Tip' 
         WHEN
            TipPercentage > 10 
         THEN
            'Good Tip' 
         ELSE
            'Something different' 
      END
      AS TipRange, Hr, Wk, TripMonth, Trips, Tips, AverageSpeed, AverageDistance, TipPercentage, Tipbin 
   FROM
      (
         SELECT
            EXTRACT(HOUR 
         from
            TO_TIMESTAMP_NTZ(PICKUP_DATETIME)) As Hr,
            EXTRACT(DAYOFWEEK 
         from
            TO_TIMESTAMP_NTZ(PICKUP_DATETIME)) As Wk,
            Extract (MONTH 
         from
            TO_TIMESTAMP_NTZ(PICKUP_DATETIME)) As TripMonth,
            VENDOR_ID,
            passenger_count,
            trip_distance,
            PICKUP_LONGITUDE,
            PICKUP_LATITUDE,
            DROPOFF_LONGITUDE,
            DROPOFF_LATITUDE,
            payment_type,
            FARE_AMOUNT,
            TIP_AMOUNT,
            TOTAL_AMOUNT,
            Rate_code,
            PICKUP_DATETIME,
            DROPOFF_DATETIME,
            case
               when
                  TIP_AMOUNT = 0 
               then
                  'No Tip' 
               when
                  (
                     TIP_AMOUNT > 0 
                     and TIP_AMOUNT <= 5
                  )
               then
                  '0-5' 
               when
                  (
                     TIP_AMOUNT > 5 
                     and TIP_AMOUNT <= 10
                  )
               then
                  '5-10' 
               when
                  (
                     TIP_AMOUNT > 10 
                     and TIP_AMOUNT <= 20
                  )
               then
                  '10-20' 
               when
                  TIP_AMOUNT > 20 
               then
                  '> 20' 
               else
                  'other' 
            end
            as Tipbin, COUNT(*) Trips, SUM(TIP_AMOUNT) as Tips, ROUND(AVG(trip_distance / timediff(second, DROPOFF_DATETIME, PICKUP_DATETIME))*3600, 1) as AverageSpeed, ROUND(AVG(trip_distance), 1) as AverageDistance, ROUND(avg((TIP_AMOUNT) / (TOTAL_AMOUNT - TIP_AMOUNT))*100, 3) as TipPercentage 
         FROM
            DEMO_DB.PUBLIC.YELLOW_TAXI_2012 
         WHERE
            trip_distance > 0 
            AND FARE_AMOUNT / trip_distance BETWEEN 2 AND 10 
            AND DROPOFF_DATETIME > PICKUP_DATETIME 
         group by
            1, 2, 3, TIP_AMOUNT, TOTAL_AMOUNT, tipbin, VENDOR_ID, passenger_count, trip_distance, PICKUP_LONGITUDE, PICKUP_LATITUDE, DROPOFF_LONGITUDE, DROPOFF_LATITUDE, payment_type, FARE_AMOUNT, Rate_code, PICKUP_DATETIME, DROPOFF_DATETIME
      )
;
                                                                                                                                           
                                                                      
insert into
   demo_db.public.yellow_taxi 
   SELECT
      VENDOR_ID,
      passenger_count,
      trip_distance,
      PICKUP_LONGITUDE,
      PICKUP_LATITUDE,
      DROPOFF_LONGITUDE,
      DROPOFF_LATITUDE,
      payment_type,
      FARE_AMOUNT,
      null extra,
      TIP_AMOUNT,
      TOTAL_AMOUNT,
      Rate_code,
      CASE
         WHEN
            PICKUP_LONGITUDE > 41.4 
         THEN
            'Out' 
         WHEN
            DROPOFF_LATITUDE < 40.630 
         THEN
            'Out' 
         ELSE
            'In' 
      END
      In_or_out, PICKUP_DATETIME, DROPOFF_DATETIME, 
      CASE
         WHEN
            TipPercentage < 0 
         THEN
            'No Tip' 
         WHEN
            TipPercentage BETWEEN 0 AND 5 
         THEN
            'Less but still a Tip' 
         WHEN
            TipPercentage BETWEEN 5 AND 10 
         THEN
            'Decent Tip' 
         WHEN
            TipPercentage > 10 
         THEN
            'Good Tip' 
         ELSE
            'Something different' 
      END
      AS TipRange, Hr, Wk, TripMonth, Trips, Tips, AverageSpeed, AverageDistance, TipPercentage, Tipbin 
   FROM
      (
         SELECT
            EXTRACT(HOUR 
         from
            TO_TIMESTAMP_NTZ(PICKUP_DATETIME)) As Hr,
            EXTRACT(DAYOFWEEK 
         from
            TO_TIMESTAMP_NTZ(PICKUP_DATETIME)) As Wk,
            Extract (MONTH 
         from
            TO_TIMESTAMP_NTZ(PICKUP_DATETIME)) As TripMonth,
            VENDOR_ID,
            passenger_count,
            trip_distance,
            PICKUP_LONGITUDE,
            PICKUP_LATITUDE,
            DROPOFF_LONGITUDE,
            DROPOFF_LATITUDE,
            payment_type,
            FARE_AMOUNT,
            TIP_AMOUNT,
            TOTAL_AMOUNT,
            Rate_code,
            PICKUP_DATETIME,
            DROPOFF_DATETIME,
            case
               when
                  TIP_AMOUNT = 0 
               then
                  'No Tip' 
               when
                  (
                     TIP_AMOUNT > 0 
                     and TIP_AMOUNT <= 5
                  )
               then
                  '0-5' 
               when
                  (
                     TIP_AMOUNT > 5 
                     and TIP_AMOUNT <= 10
                  )
               then
                  '5-10' 
               when
                  (
                     TIP_AMOUNT > 10 
                     and TIP_AMOUNT <= 20
                  )
               then
                  '10-20' 
               when
                  TIP_AMOUNT > 20 
               then
                  '> 20' 
               else
                  'other' 
            end
            as Tipbin, COUNT(*) Trips, SUM(TIP_AMOUNT) as Tips, ROUND(AVG(trip_distance / timediff(second, DROPOFF_DATETIME, PICKUP_DATETIME))*3600, 1) as AverageSpeed, ROUND(AVG(trip_distance), 1) as AverageDistance, ROUND(avg((TIP_AMOUNT) / (TOTAL_AMOUNT - TIP_AMOUNT))*100, 3) as TipPercentage 
         FROM
            DEMO_DB.PUBLIC.YELLOW_TAXI_2013 
         WHERE
            trip_distance > 0 
            AND FARE_AMOUNT / trip_distance BETWEEN 2 AND 10 
            AND DROPOFF_DATETIME > PICKUP_DATETIME 
         group by
            1, 2, 3, TIP_AMOUNT, TOTAL_AMOUNT, tipbin, VENDOR_ID, passenger_count, trip_distance, PICKUP_LONGITUDE, PICKUP_LATITUDE, DROPOFF_LONGITUDE, DROPOFF_LATITUDE, payment_type, FARE_AMOUNT, Rate_code, PICKUP_DATETIME, DROPOFF_DATETIME
      )
;
                                                                      
                                                                      
insert into
   demo_db.public.yellow_taxi 
   SELECT
      VENDOR_ID,
      passenger_count,
      trip_distance,
      PICKUP_LONGITUDE,
      PICKUP_LATITUDE,
      DROPOFF_LONGITUDE,
      DROPOFF_LATITUDE,
      payment_type,
      FARE_AMOUNT,
      null extra,
      TIP_AMOUNT,
      TOTAL_AMOUNT,
      Rate_code,
      CASE
         WHEN
            PICKUP_LONGITUDE > 41.4 
         THEN
            'Out' 
         WHEN
            DROPOFF_LATITUDE < 40.630 
         THEN
            'Out' 
         ELSE
            'In' 
      END
      In_or_out, PICKUP_DATETIME, DROPOFF_DATETIME, 
      CASE
         WHEN
            TipPercentage < 0 
         THEN
            'No Tip' 
         WHEN
            TipPercentage BETWEEN 0 AND 5 
         THEN
            'Less but still a Tip' 
         WHEN
            TipPercentage BETWEEN 5 AND 10 
         THEN
            'Decent Tip' 
         WHEN
            TipPercentage > 10 
         THEN
            'Good Tip' 
         ELSE
            'Something different' 
      END
      AS TipRange, Hr, Wk, TripMonth, Trips, Tips, AverageSpeed, AverageDistance, TipPercentage, Tipbin 
   FROM
      (
         SELECT
            EXTRACT(HOUR 
         from
            TO_TIMESTAMP_NTZ(PICKUP_DATETIME)) As Hr,
            EXTRACT(DAYOFWEEK 
         from
            TO_TIMESTAMP_NTZ(PICKUP_DATETIME)) As Wk,
            Extract (MONTH 
         from
            TO_TIMESTAMP_NTZ(PICKUP_DATETIME)) As TripMonth,
            VENDOR_ID,
            passenger_count,
            trip_distance,
            PICKUP_LONGITUDE,
            PICKUP_LATITUDE,
            DROPOFF_LONGITUDE,
            DROPOFF_LATITUDE,
            payment_type,
            FARE_AMOUNT,
            TIP_AMOUNT,
            TOTAL_AMOUNT,
            Rate_code,
            PICKUP_DATETIME,
            DROPOFF_DATETIME,
            case
               when
                  TIP_AMOUNT = 0 
               then
                  'No Tip' 
               when
                  (
                     TIP_AMOUNT > 0 
                     and TIP_AMOUNT <= 5
                  )
               then
                  '0-5' 
               when
                  (
                     TIP_AMOUNT > 5 
                     and TIP_AMOUNT <= 10
                  )
               then
                  '5-10' 
               when
                  (
                     TIP_AMOUNT > 10 
                     and TIP_AMOUNT <= 20
                  )
               then
                  '10-20' 
               when
                  TIP_AMOUNT > 20 
               then
                  '> 20' 
               else
                  'other' 
            end
            as Tipbin, COUNT(*) Trips, SUM(TIP_AMOUNT) as Tips, ROUND(AVG(trip_distance / timediff(second, DROPOFF_DATETIME, PICKUP_DATETIME))*3600, 1) as AverageSpeed, ROUND(AVG(trip_distance), 1) as AverageDistance, ROUND(avg((TIP_AMOUNT) / (TOTAL_AMOUNT - TIP_AMOUNT))*100, 3) as TipPercentage 
         FROM
            DEMO_DB.PUBLIC.YELLOW_TAXI_2014 
         WHERE
            trip_distance > 0 
            AND FARE_AMOUNT / trip_distance BETWEEN 2 AND 10 
            AND DROPOFF_DATETIME > PICKUP_DATETIME 
         group by
            1, 2, 3, TIP_AMOUNT, TOTAL_AMOUNT, tipbin, VENDOR_ID, passenger_count, trip_distance, PICKUP_LONGITUDE, PICKUP_LATITUDE, DROPOFF_LONGITUDE, DROPOFF_LATITUDE, payment_type, FARE_AMOUNT, Rate_code, PICKUP_DATETIME, DROPOFF_DATETIME
      )
;
                                                                      
                                                                                                                                         
                                                                      
insert into
   demo_db.public.yellow_taxi 
   SELECT
      VENDORID,
      passenger_count,
      trip_distance,
      PICKUP_LONGITUDE,
      PICKUP_LATITUDE,
      DROPOFF_LONGITUDE,
      DROPOFF_LATITUDE,
      payment_type,
      FARE_AMOUNT,
      null extra,
      TIP_AMOUNT,
      TOTAL_AMOUNT,
      RATECODEID,
      CASE
         WHEN
            PICKUP_LONGITUDE > 41.4 
         THEN
            'Out' 
         WHEN
            DROPOFF_LATITUDE < 40.630 
         THEN
            'Out' 
         ELSE
            'In' 
      END
      In_or_out, TPEP_PICKUP_DATETIME, TPEP_DROPOFF_DATETIME, 
      CASE
         WHEN
            TipPercentage < 0 
         THEN
            'No Tip' 
         WHEN
            TipPercentage BETWEEN 0 AND 5 
         THEN
            'Less but still a Tip' 
         WHEN
            TipPercentage BETWEEN 5 AND 10 
         THEN
            'Decent Tip' 
         WHEN
            TipPercentage > 10 
         THEN
            'Good Tip' 
         ELSE
            'Something different' 
      END
      AS TipRange, Hr, Wk, TripMonth, Trips, Tips, AverageSpeed, AverageDistance, TipPercentage, Tipbin 
   FROM
      (
         SELECT
            EXTRACT(HOUR 
         from
            TO_TIMESTAMP_NTZ(TPEP_PICKUP_DATETIME)) As Hr,
            EXTRACT(DAYOFWEEK 
         from
            TO_TIMESTAMP_NTZ(TPEP_PICKUP_DATETIME)) As Wk,
            Extract (MONTH 
         from
            TO_TIMESTAMP_NTZ(TPEP_PICKUP_DATETIME)) As TripMonth,
            VENDORID,
            passenger_count,
            trip_distance,
            PICKUP_LONGITUDE,
            PICKUP_LATITUDE,
            DROPOFF_LONGITUDE,
            DROPOFF_LATITUDE,
            payment_type,
            FARE_AMOUNT,
            TIP_AMOUNT,
            TOTAL_AMOUNT,
            RATECODEID,
            TPEP_PICKUP_DATETIME,
            TPEP_DROPOFF_DATETIME,
            case
               when
                  TIP_AMOUNT = 0 
               then
                  'No Tip' 
               when
                  (
                     TIP_AMOUNT > 0 
                     and TIP_AMOUNT <= 5
                  )
               then
                  '0-5' 
               when
                  (
                     TIP_AMOUNT > 5 
                     and TIP_AMOUNT <= 10
                  )
               then
                  '5-10' 
               when
                  (
                     TIP_AMOUNT > 10 
                     and TIP_AMOUNT <= 20
                  )
               then
                  '10-20' 
               when
                  TIP_AMOUNT > 20 
               then
                  '> 20' 
               else
                  'other' 
            end
            as Tipbin, COUNT(*) Trips, SUM(TIP_AMOUNT) as Tips, ROUND(AVG(trip_distance / timediff(second, TPEP_DROPOFF_DATETIME, TPEP_PICKUP_DATETIME))*3600, 1) as AverageSpeed, ROUND(AVG(trip_distance), 1) as AverageDistance, ROUND(avg((TIP_AMOUNT) / NULLIF((TOTAL_AMOUNT - TIP_AMOUNT),0))*100, 3) as TipPercentage 
         FROM
            DEMO_DB.PUBLIC.YELLOW_TAXI_2015 
         WHERE
            trip_distance > 0 
            AND FARE_AMOUNT / trip_distance BETWEEN 2 AND 10 
            AND TPEP_DROPOFF_DATETIME > TPEP_PICKUP_DATETIME 
         group by
            1, 2, 3, TIP_AMOUNT, TOTAL_AMOUNT, tipbin, VENDORID, passenger_count, trip_distance, PICKUP_LONGITUDE, PICKUP_LATITUDE, DROPOFF_LONGITUDE, DROPOFF_LATITUDE, payment_type, FARE_AMOUNT, RATECODEID, TPEP_PICKUP_DATETIME, TPEP_DROPOFF_DATETIME
      )
;
                                                                      
                                                                                                                                          
                                                                      
insert into
   demo_db.public.yellow_taxi 
   SELECT
      VENDORID,
      passenger_count,
      trip_distance,
      PICKUP_LONGITUDE,
      PICKUP_LATITUDE,
      DROPOFF_LONGITUDE,
      DROPOFF_LATITUDE,
      payment_type,
      FARE_AMOUNT,
      null extra,
      TIP_AMOUNT,
      TOTAL_AMOUNT,
      RATECODEID,
      CASE
         WHEN
            PICKUP_LONGITUDE > 41.4 
         THEN
            'Out' 
         WHEN
            DROPOFF_LATITUDE < 40.630 
         THEN
            'Out' 
         ELSE
            'In' 
      END
      In_or_out, TPEP_PICKUP_DATETIME, TPEP_DROPOFF_DATETIME, 
      CASE
         WHEN
            TipPercentage < 0 
         THEN
            'No Tip' 
         WHEN
            TipPercentage BETWEEN 0 AND 5 
         THEN
            'Less but still a Tip' 
         WHEN
            TipPercentage BETWEEN 5 AND 10 
         THEN
            'Decent Tip' 
         WHEN
            TipPercentage > 10 
         THEN
            'Good Tip' 
         ELSE
            'Something different' 
      END
      AS TipRange, Hr, Wk, TripMonth, Trips, Tips, AverageSpeed, AverageDistance, TipPercentage, Tipbin 
   FROM
      (
         SELECT
            EXTRACT(HOUR 
         from
            TO_TIMESTAMP_NTZ(TPEP_PICKUP_DATETIME)) As Hr,
            EXTRACT(DAYOFWEEK 
         from
            TO_TIMESTAMP_NTZ(TPEP_PICKUP_DATETIME)) As Wk,
            Extract (MONTH 
         from
            TO_TIMESTAMP_NTZ(TPEP_PICKUP_DATETIME)) As TripMonth,
            VENDORID,
            passenger_count,
            trip_distance,
            PICKUP_LONGITUDE,
            PICKUP_LATITUDE,
            DROPOFF_LONGITUDE,
            DROPOFF_LATITUDE,
            payment_type,
            FARE_AMOUNT,
            TIP_AMOUNT,
            TOTAL_AMOUNT,
            RATECODEID,
            TPEP_PICKUP_DATETIME,
            TPEP_DROPOFF_DATETIME,
            case
               when
                  TIP_AMOUNT = 0 
               then
                  'No Tip' 
               when
                  (
                     TIP_AMOUNT > 0 
                     and TIP_AMOUNT <= 5
                  )
               then
                  '0-5' 
               when
                  (
                     TIP_AMOUNT > 5 
                     and TIP_AMOUNT <= 10
                  )
               then
                  '5-10' 
               when
                  (
                     TIP_AMOUNT > 10 
                     and TIP_AMOUNT <= 20
                  )
               then
                  '10-20' 
               when
                  TIP_AMOUNT > 20 
               then
                  '> 20' 
               else
                  'other' 
            end
            as Tipbin, COUNT(*) Trips, SUM(TIP_AMOUNT) as Tips, ROUND(AVG(trip_distance / timediff(second, TPEP_DROPOFF_DATETIME, TPEP_PICKUP_DATETIME))*3600, 1) as AverageSpeed, ROUND(AVG(trip_distance), 1) as AverageDistance, ROUND(avg((TIP_AMOUNT) / NULLIF((TOTAL_AMOUNT - TIP_AMOUNT),0))*100, 3) as TipPercentage 
         FROM
            DEMO_DB.PUBLIC.YELLOW_TAXI_2016 
         WHERE
            trip_distance > 0 
            AND FARE_AMOUNT / trip_distance BETWEEN 2 AND 10 
            AND TPEP_DROPOFF_DATETIME > TPEP_PICKUP_DATETIME 
         group by
            1, 2, 3, TIP_AMOUNT, TOTAL_AMOUNT, tipbin, VENDORID, passenger_count, trip_distance, PICKUP_LONGITUDE, PICKUP_LATITUDE, DROPOFF_LONGITUDE, DROPOFF_LATITUDE, payment_type, FARE_AMOUNT, RATECODEID, TPEP_PICKUP_DATETIME, TPEP_DROPOFF_DATETIME
      )
;
                                                                                                                                         
insert into
   demo_db.public.yellow_taxi 
   SELECT
      VendorID,
      passenger_count,
      trip_distance,
      CASE
         WHEN
            PULocationID = B.LocationID 
         THEN
            B.Latitude 
      END
      pickup_longitude, 
      CASE
         WHEN
            PULocationID = B.LocationID 
         THEN
            B.Longitude 
      END
      pickup_latitude, 
      CASE
         WHEN
            DOLocationID = B.LocationID 
         THEN
            B.Longitude 
      END
      dropoff_longitude, 
      CASE
         WHEN
            DOLocationID = B.LocationID 
         THEN
            B.Latitude 
      END
      dropoff_latitude, payment_type, fare_amount, extra, tip_amount, total_amount, ratecodeid, tpep_pickup_datetime, tpep_dropoff_datetime, 
      CASE
         WHEN
            dropoff_latitude > 41.4 
         THEN
            'Out' 
         WHEN
            dropoff_latitude < 40.630 
         THEN
            'Out' 
         ELSE
            'In' 
      END
      In_or_out, 
      CASE
         WHEN
            TipPercentage < 0 
         THEN
            'No Tip' 
         WHEN
            TipPercentage BETWEEN 0 AND 5 
         THEN
            'Less but still a Tip' 
         WHEN
            TipPercentage BETWEEN 5 AND 10 
         THEN
            'Decent Tip' 
         WHEN
            TipPercentage > 10 
         THEN
            'Good Tip' 
         ELSE
            'Something different' 
      END
      AS TipRange, Hr, Wk, TripMonth, Trips, Tips, AverageSpeed, AverageDistance, TipPercentage, Tipbin 
   FROM
      (
         SELECT
            EXTRACT(HOUR 
         from
            TO_TIMESTAMP_NTZ(tpep_pickup_datetime)) As Hr,
            EXTRACT(DAYOFWEEK 
         from
            TO_TIMESTAMP_NTZ(tpep_pickup_datetime)) As Wk,
            Extract (MONTH 
         from
            TO_TIMESTAMP_NTZ(tpep_pickup_datetime)) As TripMonth,
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
            case
               when
                  tip_amount = 0 
               then
                  'No Tip' 
               when
                  (
                     tip_amount > 0 
                     and tip_amount <= 5
                  )
               then
                  '0-5' 
               when
                  (
                     tip_amount > 5 
                     and tip_amount <= 10
                  )
               then
                  '5-10' 
               when
                  (
                     tip_amount > 10 
                     and tip_amount <= 20
                  )
               then
                  '10-20' 
               when
                  tip_amount > 20 
               then
                  '> 20' 
               else
                  'other' 
            end
            as Tipbin, COUNT(*) Trips, SUM(tip_amount) as Tips, ROUND(AVG(trip_distance / timediff(second, tpep_dropoff_datetime, tpep_pickup_datetime))*3600, 1) as AverageSpeed, ROUND(AVG(trip_distance), 1) as AverageDistance, ROUND(avg((tip_amount) / NULLIF((TOTAL_AMOUNT - TIP_AMOUNT),0))*100, 3) as TipPercentage 
         FROM
            DEMO_DB.PUBLIC.YELLOW_TAXI_2017 
         WHERE
            trip_distance > 0 
            AND fare_amount / trip_distance BETWEEN 2 AND 10 
            AND tpep_dropoff_datetime > tpep_pickup_datetime 
         group by
            1, 2, 3, tip_amount, total_amount, tipbin, VendorID, passenger_count, trip_distance, payment_type, fare_amount, extra, tip_amount, total_amount, ratecodeid, PULocationID, DOLocationID, tpep_pickup_datetime, tpep_dropoff_datetime
      )
      A 
      LEFT JOIN
         demo_db.public.taxi_zones B 
         ON A.PULocationID = B.LocationID 
         AND A.DOLocationID = B.LocationID;
                                                                                                                                            
                                                                      
insert into
   demo_db.public.yellow_taxi 
   SELECT
      VendorID,
      passenger_count,
      trip_distance,
      CASE
         WHEN
            PULocationID = B.LocationID 
         THEN
            B.Latitude 
      END
      pickup_longitude, 
      CASE
         WHEN
            PULocationID = B.LocationID 
         THEN
            B.Longitude 
      END
      pickup_latitude, 
      CASE
         WHEN
            DOLocationID = B.LocationID 
         THEN
            B.Longitude 
      END
      dropoff_longitude, 
      CASE
         WHEN
            DOLocationID = B.LocationID 
         THEN
            B.Latitude 
      END
      dropoff_latitude, payment_type, fare_amount, extra, tip_amount, total_amount, ratecodeid, tpep_pickup_datetime, tpep_dropoff_datetime, 
      CASE
         WHEN
            dropoff_latitude > 41.4 
         THEN
            'Out' 
         WHEN
            dropoff_latitude < 40.630 
         THEN
            'Out' 
         ELSE
            'In' 
      END
      In_or_out, 
      CASE
         WHEN
            TipPercentage < 0 
         THEN
            'No Tip' 
         WHEN
            TipPercentage BETWEEN 0 AND 5 
         THEN
            'Less but still a Tip' 
         WHEN
            TipPercentage BETWEEN 5 AND 10 
         THEN
            'Decent Tip' 
         WHEN
            TipPercentage > 10 
         THEN
            'Good Tip' 
         ELSE
            'Something different' 
      END
      AS TipRange, Hr, Wk, TripMonth, Trips, Tips, AverageSpeed, AverageDistance, TipPercentage, Tipbin 
   FROM
      (
         SELECT
            EXTRACT(HOUR 
         from
            TO_TIMESTAMP_NTZ(tpep_pickup_datetime)) As Hr,
            EXTRACT(DAYOFWEEK 
         from
            TO_TIMESTAMP_NTZ(tpep_pickup_datetime)) As Wk,
            Extract (MONTH 
         from
            TO_TIMESTAMP_NTZ(tpep_pickup_datetime)) As TripMonth,
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
            case
               when
                  tip_amount = 0 
               then
                  'No Tip' 
               when
                  (
                     tip_amount > 0 
                     and tip_amount <= 5
                  )
               then
                  '0-5' 
               when
                  (
                     tip_amount > 5 
                     and tip_amount <= 10
                  )
               then
                  '5-10' 
               when
                  (
                     tip_amount > 10 
                     and tip_amount <= 20
                  )
               then
                  '10-20' 
               when
                  tip_amount > 20 
               then
                  '> 20' 
               else
                  'other' 
            end
            as Tipbin, COUNT(*) Trips, SUM(tip_amount) as Tips, ROUND(AVG(trip_distance / timediff(second, tpep_dropoff_datetime, tpep_pickup_datetime))*3600, 1) as AverageSpeed, ROUND(AVG(trip_distance), 1) as AverageDistance, ROUND(avg((tip_amount) / NULLIF((TOTAL_AMOUNT - TIP_AMOUNT),0))*100, 3) as TipPercentage 
         FROM
            DEMO_DB.PUBLIC.YELLOW_TAXI_2018 
         WHERE
            trip_distance > 0 
            AND fare_amount / trip_distance BETWEEN 2 AND 10 
            AND tpep_dropoff_datetime > tpep_pickup_datetime 
         group by
            1, 2, 3, tip_amount, total_amount, tipbin, VendorID, passenger_count, trip_distance, payment_type, fare_amount, extra, tip_amount, total_amount, ratecodeid, PULocationID, DOLocationID, tpep_pickup_datetime, tpep_dropoff_datetime
      )
      A 
      LEFT JOIN
         demo_db.public.taxi_zones B 
         ON A.PULocationID = B.LocationID 
         AND A.DOLocationID = B.LocationID;
                                                                                                                                         
                                                                      
insert into
   demo_db.public.yellow_taxi 
   SELECT
      VendorID,
      passenger_count,
      trip_distance,
      CASE
         WHEN
            PULocationID = B.LocationID 
         THEN
            B.Latitude 
      END
      pickup_longitude, 
      CASE
         WHEN
            PULocationID = B.LocationID 
         THEN
            B.Longitude 
      END
      pickup_latitude, 
      CASE
         WHEN
            DOLocationID = B.LocationID 
         THEN
            B.Longitude 
      END
      dropoff_longitude, 
      CASE
         WHEN
            DOLocationID = B.LocationID 
         THEN
            B.Latitude 
      END
      dropoff_latitude, payment_type, fare_amount, extra, tip_amount, total_amount, ratecodeid, tpep_pickup_datetime, tpep_dropoff_datetime, 
      CASE
         WHEN
            dropoff_latitude > 41.4 
         THEN
            'Out' 
         WHEN
            dropoff_latitude < 40.630 
         THEN
            'Out' 
         ELSE
            'In' 
      END
      In_or_out, 
      CASE
         WHEN
            TipPercentage < 0 
         THEN
            'No Tip' 
         WHEN
            TipPercentage BETWEEN 0 AND 5 
         THEN
            'Less but still a Tip' 
         WHEN
            TipPercentage BETWEEN 5 AND 10 
         THEN
            'Decent Tip' 
         WHEN
            TipPercentage > 10 
         THEN
            'Good Tip' 
         ELSE
            'Something different' 
      END
      AS TipRange, Hr, Wk, TripMonth, Trips, Tips, AverageSpeed, AverageDistance, TipPercentage, Tipbin 
   FROM
      (
         SELECT
            EXTRACT(HOUR 
         from
            TRY_TO_TIMESTAMP(tpep_pickup_datetime)) As Hr,
            EXTRACT(DAYOFWEEK 
         from
            TRY_TO_TIMESTAMP(tpep_pickup_datetime)) As Wk,
            Extract (MONTH 
         from
            TRY_TO_TIMESTAMP(tpep_pickup_datetime)) As TripMonth,
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
            case
               when
                  tip_amount = 0 
               then
                  'No Tip' 
               when
                  (
                     tip_amount > 0 
                     and tip_amount <= 5
                  )
               then
                  '0-5' 
               when
                  (
                     tip_amount > 5 
                     and tip_amount <= 10
                  )
               then
                  '5-10' 
               when
                  (
                     tip_amount > 10 
                     and tip_amount <= 20
                  )
               then
                  '10-20' 
               when
                  tip_amount > 20 
               then
                  '> 20' 
               else
                  'other' 
            end
            as Tipbin, COUNT(*) Trips, SUM(tip_amount) as Tips, ROUND(AVG(trip_distance / timediff(second, TRY_TO_TIMESTAMP(tpep_dropoff_datetime), TRY_TO_TIMESTAMP(tpep_pickup_datetime)))*3600, 1) as AverageSpeed, ROUND(AVG(trip_distance), 1) as AverageDistance, ROUND(avg((tip_amount) / NULLIF((TOTAL_AMOUNT - TIP_AMOUNT),0))*100, 3) as TipPercentage 
         FROM
            DEMO_DB.PUBLIC.YELLOW_TAXI_2019 
         WHERE
            trip_distance > 0 
            AND fare_amount / trip_distance BETWEEN 2 AND 10 
            AND tpep_dropoff_datetime > tpep_pickup_datetime 
         group by
            1, 2, 3, tip_amount, total_amount, tipbin, VendorID, passenger_count, trip_distance, payment_type, fare_amount, extra, tip_amount, total_amount, ratecodeid, PULocationID, DOLocationID, tpep_pickup_datetime, tpep_dropoff_datetime
      )
      A 
      LEFT JOIN
         demo_db.public.taxi_zones B 
         ON A.PULocationID = B.LocationID 
         AND A.DOLocationID = B.LocationID;
                                                                                                                                                   
insert into
   demo_db.public.yellow_taxi 
   SELECT
      VendorID,
      passenger_count,
      trip_distance,
      CASE
         WHEN
            PULocationID = B.LocationID 
         THEN
            B.Latitude 
      END
      pickup_longitude, 
      CASE
         WHEN
            PULocationID = B.LocationID 
         THEN
            B.Longitude 
      END
      pickup_latitude, 
      CASE
         WHEN
            DOLocationID = B.LocationID 
         THEN
            B.Longitude 
      END
      dropoff_longitude, 
      CASE
         WHEN
            DOLocationID = B.LocationID 
         THEN
            B.Latitude 
      END
      dropoff_latitude, payment_type, fare_amount, extra, tip_amount, total_amount, ratecodeid, tpep_pickup_datetime, tpep_dropoff_datetime, 
      CASE
         WHEN
            dropoff_latitude > 41.4 
         THEN
            'Out' 
         WHEN
            dropoff_latitude < 40.630 
         THEN
            'Out' 
         ELSE
            'In' 
      END
      In_or_out, 
      CASE
         WHEN
            TipPercentage < 0 
         THEN
            'No Tip' 
         WHEN
            TipPercentage BETWEEN 0 AND 5 
         THEN
            'Less but still a Tip' 
         WHEN
            TipPercentage BETWEEN 5 AND 10 
         THEN
            'Decent Tip' 
         WHEN
            TipPercentage > 10 
         THEN
            'Good Tip' 
         ELSE
            'Something different' 
      END
      AS TipRange, Hr, Wk, TripMonth, Trips, Tips, AverageSpeed, AverageDistance, TipPercentage, Tipbin 
   FROM
      (
         SELECT
            EXTRACT(HOUR 
         from
            TRY_TO_TIMESTAMP(tpep_pickup_datetime)) As Hr,
            EXTRACT(DAYOFWEEK 
         from
            TRY_TO_TIMESTAMP(tpep_pickup_datetime)) As Wk,
            Extract (MONTH 
         from
            TRY_TO_TIMESTAMP(tpep_pickup_datetime)) As TripMonth,
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
            case
               when
                  tip_amount = 0 
               then
                  'No Tip' 
               when
                  (
                     tip_amount > 0 
                     and tip_amount <= 5
                  )
               then
                  '0-5' 
               when
                  (
                     tip_amount > 5 
                     and tip_amount <= 10
                  )
               then
                  '5-10' 
               when
                  (
                     tip_amount > 10 
                     and tip_amount <= 20
                  )
               then
                  '10-20' 
               when
                  tip_amount > 20 
               then
                  '> 20' 
               else
                  'other' 
            end
            as Tipbin, COUNT(*) Trips, SUM(tip_amount) as Tips, ROUND(AVG(trip_distance / timediff(second, TRY_TO_TIMESTAMP(tpep_dropoff_datetime), TRY_TO_TIMESTAMP(tpep_pickup_datetime)))*3600, 1) as AverageSpeed, ROUND(AVG(trip_distance), 1) as AverageDistance, ROUND(avg((tip_amount) / NULLIF((TOTAL_AMOUNT - TIP_AMOUNT),0))*100, 3) as TipPercentage 
         FROM
            DEMO_DB.PUBLIC.YELLOW_TAXI_2020 
         WHERE
            trip_distance > 0 
            AND fare_amount / trip_distance BETWEEN 2 AND 10 
            AND tpep_dropoff_datetime > tpep_pickup_datetime 
         group by
            1, 2, 3, tip_amount, total_amount, tipbin, VendorID, passenger_count, trip_distance, payment_type, fare_amount, extra, tip_amount, total_amount, ratecodeid, PULocationID, DOLocationID, tpep_pickup_datetime, tpep_dropoff_datetime
      )
      A 
      LEFT JOIN
         demo_db.public.taxi_zones B 
         ON A.PULocationID = B.LocationID 
         AND A.DOLocationID = B.LocationID;
                                                                          
                                                                          
                                                                          
create 
or replace view nyc_traffic_weather_vw as 
SELECT
   VENDOR_NAME_OR_ID,
   passenger_count,
   trip_distance,
   pickup_longitude,
   pickup_latitude,
   dropoff_longitude,
   dropoff_latitude,
   TRY_TO_TIMESTAMP(TRIP_PICKUP_DATETIME) TRIP_PICKUP_DATETIME,
   TRY_TO_TIMESTAMP(TRIP_DROPOFF_DATETIME) TRIP_DROPOFF_DATETIME,
   payment_type,
   fare_amount,
   extra,
   tip_amount,
   total_amount,
   ratecodeid,
   In_or_out,
   TipRange,
   Hr,
   Wk,
   TripMonth,
   Trips,
   Tips,
   AverageSpeed,
   AverageDistance,
   TipPercentage,
   Tipbin,
   weather.PRCP rain,
   weather.SNWD snow_depth_mm,
   weather.SNOW snowfall_mm,
   weather.TMAX max_temp,
   weather.TMIN min_temp,
   weather.AWND wind 
FROM
   DEMO_DB.PUBLIC.YELLOW_TAXI A 
   LEFT JOIN
      DEMO_DB.PUBLIC.NYC_WEATHER weather 
      ON weather.date = TRY_TO_TIMESTAMP(A.TRIP_PICKUP_DATETIME)::date;
      
      
ALTER WAREHOUSE DATA_LOAD SUSPEND
