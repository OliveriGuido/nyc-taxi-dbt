-- daily_metrics: incremental es tabla
{{
    config(
        materialized='incremental', 
        unique_key='pickup_date'
    )
}}

with trips as (

    select * from {{ ref('stg_trips') }}

    {% if is_incremental() %} -- solo para corridas incrementales, no para la primera corrida 
    where pickup_date >= (select max(pickup_date) from {{ this }}) --this es daily_metrics, es traer solo las fechas mayores o iguales al máximo que ya tengo guardado
    {% endif %}

),

daily as (

    select
        pickup_date,
        count(*)                          as total_trips,
        round(sum(fare_amount), 2)        as total_revenue,
        round(avg(fare_amount), 2)        as avg_fare,
        round(avg(trip_distance), 2)      as avg_distance_miles,
        round(avg(trip_duration_min), 2)  as avg_duration_min
    from trips
    group by pickup_date

)

select * from daily