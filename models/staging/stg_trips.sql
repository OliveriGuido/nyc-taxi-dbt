with source as (

    select * from {{ source('nyctaxi', 'trips') }}

),

cleaned as (

    select
        tpep_pickup_datetime        as pickup_ts,
        tpep_dropoff_datetime       as dropoff_ts,
        date(tpep_pickup_datetime)  as pickup_date,
        hour(tpep_pickup_datetime)  as pickup_hour,
        trip_distance,
        fare_amount,
        pickup_zip,
        dropoff_zip,
        -- duración del viaje en minutos
        (unix_timestamp(tpep_dropoff_datetime) - unix_timestamp(tpep_pickup_datetime)) / 60.0 as trip_duration_min

    from source

    where trip_distance > 0
      and fare_amount > 0
      and fare_amount < 500
      and tpep_pickup_datetime < tpep_dropoff_datetime

)

select * from cleaned
