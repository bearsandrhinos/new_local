# explore: templated_dt {
#   join: users {
#     sql_on: ${user.state} = ${templated_dt.state} ;;
#     relationship: one_to_many
#   }
# }

view: templated_dt {
  derived_table: {
    sql: SELECT state, state_revenue
      FROM order_items left join orders
      on order_items.order_id = orders.id
      left join users
      on orders.user_id = users.id
      where {% condition users.order_state %} users.state {% endcondition %}
      group by 1
    ;;
  }

#   parameter: order_state {
#     type: string
#     suggest_explore: templated_dt
#     suggest_dimension: state
#   }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: state_revenue {
    type: number
    sql: ${TABLE}.state_revenue ;;
    value_format_name: usd
  }
}
