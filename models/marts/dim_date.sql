with years as (
    select distinct cast(year as integer) from {{ ref('stg_household_population') }}
    union
    select distinct cast(year as integer) from {{ ref('stg_income') }}
    union
    select distinct cast(year as integer) from {{ ref('stg_owned_house_price') }}
)

select
    year as date_id   -- year acts as the key
from years