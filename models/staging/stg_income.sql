
with cleaned as (
    select
        {{ replace_blanks_with_null(source('raw', 'income'), 'i') }}
    from {{ source('raw', 'income') }} as i
),

unpivoted as (
    select
        {{ parse_postal_area('c', 'Postal code area') }},
        unpvt.year::int as year,
        unpvt.value::numeric as median_income
    from cleaned as c
    {{ unpivot_year_columns(source('raw', 'income'), 'c') }}
)

select * from unpivoted