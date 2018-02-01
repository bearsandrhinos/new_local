view: order_items {
  sql_table_name: demo_db.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
    drill_fields: [products.id,
                    products.category,
                    products.brand,
                    products.name]
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
    drill_fields: [users.first_name,
                    users.last_name,
                    users.state]
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
    value_format: "$0.00"
    drill_fields: [products.id,
                    products.category,
                    products.brand,
                    products.name]
  }

  dimension: cheap {
    description: "Cheap is less than $100."
    type: yesno
     sql: ${sale_price} < 100 ;;
  }

  measure: count {
    type: count
    drill_fields: [id,
                    inventory_items.id,
                    orders.id]
  }

  measure: total_revenue {    #This is the first sum for the project
    type:  sum
    sql: ${sale_price};;
    drill_fields: [detail1*]
    value_format: "$0.00"
  }

  measure: most_expensive {  #First max function for the project
    type:  max
    sql: ${sale_price} ;;
    drill_fields: [detail1*]
    value_format: "$0.00"
  }

  measure: least_expensive {  #First min function for the project
    type:  min
    sql: ${sale_price} ;;
    drill_fields: [detail1*]
    value_format: "$0.00"
  }

  measure: average_sale_price {
    type:  average
    sql: ${sale_price} ;;
    drill_fields: [detail1*]
    value_format: "$0.00"
  }

  measure: total_profit {
    type: number
    sql: ${total_revenue} - ${inventory_items.total_cost} ;;
    drill_fields: [detail1*]
    value_format: "$0.00"
  }

  measure: profit_per_item {
    description: "This field will give you the average profit per item."
    type: number
    sql: ${total_profit}/${count};;
    value_format: "$0.00"
    drill_fields: [detail1*]
  }

  measure: return_count {
    description: "This is the total amount of items that have been returned."
    type: count_distinct
    sql: ${returned_date} ;;
    drill_fields: [id,
                    order_id,
                    users.full_name,
                    products.name]

  }

  measure: percent_returned {
    description: "This field calculates the percentage of items that have been returned."
    type: number
    sql:  ${return_count}/${order_items.count};;
    value_format_name: percent_2
    drill_fields: [id,
                    order_id,
                    users.full_name,
                    products.name]
  }

  measure: running_total {
    description: "This is a running total of revenue"
    type: running_total
    sql: ${total_revenue} ;;
    value_format: "$0.00"
    drill_fields: [detail1*]
  }

 measure: sum_distinct_example {
   type: sum_distinct
  sql: ${sale_price} ;;
  value_format: "$0.00"
 }

  set: detail1 {
    fields: [id,
              order_id,
              products.name,
              users.first_name,
              users.last_name,
              users.state,
              sale_price,
              inventory_items.cost
              ]
  }
}
