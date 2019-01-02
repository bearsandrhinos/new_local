view: order_items {
  sql_table_name: demo_db.order_items ;;

# sql_table_name:   {% if event.created_date._in_query %}
#     event_by_day
#   {% elsif event.created_week._in_query %}
#     event_by_week
#   {% else %}
#     event
#   {% endif %}  ;;

  filter: this_better_work {
    type: date
  }

  parameter: jam_it {
    type: unquoted
  }

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
    sql: ${TABLE}.Order_Id ;;
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
      week_of_year,
      month,
      quarter,
      year,
      day_of_week,
      month_name
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

  dimension_group: midnight {
    type: time
    timeframes: [hour]
    sql: TIME(12:00:00) ;;
  }

measure: cheap_count  {
  type: number
  sql: sum(case when ${cheap} = "yes" then 1 else 0 end);;
}

  measure: count {
    type: count
  }


  measure: total_revenue {    #This is the first sum for the project
    type:  sum
    sql: nullif(${sale_price}, 0);;
    drill_fields: [detail1*]
    value_format: "$0.00"
  }

  measure: percent_of_last {
    type: percent_of_previous
    sql: ${total_revenue} ;;

  }

  parameter: sale_price_item_picker {
    description: "This will let you choose 'Most Expensive', 'Least Expensive', or 'AVG Sale Price'"
    type: unquoted
    allowed_value: {
      label : "Most Expensive"
      value: "MAX"
    }
    allowed_value: {
      label: "Least Expensive"
      value: "MIN"
    }
    allowed_value: {
      label: "AVG Sale Price"
      value: "AVG"
    }
  }





  measure: sale_price_metric {
    description: "Use this with the sale_price_item_picker"
    type: number
    label_from_parameter: sale_price_item_picker
    sql: {% parameter sale_price_item_picker %}(${sale_price})
          ;;
    value_format_name: usd
  }

  measure: most_expensive {  #First max function for the project
    type:  max
    hidden: yes
    sql: ${sale_price} ;;
    drill_fields: [detail1*]
#     html: {{order_items.total_revenue._rendered_value}} ;;
  }

  measure: least_expensive {  #First min function for the project
    type:  min
    hidden: yes
    sql: ${sale_price} ;;
    drill_fields: [detail1*]
    value_format: "$0.00"
  }

  measure: test_avg_drill {
    type: number
    sql: ${average_sale_price} ;;
    html: {{ order_items.average_sale_price._linked_value }} ;;
  }

  measure: average_sale_price {
    type:  average
    sql: ${sale_price} ;;
    drill_fields: [detail1*]
    value_format: "$0.00"
  }

  measure: sum_star {
    type: sum
  }

  parameter: gsv {
    type: unquoted
    allowed_value: {
      label: "Total GSV"
      value: "total_gsv"
    }

    allowed_value: {
      label: "Marketplace GSV"
      value: "marketplace_gsv"
    }
    }

    measure: dynamic {
      type: number
      sql: ${total_revenue} /({% if order_items.gsv._parameter_value == 'total_gsv' %}
         ${inventory_items.total_cost}
              {% else %}
             ${products.total_retail_price}
        {% endif %}) ;;


    }

#   measure: other_measure {
#     type: number
# #     sql:  {% parameter sale_price_item_picker %}(${sale_price});;
#       sql:  ${sale_price}/({% if sale_price_item_picker._parameter_value == 'MAX' %}
#     {{ most_expensive._rendered_value }}
#     {% elsif sale_price_item_picker._parameter_value == 'MIN' %}
#     {{ least_expensive._rendered_value }}
#     {% elsif sale_price_item_picker._parameter_value == 'AVG' %}
#     {{ average_sale_price._rendered_value }} ;;
#
#     html:
#     {% if sale_price_item_picker._parameter_value == 'MAX' %}
#     {{ most_expensive._rendered_value }}
#     {% elsif sale_price_item_picker._parameter_value == 'MIN' %}
#     {{ least_expensive._rendered_value }}
#     {% elsif sale_price_item_picker._parameter_value == 'AVG' %}
#     {{ average_sale_price._rendered_value }}
#
#     {% endif %}
#     ;;
#   }

  measure: total_profit {
    type: number
    sql: ${total_revenue} - ${inventory_items.total_cost} ;;
    drill_fields: [detail1*]
    value_format: "$0.00"
    # value_format_name: usd
    html:   <font color="red">{{rendered_value}}</font>;;
    #you can't do a filtered measure of type: number
#     filters: {
#       field: returned_date
#       value: "last 7 days"
#     }
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
    link: {
      label: "Test"
      url: "/dashboards/2?male={{ users.gender._filterable_value }}"
    }
  }

  measure: percentile_90 {
    type: percentile
    percentile: 50
    sql_distinct_key: ${products.brand} ;;
    sql: ${sale_price} ;;
  }

  measure: percentile_95 {
    type: percentile
    percentile: 75
    sql_distinct_key: ${products.brand} ;;
    sql: ${sale_price} ;;
  }

  measure: percentile_99 {
    type: percentile
    percentile: 99
    sql_distinct_key: ${products.brand} ;;
    sql: ${sale_price} ;;
  }

 measure: sum_distinct_example {
   type: sum_distinct
  sql: ${sale_price} ;;
  value_format: "$0.00"
 }

measure: test_sub {
  type: sum
  sql: ${TABLE}.sale_price - ${inventory_items.cost} ;;
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
