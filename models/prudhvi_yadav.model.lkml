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
  user_attribute: customer
  allowed_values: ["ARGENTINA"]
}


explore: customer {
 persist_for: "30 minutes"
 label: "prudhvi"
 #sql_always_where: ${nation.n_name}<>'INDIA';;


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
    #sql_where: ${nation.n_name} in  ({{ _user_attributes['customer'] }}) ;;
  }

  join: part {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer.c_custkey}=${part.p_partkey} ;;
    #required_access_grants: [Locale_name]


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

test: Totalprice_is_accurate {
  explore_source: customer {
    column: o_totalprice {
      field: orders.o_totalprice
    }
     }
  assert: Totalprice_is_expected_value {
    expression: ${orders.o_totalprice} < 10000 ;;
  }
}

explore: cumulative_totals {}

explore: Top_N_Brands {}

explore: taxes_details {}


explore: sql_runner_query {}
