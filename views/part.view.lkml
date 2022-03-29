view: part {
  sql_table_name: "TPCH_SF1"."PART"
    ;;

  dimension: p_brand {
    type: string
    sql: ${TABLE}."P_BRAND" ;;
  }

  dimension: p_comment {
    type: string
    sql: ${TABLE}."P_COMMENT" ;;
  }

  dimension: p_container {
    type: string
    sql: ${TABLE}."P_CONTAINER" ;;
  }

  dimension: p_mfgr {
    type: string
    sql: ${TABLE}."P_MFGR" ;;
  }

  dimension: p_name {
    type: string
    sql: ${TABLE}."P_NAME" ;;
  }

  dimension: p_partkey {
    type: number
    primary_key: yes
    sql: ${TABLE}."P_PARTKEY" ;;
  }

  dimension: p_retailprice {
    type: number
    sql: ${TABLE}."P_RETAILPRICE" ;;
  }

  dimension: p_size {
    type: number
    sql: ${TABLE}."P_SIZE" ;;
  }

  dimension: p_type {
    type: string
    sql: ${TABLE}."P_TYPE" ;;
  }

  filter: select_brand {
    type: string
    suggest_explore: customer
    suggest_dimension: part.p_brand

  }

  dimension: brand_comparison {
    type: string
    sql:
      CASE
      WHEN {% condition select_brand %}
        ${p_brand}
        {% endcondition %} THEN ${p_brand}
      ELSE NULL
      END
      ;;
  }

  filter: select_brand_source {
    type: string
    suggest_explore: customer
    suggest_dimension: part.p_brand
  }

  dimension: hidden_select_brand_source {
    hidden: yes
    type: yesno
    sql: {% condition select_brand_source %} ${p_brand} {% endcondition %} ;;
  }

  measure: dynamic_count {
    type: count_distinct
    sql: ${p_partkey} ;;
    filters: [ hidden_select_brand_source: "yes" ]
  }

  parameter: measure_selector {
    type: string
    allowed_value: {
      label: "Sum of Total Retail Price"
      value: "sum"
    }
    allowed_value: {
      label: "Average of Retail Price"
      value: "Average"
    }
    allowed_value: {
      label: "Count"
      value: "count"
    }
  }

  measure: measure_dynamic {
    label_from_parameter: measure_selector
    type: number
    value_format: "#,###"
    sql:
      CASE
      WHEN {% parameter measure_selector %} = 'sum' THEN SUM(${p_retailprice})
      WHEN {% parameter measure_selector %} = 'Average' THEN Avg(${p_retailprice})
      WHEN {% parameter measure_selector %} = 'count' THEN count(${p_retailprice})
     ELSE NULL
    END;;
  }


  measure: total_retail_price {
    type: sum
    sql: ${p_retailprice} ;;
    value_format_name: value
  }


  measure: percent_of_total_price {
    type: percent_of_total
    sql: ${p_retailprice} ;;
  }


  measure: brands_list {
    type: list
    list_field: p_brand
  }

    measure: cumulative_total_revenue {
    type: running_total
    sql: ${p_retailprice} ;;
  }

  measure: total_large_amount {
    type: sum
    filters: [p_retailprice: "<10000000"]
    sql: ${p_retailprice} ;;
  }

  measure: median_order {
    type: median
    sql: ${p_retailprice} ;;
  }


  measure: count {
    type: count
    drill_fields: [p_name]
  }
}
