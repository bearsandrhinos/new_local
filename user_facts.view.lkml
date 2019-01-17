view: user_facts { #Creating a view called user_facts
  derived_table: { #This statment tells Looker that I am now going to enter in a derived table
    # Next is the sql query that will create the new view
    sql:
        SELECT user_id,
                count(*) as total_orders,
                min(orders.created_at) as first_order,
                max(orders.created_at) as latest_order
        FROM orders join users on users.id = orders.user_id
        group by user_id
        order by user_id;;

        persist_for: "8760 hours"
  }

  #Primary key is user id

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  #Dimension for total number of orders

  dimension: total_user_orders {
    type: number
    sql: ${TABLE}.total_orders ;;
  }

  # Dimension for first order ever

  dimension: first_order {
    type: date
    sql: ${TABLE}.first_order ;;
  }

  #Dimension for last order

  dimension: latest_order {
    type: date
    sql: ${TABLE}.latest_order ;;
  }

  #Dimension that is the number of days between today and the first order

  dimension: days_since_first_order {
    type: number
    sql: DATEDIFF(days, now(), ${first_order}) ;;
  }

  #Dimension for if user is a repeat customer

  dimension: repeat_customer {
    type: yesno
    sql: ${total_user_orders}_orders} > 1 ;;
  }

  #First we need to get the sum of all the orders to get the average per month

  measure: total_number_orders{
    type: sum
    sql: ${total_user_orders} ;;

  }


  measure: average_orders_per_month {
    type: number
    sql: ${total_number_orders}/12 ;;
  }



  # # You can specify the table name if it's different from the view name:
  # sql_table_name: my_schema_name.tester ;;
  #
  # # Define your dimensions and measures here, like this:
  # dimension: user_id {
  #   description: "Unique ID for each user that has ordered"
  #   type: number
  #   sql: ${TABLE}.user_id ;;
  # }
  #
  # dimension: lifetime_orders {
  #   description: "The total number of orders for each user"
  #   type: number
  #   sql: ${TABLE}.lifetime_orders ;;
  # }
  #
  # dimension_group: most_recent_purchase {
  #   description: "The date when each user last ordered"
  #   type: time
  #   timeframes: [date, week, month, year]
  #   sql: ${TABLE}.most_recent_purchase_at ;;
  # }
  #
  # measure: total_lifetime_orders {
  #   description: "Use this for counting lifetime orders across many users"
  #   type: sum
  #   sql: ${lifetime_orders} ;;
  # }
}

# view: user_facts {
#   # Or, you could make this view a derived table, like this:
#   derived_table: {
#     sql: SELECT
#         user_id as user_id
#         , COUNT(*) as lifetime_orders
#         , MAX(orders.created_at) as most_recent_purchase_at
#       FROM orders
#       GROUP BY user_id
#       ;;
#   }
#
#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
