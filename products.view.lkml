view: products {
  sql_table_name: demo_db.products ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  filter: to_filter {
    type: string
    case_sensitive: no
  }

  filter: to_filter2 {
    type: string
    case_sensitive: no
  }

  dimension: look_here {
    type: string
    sql: concat(${brand},${category},${department},${item_name}) ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    # order_by_field: top_10_brands.rank
  }

  dimension: user_session_level {
    view_label: "Event Time Difference - Advanced"
    group_label: "Labels"
    sql: 1 ;;
    html: {{ _filters['products.brand'] }};;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: to_hide {
    type: string
    sql: CASE WHEN ${category} = "Jeans" THEN "Dresses"
          else ${category} end ;;
  }

  measure: count_cat {
    type: count
    sql: ${to_hide} ;;
  }

  measure: count_cat_nonhide {
    type: count
    sql: CASE WHEN ${category} = "Suits" THEN "Skirts"
          ELSE ${category} end;;
  }

  measure: count_distinct {
    type: count_distinct
    sql: ${category} ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: wrapper {
    type:  string
    sql:"I am going to write this and hopefully it is long enough and it will wrap and then I will add the HTML" ;;
    html: <td nowrap> <p align="right"> {{rendered_value}} </p></td> ;;
  }

#   dimension: filter_dimension {
#     type: number
#     sql: case when ${brand} IN ("Nike", "10 Deep", "Levi's") then 1 else 0 end ;;
#   }

  measure: count {
    type: count
    drill_fields: [id, item_name, inventory_items.count]
  }

  measure: total_retail_price {
    type: sum
    sql: ${retail_price};;
    value_format: "$0.00"
    drill_fields: [id, category, department, brand, retail_price]
  }

  measure: average_retail_price {
    type: average
    sql: ${retail_price} ;;
    value_format: "$0.00"
    drill_fields: [id, category, department, brand, retail_price]
  }

  # measure: average_7 {
  #   type: average
  #   sql: case when extract(day from ${orders.created_date}) <=7 then ${retail_price} else null end ;;

  # }

  measure: female_count {
    type: count
    filters: {
      field: department
      value: "Women"
    }
  }

  measure: female_percent {
    type: number
    sql: ${female_count}/${count} ;;
  }


}
