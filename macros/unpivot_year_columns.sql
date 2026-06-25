{% macro unpivot_year_columns(source_relation, table_alias, value_column_name='value') %}
    {%- set columns = adapter.get_columns_in_relation(source_relation) -%}
    {%- set year_columns = [] -%}

    {%- for column in columns -%}
        {%- set column_name = column.name | trim -%}
        {%- if column_name | length == 4 and column_name.isdigit() -%}
            {%- do year_columns.append(column_name) -%}
        {%- endif -%}
    {%- endfor -%}

    cross join lateral (
        values
            {%- for year in year_columns %}
                (
                    cast('{{ year }}' as integer),
                    cast({{ table_alias }}."{{ year }}" as numeric)
                )
                {%- if not loop.last %},{% endif %}
            {%- endfor %}
    ) as unpvt(year, {{ value_column_name }})
{% endmacro %}