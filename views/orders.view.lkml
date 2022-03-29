view: orders {
  sql_table_name: "TPCH_SF1"."ORDERS"
    ;;

  dimension: o_clerk {
    type: string
    sql: ${TABLE}."O_CLERK" ;;
  }

  dimension: o_comment {
    type: string
    sql: ${TABLE}."O_COMMENT" ;;
  }

  dimension: o_custkey {
    type: number
    primary_key: yes
    sql: ${TABLE}."O_CUSTKEY" ;;
  }

  dimension_group: o_orderdate {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."O_ORDERDATE" ;;
  }

  filter: first_period {
    view_label: "_PoP"
    group_label: "period comparision"
    type: date
  }

  filter: second_period {
    view_label: "_PoP"
    group_label: "period comparision"
    type: date
  }

  dimension: days_from_start_first {
    view_label: "_PoP"
    hidden: yes
    type: number
    sql: DATEDIFF('day',  {% date_start first_period %}, ${o_orderdate_date}) ;;
  }

  dimension: days_from_start_second {
    view_label: "_PoP"
    hidden: yes
    type: number
    sql: DATEDIFF('day',  {% date_start second_period %}, ${o_orderdate_date}) ;;
  }

  dimension: days_from_first_period {
    view_label: "_PoP"
    group_label: "period comparision"
    type: number
    sql:
        CASE
        WHEN ${days_from_start_second} >= 0
        THEN ${days_from_start_second}
        WHEN ${days_from_start_first} >= 0
        THEN ${days_from_start_first}
        END;;
  }


  dimension: period_selected {
    view_label: "_PoP"
    group_label: "period comparision"
    label: "First or second period"
    type: string
    sql:
        CASE
            WHEN {% condition first_period %}${o_orderdate_raw} {% endcondition %}
            THEN 'First Period'
            WHEN {% condition second_period %}${o_orderdate_raw} {% endcondition %}
            THEN 'Second Period'
            END ;;
  }

  parameter: select_timeframe {
    type: string
    allowed_value: {
      label: "ordered_day"
      value: "Day"
    }
    allowed_value: {
       label: "ordered_week"
      value: "Week"
    }
    allowed_value: {
      label: "ordered_month"
      value: "Month"
    }
    allowed_value: {
      label: "ordered_year"
      value: "Year"
    }
  }

  dimension: dynamic_timeframe {
    label_from_parameter: select_timeframe
    type: date
    sql:
        CASE
          WHEN {% parameter select_timeframe %} = 'Day' THEN ${o_orderdate_date}
          WHEN {% parameter select_timeframe %} = 'Week' THEN ${o_orderdate_week}
          WHEN {% parameter select_timeframe %} = 'Month' THEN ${o_orderdate_month}
          ELSE NULL
          END;;
       }

  dimension: ordered_week {
    type: date_week
    sql: ${TABLE}."O_ORDERDATE" ;;
  }
  dimension: ordered_month {
    type: date_month
    sql: ${TABLE}."O_ORDERDATE";;
  }
  dimension: ordered_date {
    type: date_year
    sql: ${TABLE}."O_ORDERDATE" ;;
  }

  dimension: o_orderkey {
    type: number
    sql: ${TABLE}."O_ORDERKEY" ;;
  }

  dimension: order_bin {
    type: bin
    bins: [0, 50000, 100000, 150000, 200000, 250000, 300000, 350000, 400000, 450000,500000]
    style: integer
    sql: ${o_orderkey} ;;
  }

  dimension: order_tier {
    type: tier
    bins: [0, 50000, 100000, 150000, 200000, 250000, 300000, 350000, 400000, 450000,500000]
    style: classic
    sql: ${o_orderkey} ;;
  }


  dimension: o_orderpriority {
    type: string
    sql: ${TABLE}."O_ORDERPRIORITY" ;;
  }

  dimension: o_orderstatus {
    type: string
    sql: ${TABLE}."O_ORDERSTATUS" ;;
  }

   dimension: o_shippriority {
    type: number
    sql: ${TABLE}."O_SHIPPRIORITY" ;;
  }

  dimension: o_totalprice {
    type: number
    sql: ${TABLE}."O_TOTALPRICE" ;;
    value_format_name: value
  }

  dimension: big_order {
    type: yesno
    sql: ${o_totalprice} > 100000 ;;
  }

  measure: total_Amount {
    type: sum
    sql: ${o_totalprice} ;;
  }

  measure: Huge_Amount {
    description: "Is order total over 100000?"
    type: yesno
    sql: ${o_totalprice} > 100000 ;;
  }

  measure: total_distinct_Amount {
    type: sum_distinct
    sql_distinct_key: ${o_orderkey} ;;
    sql: ${o_custkey} ;;
  }

  measure: 95th_percentile {
    type: number
    sql: percentile(${o_totalprice} ;;
  }

    measure: median_order {
    type: number
    sql: median(${o_custkey}) ;;
  }

   measure: count_growth {
    type: percent_of_previous
    sql: ${count} ;;
  }

   measure: Average_Orders{
    type: average
    sql: ${o_custkey} ;;
    value_format: "#,##0"
  }

  measure: most_recent_order_date {
    type: date
    sql: MAX(${o_orderdate_date}) ;;
    convert_tz: no
  }

  measure: First_order_date {
    type: date
    sql: MIN(${o_orderdate_date}) ;;
    convert_tz: no
  }

   parameter: orderprice{
    type: unquoted
    allowed_value: {
      label: "less than 500"
      value: "< 500"
    }
    allowed_value: {
      label: "Less than 100000"
      value: "< 100000"
    }
    allowed_value: {
      label: "All Results"
      value: "< 500000"
    }
  }

  measure: dynamic_price {
    type: sum
    sql: ${TABLE}.{% parameter orderprice %} ;;
  }

   measure:  count {
    type: count
    drill_fields: []
  }
}
