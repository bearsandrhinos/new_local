view: inventory_items {
  sql_table_name: looker-private-demo.ecomm.inventory_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
    value_format: "$0.00"
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: sold {
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
    sql: ${TABLE}.sold_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id, products.item_name, products.id, order_items.count]
  }

  measure: total_cost {
    type:  sum
    sql: ${cost};;
    drill_fields: [id, sold_date , cost]
    value_format: "$0.00"
  }

  measure: lowest_cost {
    type: min
    sql: ${cost} ;;
    drill_fields: [id, products.item_name, products.id, order_items.count]
    value_format: "$0.00"
  }

  measure: highest_cost {
    type: max
    sql:  ${cost} ;;
    drill_fields: [id, products.item_name, products.id, order_items.count]
    value_format: "$0.00"
  }

  measure: average_cost {
    type: average
    sql: ${cost} ;;
    drill_fields: [id, products.item_name, products.id, order_items.count]
    value_format: "$0.00"
  }
}
