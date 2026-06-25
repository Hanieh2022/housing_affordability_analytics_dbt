with locations as (
    select postal_code, area_name, municipality
    from {{ ref('stg_household_population') }}

    union

    select postal_code, area_name, municipality
    from {{ ref('stg_income') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['postal_code']) }} as location_id,
    postal_code,
    area_name,
    municipality
from locations