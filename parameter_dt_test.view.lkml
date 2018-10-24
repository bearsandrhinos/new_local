explore: parameter_dt_test {
  from: parameter_dt_test
}

view: parameter_dt_test {
#   sql_table_name: demo_db.users ;;
  #Or, you could make this view a derived table, like this:
  derived_table: {
    sql: SELECT
          * From demo_db.users
          where {% condition sex %} users.gender {% endcondition %} AND {% condition states %} users.state {% endcondition %};;


          }




parameter: test {
  type:string
  suggest_explore: parameter_dt_test
  suggest_dimension: parameter_dt_test.state
  suggest_persist_for: "5 seconds"
  }


  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  filter: sex {
    label: "tjerfsdfdsfk;vas"
    type: string
    suggest_dimension: parameter_dt_test.gender
  }

  filter: states {
    type: string
    suggest_dimension: state
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
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
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

  parameter: cost_per_user {
    type: number
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: cost_user {
    type: number
    sql: ${count}/{% parameter cost_per_user %} ;;
  }

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
