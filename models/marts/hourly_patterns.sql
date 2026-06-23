with trips as (

    select * from {{ ref('stg_trips') }}

),

hourly as (

    select
        pickup_hour,
        count(*)                          as total_trips,
        round(avg(fare_amount), 2)        as avg_fare,
        round(avg(trip_duration_min), 2)  as avg_duration_min
    from trips
    group by pickup_hour

)

select * from hourly