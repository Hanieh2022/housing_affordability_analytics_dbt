{% macro parse_postal_area(table_alias, column_name) %}
    cast(left({{ table_alias }}."{{ column_name }}", 5) as text) as postal_code,

    cast(regexp_replace(
        {{ table_alias }}."{{ column_name }}",
        '.*\(([^)]+)\).*',
        '\1'
    ) as text) as municipality,

    cast(trim(
        regexp_replace(
            regexp_replace(
                {{ table_alias }}."{{ column_name }}",
                '\s*\([^)]*\)\s*$',
                ''
            ),
            '^\d{5}\s+',
            ''
        )
    ) as text) as area_name
{% endmacro %}