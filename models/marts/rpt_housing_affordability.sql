with base as (
    select
        f.date_id as year,
        f.location_id,
        l.postal_code,
        l.municipality,
        l.area_name,
        f.median_income,
        f.avg_price_per_m2,
        f.household_count,
        f.has_price_value
    from {{ ref('fct_housing_metrics') }} f
    left join {{ ref('dim_location') }} l
        on f.location_id = l.location_id
),

baseline as (
    select
        postal_code,
        median_income as income_2015,
        avg_price_per_m2 as price_2015
    from base
    where year = 2015
),

final as (
    select
        b.year,
        b.postal_code,
        b.municipality,
        b.area_name,
        b.household_count,
        b.median_income,
        b.avg_price_per_m2,
        b.has_price_value,

        -- 1. income growth relative to 2015
        case
            when bl.income_2015 is not null and bl.income_2015 != 0
            then round(
                (b.median_income - bl.income_2015) / bl.income_2015 * 100
            , 2)
        end as income_growth_vs_2015_pct,

        -- 2. price growth relative to 2015
        case
            when bl.price_2015 is not null and bl.price_2015 != 0
            then round(
                (b.avg_price_per_m2 - bl.price_2015) / bl.price_2015 * 100
            , 2)
        end as price_growth_vs_2015_pct,

        -- 3. gap between price growth and income growth vs 2015
        -- positive = prices grew faster than income (less affordable)
        -- negative = income grew faster than prices (more affordable)
        case
            when bl.income_2015 is not null and bl.price_2015 is not null
            and bl.income_2015 != 0 and bl.price_2015 != 0
            then round(
                ((b.avg_price_per_m2 - bl.price_2015) / bl.price_2015 * 100)
                -
                ((b.median_income - bl.income_2015) / bl.income_2015 * 100)
            , 2)
        end as price_income_growth_gap,

        -- 4. price to income ratio
        case
            when b.median_income is not null and b.median_income != 0
            then round(
                b.avg_price_per_m2 / b.median_income
            , 4)
        end as price_to_income_ratio,

        -- 5. affordability level
        case
            when b.avg_price_per_m2 is null or b.median_income is null
            then null
            when round(b.avg_price_per_m2 / b.median_income, 4) >
            avg(round(b.avg_price_per_m2 / b.median_income, 4)) over (
            partition by b.year
                )           
            then 'Less Affordable (Above Avg)'
            else 'More Affordable (Below Avg)'
        end as affordability_level

    from base b
    left join baseline bl on b.postal_code = bl.postal_code
)

select * from final
order by year, postal_code