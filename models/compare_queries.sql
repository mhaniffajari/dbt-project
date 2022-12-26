{# in dbt Develop #}

{% set old_fct_orders_query %}
    select id as order_id, user_id as customer_id, order_date, status from dbt-tutorial.jaffle_shop.orders
{% endset %}

{% set new_fct_orders_query %}
    select * from {{ ref('stg_orders') }}
{% endset %}

{{ audit_helper.compare_queries(
    a_query=old_fct_orders_query,
    b_query=new_fct_orders_query,
    primary_key="order_id"
) }}

