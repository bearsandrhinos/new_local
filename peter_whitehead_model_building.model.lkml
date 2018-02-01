connection: "thelook"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

datagroup: peter_whitehead_model_building_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: peter_whitehead_model_building_default_datagroup

explore: events {
  join: users {
    view_label: "Users"
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {
  join: products {
    view_label: "Products"
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  join: inventory_items {
    view_label: "Inventory Items"
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: orders {
    view_label: "Orders"
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: products {
    view_label: "Products"
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: users {
    view_label: "Users"
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  persist_for: "4 hours"
}

explore: orders {
  label: "Orders"
  join: users {
    view_label: "Users"
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: products {}

explore: schema_migrations {}

explore: user_data {
  sql_always_where: ${users.state} = "California" ;;
  join: users {
    view_label: "Users"
    type: left_outer
    sql_on: ${user_data.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: users {}

explore: users_nn {
  always_filter: {
    filters: {
      field: users.gender
      value: "f"
    }
  }
  join: users {
    view_label: "Female Users"
    fields: [users.age, users.gender, users.city, users.email, users.state, users.zip]
    type: inner
    sql_on: ${users_nn.id} = ${users.id} ;;
    relationship: one_to_one
  }

}
