connection: "assessment"

# include all the views
include: "/views/**/*.view"
fiscal_month_offset: 6

datagroup: prudhvi_yadav_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: prudhvi_yadav_default_datagroup

named_value_format: euro_in_thousands {
  value_format: "\"€\"\" K\""
}

access_grant: Locale_name {
  user_attribute: locale
  allowed_values: ["en"]
}


explore: customer {
 persist_for: "30 minutes"
 sql_always_where: ${orders.o_orderdate_year} <> '1993' ;;



  join: orders {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_custkey}=${orders.o_custkey} ;;
  }
  join: lineitem {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_custkey}=${lineitem.l_orderkey} ;;
  }
  join: nation {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_nationkey}=${nation.n_nationkey} ;;
    sql_where: ${nation.n_name} in  ({{ _user_attributes['customer'] }}) ;;
  }




  join: part {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_custkey}=${part.p_partkey} ;;
  }
  join: partsupp {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_custkey}=${partsupp.ps_partkey} ;;
  }
  join: region {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_nationkey}=${region.r_regionkey} ;;
  }
  join: supplier {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_custkey}=${supplier.s_suppkey} ;;
  }
}
explore: cumulative_totals {}

explore: Top_N_Brands {}

explore: taxes_details {}

explore: sql_runner_query {}
