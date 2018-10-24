explore: two_days_ago {}

view: two_days_ago {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: SELECT
  DATE(orders.created_at ) AS created
FROM demo_db.order_items  AS order_items
LEFT JOIN demo_db.orders  AS orders ON order_items.Order_Id = orders.id

WHERE
  (orders.created_at  < (DATE_ADD(DATE(NOW()),INTERVAL -2 day)))
GROUP BY 1
ORDER BY DATE(orders.created_at ) DESC

      ;;
  }

  dimension_group: created {
    type: time
    sql: ${TABLE}.created ;;
  }

}
