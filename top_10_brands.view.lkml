

view: top_10_brands {

  derived_table: {
    sql: SELECT
  brand,
  total_revenue,
   @curRank := @curRank + 1  as rank
  from (SELECT products.brand  AS brand,
          COALESCE(SUM(nullif(order_items.sale_price, 0)), 0) AS total_revenue
          FROM demo_db.order_items  AS order_items
            LEFT JOIN demo_db.inventory_items  AS inventory_items ON order_items.inventory_item_id = inventory_items.id
            LEFT JOIN demo_db.orders  AS orders ON order_items.Order_Id = orders.id
            LEFT JOIN demo_db.products  AS products ON inventory_items.product_id = products.id
          GROUP BY 1
          ORDER BY 2 DESC
          limit 20
          ) as top_brands

          , (select @curRank := 0) r ;;
  }

dimension: brand {
  primary_key: yes
  type: string
  sql: ${TABLE}.brand ;;
  order_by_field: rank
}

dimension: rank {
  type: number
  sql: ${TABLE}.rank ;;
}

dimension: total_revenue_dim {
  type: number
  sql: ${TABLE}.total_revenue ;;
}

measure: total_revenue {
  type: average
  sql: ${total_revenue_dim} ;;
}
}
