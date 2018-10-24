view: orders {
  sql_table_name: demo_db.orders ;;

  filter: last_weeks_orders {
    type: date
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: minute5 {
    type: date_minute5
    sql: ${TABLE}.created_at ;;
  }

  # dimension: test_again {
  #   type: number
  #   sql: case when {% parameter users.states %} = "California" then ${id}
  #   else user_id end ;;
  # }

  dimension_group: created {

    type: time
    timeframes: [minute5,
      raw,
      time,
      date,
      week,
      month,
#       month_name,
      month_num,
      quarter,
      year,
      day_of_week,
      day_of_month,
      day_of_week_index,
      day_of_year,
      fiscal_month_num,
      fiscal_quarter,
      fiscal_quarter_of_year,
      fiscal_year,
      hour,
      hour_of_day,
      time_of_day


    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: just_the_time {

  }

  dimension: month_name {
    label: "Mother Fucking Month Name"
    group_label: "Created Date"
    type: date_month_name
    sql: ${TABLE}.created_at ;;
  }

  dimension: days_til_end {
    type: number
    sql: case when ${created_fiscal_quarter_of_year} = "Q1" then datediff('2018-03-31', now())
          when ${created_fiscal_quarter_of_year} = "Q2" then datediff('2018-06-31', now())
          when ${created_fiscal_quarter_of_year} = "Q3" then datediff(concat(extract(year from now()),'-10-31'), now())
             else datediff('2018-31-12', now()) end ;;
  }

  dimension_group: format {
    hidden: yes
    type: time
    timeframes: [date, week, month]
    sql: ${TABLE}.created_at ;;
  }

  dimension: for_date {
#     group_label: "Formatted Created"
#     label: "Date"
    sql: ${created_time_of_day} ;;
    html: {{ rendered_value | date: "%r" }} ;;
  }

  dimension: for_m_y {
    group_label: "Formatted Created"
    label: "Month"
    sql: ${format_month} ;;
    html: {{ rendered_value | append: "-01" | date: "%B %Y" }} ;;
  }

  dimension: day_of_year {
    group_label: "Formatted Created"
    label: "Day of Year"
    sql: ${format_date} ;;
    html: {{rendered_value | date: "Day %j of %Y" }} ;;
  }

  dimension: cur_day {
    type: yesno
    sql: ${created_day_of_week} = dayname(curdate()) ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: rev_create {
    label: "rev_create"
    type: string
    sql: case when (${status} = "complete" or ${status} = "pending") then "rev creating" else null end ;;
  }

  measure: count {
    type: count
    drill_fields: [products.category, order_items.total_profit]
#     html: {{orders.cancel_count._rendered_value}} ;;
    link: {
      label: "High Profit items"
      url: "{{link}}&f[order_items.total_profit]=>=50000"
    }
  }

  measure: cancel_count {
    description: "The amount of cancelled orders."
    type: count
    drill_fields: [id, users.first_name, users.last_name, users.state, products.name]
    filters: {
      field: status
      value: "cancelled"
    }
  }

  measure: pending_count {
    description: "The amount of orders that are pending at the moment."
    type: count
    drill_fields: [id, users.first_name, users.last_name, users.state, products.name]
    filters: {
      field: status
      value: "pending"
    }
  }

  measure: pend_percent {
    type: number
    sql: ${pending_count}/${count} ;;
    value_format_name: percent_2
  }

  measure: cancel_percent {
    type: number
    sql: ${cancel_count}/${count} ;;
    value_format_name: percent_2
  }


}
