# data-engineering-zoomcamp

## Module 1 Homework: Docker & SQL

### Question 1: Understanding Docker First Run
Run docker with the python:3.12.8 image in an interactive mode, use the entrypoint bash.

--> pip 24.3.1 from /usr/local/lib/python3.12/site-packages/pip (python 3.12)
    docker run -it python:3.12.8 bash
    pip --version

### Question 2. Understanding Docker networking and docker-compose
Given the following docker-compose.yaml, what is the hostname and port that pgadmin should use to connect to the postgres database?

--> db:5432


### Question 3. Trip Segmentation Count
During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, respectively, happened:
Up to 1 mile
In between 1 (exclusive) and 3 miles (inclusive),
In between 3 (exclusive) and 7 miles (inclusive),
In between 7 (exclusive) and 10 miles (inclusive),
Over 10 miles

--> 104802 , 198924 , 109603 , 27678 , 35189

SELECT COUNT(lpep_pickup_datetime)
FROM public.green_taxi_data
WHERE lpep_pickup_datetime >= '2019-10-01'
  AND lpep_pickup_datetime < '2019-11-01'
  AND lpep_dropoff_datetime >= '2019-10-01'
  AND lpep_dropoff_datetime < '2019-11-01'
  AND trip_distance > 10

-------------------------------------------------------------

### Question 4. Longest trip for each day
Which was the pick up day with the longest trip distance? Use the pick up time for your calculations.

--> 2019-10-31
SELECT lpep_pickup_datetime
FROM public.green_taxi_data
ORDER BY trip_distance DESC 
LIMIT 1

### Question 5. Three biggest pickup zones
Which were the top pickup locations with over 13,000 in total_amount (across all trips) for 2019-10-18?

--> East Harlem North, East Harlem South, Morningside Heights
SELECT t2."Zone"
FROM public.taxi_zone_lookup t2
JOIN (
    SELECT "PULocationID", SUM(total_amount) AS total_amount
    FROM public.green_taxi_data
    WHERE DATE(lpep_pickup_datetime) = '2019-10-18'
    GROUP BY "PULocationID"
    HAVING SUM(total_amount) > 13000
) AS t1
ON t1."PULocationID" = t2."LocationID";



### Question 6. Largest tip
For the passengers picked up in October 2019 in the zone name "East Harlem North" which was the drop off zone that had the largest tip?
Note: it's tip , not trip
We need the name of the zone, not the ID.

 <!-- East Harlem North
SELECT MAX(tip_amount) from public.green_taxi_data t1
JOIN public.taxi_zone_lookup t2
ON t1."PULocationID" = t2."LocationID" AND t1."DOLocationID" = t2."LocationID"
WHERE t1.lpep_pickup_datetime >= '2019-10-01'
AND  t1.lpep_pickup_datetime < '2019-11-01'
AND t2."Zone" = 'East Harlem North'  "old Answer" -->

--> JFK Airport
WITH passengers_in_october AS (SELECT t1."DOLocationID" , t1.tip_amount
FROM public.green_taxi_data t1
JOIN public.taxi_zone_lookup t2
ON t1."PULocationID" = t2."LocationID"
WHERE t1.lpep_pickup_datetime >= '2019-10-01'
AND  t1.lpep_pickup_datetime < '2019-11-01'
AND t2."Zone" = 'East Harlem North')

SELECT taxi_zone_lookup."Zone"
FROM passengers_in_october
JOIN public.taxi_zone_lookup 
ON passengers_in_october."DOLocationID" = taxi_zone_lookup."LocationID"
GROUP BY taxi_zone_lookup."Zone"
ORDER BY MAX(passengers_in_october.tip_amount) DESC
LIMIT 1

### Question 7. Terraform Workflow
Which of the following sequences, respectively, describes the workflow for:

Downloading the provider plugins and setting up backend,
Generating proposed changes and auto-executing the plan
Remove all resources managed by terraform`

--> terraform init, terraform apply -auto-approve, terraform destroy
