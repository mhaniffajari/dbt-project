{% set old_etl_relation=adapter.get_relation(
      database="dbt-tutorial",
      schema="jaffle_shop",
      identifier="customers"
) -%}

{% set dbt_relation=ref('stg_customers') %}

{{ audit_helper.compare_relation_columns(
    a_relation=old_etl_relation,
    b_relation=dbt_relation
) }}