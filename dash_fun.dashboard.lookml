- dashboard: dash_fun
  title: Dash Fun
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
    y_axis_min: 10000
    y_axis_max: 2000000
    show_null_points: true
    point_style: none
    interpolation: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    listen: {}
    row: 0
    col: 0
    width: 8
    height: 6
  filters:
  - name: Untitled Filter
    title: Untitled Filter
    type: string_filter
    default_value: ''
    allow_multiple_values: true
    required: false
  - name: Untitled Filter 2
    title: Untitled Filter 2
    type: date_filter
    default_value: ''
    allow_multiple_values: true
    required: false
