#this is the future

view: future {


  derived_table: {
    sql: SELECT DATE(cal.date) as future
FROM (
      SELECT SUBDATE(NOW(), INTERVAL 30 DAY) + INTERVAL xc DAY AS date
      FROM (
            SELECT @xi:=@xi+1 as xc from
            (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) xc1,
            (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) xc2,
            (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) xc3,
            (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) xc4,
            (SELECT @xi:=-1) xc0
      ) xxc1
) cal
WHERE cal.date <= NOW()

union

SELECT
  DATE(orders.created_at ) AS future
FROM demo_db.orders  AS orders

GROUP BY 1
ORDER BY DATE(future ) DESC
      ;;
  }


  dimension_group: future {
    type: time
    sql:  DATE_ADD(${TABLE}.future, INTERVAL 30 DAY) ;;
    timeframes: [date]
  }

  dimension: is_past {
    hidden: yes
    type: number
    sql: CASE WHEN ${future_date} > CURDATE() THEN NULL ELSE 1 END ;;
  }

  dimension: days_from_today {
    type: number
    sql:  DATEDIFF(${future_date}, CURDATE());;
  }

  dimension: days_from_today_past {
  type: number
  sql: DATEDIFF(${future_date}, current_date)*${is_past} ;;
  }
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
}
