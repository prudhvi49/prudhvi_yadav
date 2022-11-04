view: customer {
  sql_table_name: "TPCH_SF1"."CUSTOMER"
    ;;

  dimension: c_acctbal {
    type: number
    sql: ${TABLE}."C_ACCTBAL" ;;
  }

  dimension: c_address {
    type: string
    sql: ${TABLE}."C_ADDRESS" ;;
  }

  dimension: c_comment {
    type: string
    sql: ${TABLE}."C_COMMENT" ;;
  }

  dimension: c_custkey {
    type: number
    sql: ${TABLE}."C_CUSTKEY" ;;
  }

  dimension: c_mktsegment {
    type: string
    sql: ${TABLE}."C_MKTSEGMENT" ;;
  }

  dimension: c_name {
    type: string
    sql: ${TABLE}."C_NAME" ;;
  }

  dimension: c_nationkey {
    type: number
    sql: ${TABLE}."C_NATIONKEY" ;;
  }

  dimension: c_phone {
    type: string
    sql: ${TABLE}."C_PHONE" ;;
  }

  measure: max_customername {
    type: string
    sql: max(${c_name}) ;;
  }

  measure: count {
    type: count
    drill_fields: [c_name]

    }
}
