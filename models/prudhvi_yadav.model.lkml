connection: "assessment"

# include all the views
include: "/views/**/*.view"
fiscal_month_offset: 3

datagroup: prudhvi_yadav_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: prudhvi_yadav_default_datagroup

named_value_format: value {
  value_format: "[>=1000000000] 0.00,,,\"B\";[>=1000000] 0.00,,\"M\";[>=1000] 0.00,\"K\";0.0"
}


access_grant: Locale_name {
  user_attribute: customer
  allowed_values: ["ARGENTINA"]
}

map_layer: countries_view {
url: "https://github.com/brechtv/looker_map_layers/blob/master/world-countries.json"
property_key: "countries"
}


explore: customer {
 persist_for: "30 minutes"
 #sql_always_where: ${orders.o_orderdate_year} <> '1993' ;;
sql_always_having: (${count}) = 1;;
 label: "prudhvi"
sql_always_where: ${nation.n_name}<>'INDIA';;



  #always_filter: {
   # filters: [part.p_mfgr: "Manufacturer#1"]
  #}
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
    sql_where: ${nation.n_name}<>'INDIA';;
    #sql_where: ${nation.n_name} in  ({{ _user_attributes['customer'] }}) ;;
  }


  join: part {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_custkey}=${part.p_partkey} ;;
    required_access_grants: [Locale_name]


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
