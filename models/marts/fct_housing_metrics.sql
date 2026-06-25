with household as (
    select year, postal_code, household_count
    from {{ ref('stg_household_population') }}
),

income as (
    select year, postal_code, median_income
    from {{ ref('stg_income') }}
),

price as (
    select year, postal_code, avg_price_per_m2
    from {{ ref('stg_owned_house_price') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['h.year', 'h.postal_code']) }} as metric_id,
    {{ dbt_utils.generate_surrogate_key(['h.postal_code']) }} as location_id,
    h.year as date_id,
    h.household_count,
    i.median_income,
    p.avg_price_per_m2, -- null where no data exists
    case
        when p.avg_price_per_m2 is null then false
        else true
    end as has_price_value
from household h
left join income i using (year, postal_code)
left join price p using (year, postal_code)