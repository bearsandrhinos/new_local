explore: users {

}

view: users {

  sql_table_name: demo_db.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  parameter: order_state {
    type: string
    suggest_explore: templated_dt
    suggest_dimension: state
  }
  parameter: sex {
    label: "tjerfsdfdsfk;vas"
    type: string
    suggest_dimension: gender
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;

  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    view_label: "Users country"
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: filter_key {
    sql: concat(${first_name}, "_", ${last_name}, ${country}) ;;
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



  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: state {
    type: string
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
  }

  dimension: zip {
    type: zipcode
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}.zip ;;
  }

  dimension: full_name {
    type: string
    sql: CONCAT(${first_name}, " " , ${last_name}) ;;
  }

  dimension: filter_test {
    type: string
    sql: concat(${first_name}, ":", ${last_name}, " : ", ${state}, " ;", ${city}) ;;
  }

  parameter: cost_per_user {
    type: number
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_distinct {
    type: count_distinct
    sql: COALESCE(${id}, 0) ;;
    sql_distinct_key: ${id} ;;
  }

  measure: count_non_null {
    type: number
    sql: case when isnull(${count_distinct}) = 1 then 0 else ${count_distinct} ;;
  }

  measure: cost_user {
    type: number
    sql: ${count}/{% parameter cost_per_user %} ;;
  }

  # measure: min_date {
  #   type: date_time
  #   sql: min(${orders.created_time}) ;;
  #   convert_tz: no
  # }

  measure: state_list {
    type: list
    list_field: state
  }

  measure: city_list {
    type: list
    list_field: city
  }

  dimension: bug_action {
    type:  string
    sql: 'Log Corrective Action' ;;
    action: {
      label: "Log Action"
      url: "https://hooks.zapier.com/hooks/catch/2940751/epq7p7/"
      param: {
        name: "action_type"
        value: "ops_alert_corrective_action"
      }
      param: {
        name: "action_state"
        value: "{{ state._value }}"
      }
      param: {
        name: "alert_id"
        value: "{{ id._value }}"
      }
      param: {
        name: "First Name"
        value: "{{ first_name._value }}"
      }
    }
  }

  # measure: count_30 {
  #   type: count_distinct
  #   sql: ${id} ;;
  #   filters: {
  #     field: orders.created_date
  #     value: "30 days"
  #   }
  # }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      last_name,
      first_name,
      events.count,
      orders.count,
      user_data.count
    ]
  }
}
