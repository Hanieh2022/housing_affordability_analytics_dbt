{% macro replace_blanks_with_null(source_relation, table_alias) %}
    {%- set columns = adapter.get_columns_in_relation(source_relation) -%}

    {%- for column in columns %}
        case
            when trim({{ table_alias }}."{{ column.name }}"::text) in ('', '.', '...') 
                then null
            else trim({{ table_alias }}."{{ column.name }}"::text)
        end as "{{ column.name }}"
        {%- if not loop.last %},{% endif %}
    {%- endfor %}
{% endmacro %}
