# explore: dt_sme {}

# view: dt_sme {
#   # Or, you could make this view a derived table, like this:
#   derived_table: {
#     sql: SELECT
#             orders.id  AS order_id,
#             orders.user_id  AS user_id,
#             users.city  AS city,
#             COUNT(*) AS count_of_items
#             FROM order_items  AS order_items
# LEFT JOIN orders  AS orders ON order_items.Order_Id = orders.id
# LEFT JOIN users  AS users ON orders.user_id = users.id
#
# GROUP BY 1,2,3
# ORDER BY COUNT(*) DESC
# LIMIT 500
#       ;;
#   }
#
#   dimension: order_id {
#     type: number
#     sql: ${TABLE}.order_id ;;
#   }
#
#   dimension: user_id {
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: city {
#     type: string
#     sql: ${TABLE}.city ;;
#   }
#
#   dimension: count_of_items {
#     type: number
#     sql: ${TABLE}.count_of_items ;;
#   }
#
#   measure: max_items {
#     type: max
#     sql: ${count_of_items} ;;
#   }
#
#
#
#
# }

# view: DT_SME {
#   derived_table: {
#     sql:
#     SELECT
#   users.city  AS city,
#   orders.user_id  AS user_id,
#   COUNT(DISTINCT orders.id ) AS order_count
# FROM order_items  AS order_items
# LEFT JOIN orders  AS orders ON order_items.Order_Id = orders.id
# LEFT JOIN users  AS users ON orders.user_id = users.id

# GROUP BY 1,2
# ORDER BY COUNT(DISTINCT orders.id ) DESC
# LIMIT 500
# ;;
#   }

#     dimension: user_id {
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }

#   dimension: city {
#     type: string
#     sql: ${TABLE}.city ;;
#   }

#   dimension: order_count {
#     type: number
#     sql: ${TABLE}.order_count ;;
#   }

#   measure: max_orders {
#     type: max
#     sql: ${order_count} ;;
#   }

# }
