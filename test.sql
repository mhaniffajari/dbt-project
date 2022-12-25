select * from {{ ref('fct_undocumented_models') }}

select * from {{ ref('fct_documentation_coverage') }}