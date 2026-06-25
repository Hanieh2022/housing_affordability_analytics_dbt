with cleaned as (
    select
        {{ replace_blanks_with_null(source('raw', 'owned_house_price'), 'i') }}
    from {{ source('raw', 'owned_house_price') }} as i
),

parsed as (
    select
        *,
        {{ parse_postal_area('c', 'Postal code') }}
    from cleaned as c
)

{{ avg_price_by_year_postal('parsed') }}