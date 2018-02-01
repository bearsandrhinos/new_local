- dashboard: basic_lookml_dash
  title: Basic Lookml Dash
  layout: newspaper
  elements:
  - title: Untitled
    name: Untitled
    model: peter_whitehead_model_building
    explore: order_items
    type: looker_line
    fields:
    - order_items.total_revenue
    - orders.created_year
    - orders.created_month
    sorts:
    - orders.created_year desc
    limit: 500
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    show_null_points: true
    point_style: none
    interpolation: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    row: 0
    col: 0
    width: 8
    height: 6
