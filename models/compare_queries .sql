{% set old_etl_relation_query %}
    select id as order_id, user_id as customer_id, order_date, status from dbt-tutorial.jaffle_shop.orders
{% endset %}

{% set new_etl_relation_query %}
    select * from {{ ref('stg_orders') }}
{% endset %}

{% set audit_query = audit_helper.compare_column_values(
    a_query=old_etl_relation_query,
    b_query=new_etl_relation_query,
    primary_key="order_id",
    column_to_compare="status"
) %}

{% set audit_results = run_query(audit_query) %}