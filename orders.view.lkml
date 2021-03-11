view: orders {
  sql_table_name: looker-private-demo.ecomm.orders ;;

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
  #Thought I was going to need this parameter but I don't
  ####leave it just as an example
  parameter: period_and_previous {
    type: unquoted
    default_value: "week"
    allowed_value: {
      label: "Week-to-date"
      value: "week"
    }
    allowed_value: {
      label: "Month-to-date"
      value: "month"
    }
    allowed_value: {
      label: "Year-to-day"
      value: "year"
    }
  }

  dimension: this_and_that {
    type: string
    sql: CASE WHEN EXTRACT({{ period_and_previous._parameter_value }} FROM ${created_raw}) =
                   EXTRACT({{ period_and_previous._parameter_value }} FROM now()) AND
                  ${created_raw} <= now() THEN "This period to date"
              WHEN EXTRACT({{ period_and_previous._parameter_value }} FROM ${created_raw}) +1 =
                   EXTRACT({{ period_and_previous._parameter_value }} FROM now()) AND
                  DAYOFYEAR(${created_raw}) <= DAYOFYEAR(now()) THEN "Last period to date" END;;
  }


###Use this dimension if you are using the parameter
  dimension: until_today {
    type: yesno
    sql: {% if period_and_previous._parameter_value == 'week' %}
            ${created_day_of_week_index} <= WEEKDAY(NOW()) AND ${created_day_of_week_index} >= 0
          {% elsif period_and_previous._parameter_value == 'month' %}
            ${created_day_of_month} <= DAYOFMONTH(NOW()) AND ${created_day_of_month} >=0
          {% elsif period_and_previous._parameter_value == 'year' %}
          ${created_day_of_year} <= DAYOFMONTH(NOW()) AND ${created_day_of_year} >=0
          {% endif %} ;;
    }

#   dimension: until_today {
#     type: yesno
#     sql: {% if orders.created_week._in_query %}
#             ${created_day_of_week_index} <= WEEKDAY(NOW()) AND ${created_day_of_week_index} >= 0
#           {% elsif orders.created_month._in_query %}
#             ${created_day_of_month} <= DAYOFMONTH(NOW()) AND ${created_day_of_month} >=0
#           {% elsif orders.created_year._in_query %}
#            ${created_day_of_year} <= DAYOFMONTH(NOW()) AND ${created_day_of_year} >=0
#           {% endif %} ;;
#   }


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
