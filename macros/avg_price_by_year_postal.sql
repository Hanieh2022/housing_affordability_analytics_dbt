{% macro avg_price_by_year_postal(table) %}
select
    cast("Year" as integer) as year,
    cast(postal_code as text) as postal_code,
    round(avg("Price per square meter (EUR/m2)"::numeric), 2) as avg_price_per_m2
from {{ table }}
group by
    cast("Year" as integer),
    cast(postal_code as text)
{% endmacro %}