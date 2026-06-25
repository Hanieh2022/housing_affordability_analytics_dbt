with cleaned as (
    select
        {{ replace_blanks_with_null(source('raw', 'household_population'), 'i') }}
    from {{ source('raw', 'household_population') }} as i
),

unpivoted as (
    select
        {{ parse_postal_area('c', 'Postal code area') }},
        unpvt.year::int as year,
        unpvt.value::numeric as household_count
    from cleaned as c
    {{ unpivot_year_columns(source('raw', 'household_population'), 'c') }}
)

select * from unpivoted