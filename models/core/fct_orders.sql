{% set payment_methods = ['credit_card', 'coupon', 'bank_transfer', 'gift_card'] %}

with orders as (

    select * from {{ ref('stg_orders') }}

),

order_payments as (

    select * from {{ ref('order_payments') }}

),

/* {--{ config(database="lumpy-space-prince") }--} If you want to create a model in a separate project, 
keep in mind that the "--" is added between the curly braces as dbt interpets this 
commented out code as formal jinja templating 
to be compiled into a sql query for a separate project.
To make this work, you will need to remove the "--" between the curly braces 
and replace "lumpy-space-prince" with your BigQuery dataset. */

final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        orders.status,

        {% for payment_method in payment_methods -%}

        order_payments.{{payment_method}}_amount,

        {% endfor -%}

        order_payments.total_amount as amount

    from orders

    left join order_payments using (order_id)

)

select * from final limit 10