# If necessary, uncomment the line below to include explore_source.
# include: "users.view.lkml"

view: testy_the_test {
  derived_table: {
    explore_source: users {
      column: filter_key {}
      bind_filters: {
        to_field: users.filter_key
        from_field: filter_key
      }
    }

  }

  dimension: filter_key {}
}
