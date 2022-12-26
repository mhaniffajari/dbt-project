 with a_query as (
    
    select id as order_id, user_id as customer_id, order_date, status from dbt-tutorial.jaffle_shop.orders

),

b_query as (
    
    select * from `dbt-project-2348903`.`dbt_project`.`stg_orders`

),

joined as (
    select
        coalesce(a_query.order_id, b_query.order_id) as order_id,
        a_query.status as a_query_value,
        b_query.status as b_query_value,
        case
            when a_query.status = b_query.status then '✅: perfect match'
            when a_query.status is null and b_query.status is null then '✅: both are null'
            when a_query.order_id is null then '🤷: ‍missing from a'
            when b_query.order_id is null then '🤷: missing from b'
            when a_query.status is null then '🤷: value is null in a only'
            when b_query.status is null then '🤷: value is null in b only'
            when a_query.status != b_query.status then '🙅: ‍values do not match'
            else 'unknown' -- this should never happen
        end as match_status,
        case
            when a_query.status = b_query.status then 0
            when a_query.status is null and b_query.status is null then 1
            when a_query.order_id is null then 2
            when b_query.order_id is null then 3
            when a_query.status is null then 4
            when b_query.status is null then 5
            when a_query.status != b_query.status then 6
            else 7 -- this should never happen
        end as match_order

    from a_query

    full outer join b_query on a_query.order_id = b_query.order_id
),

aggregated as (
    select
        'status' as column_name,
        match_status,
        match_order,
        count(*) as count_records
    from joined

    group by column_name, match_status, match_order
)

select
    column_name,
    match_status,
    count_records,
    round(100.0 * count_records / sum(count_records) over (), 2) as percent_of_total

from aggregated

order by match_order
