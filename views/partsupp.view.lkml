view: partsupp {
  sql_table_name: "TPCH_SF1"."PARTSUPP"
    ;;

  dimension: ps_availqty {
    type: number
    sql: ${TABLE}."PS_AVAILQTY" ;;
  }

  dimension: ps_comment {
    type: string
    sql: ${TABLE}."PS_COMMENT" ;;
  }

  dimension: ps_partkey {
    type: number
    sql: ${TABLE}."PS_PARTKEY" ;;
  }

  dimension: ps_suppkey {
    type: number
    sql: ${TABLE}."PS_SUPPKEY" ;;
  }

  dimension: ps_supplycost {
    type: number
    sql: ${TABLE}."PS_SUPPLYCOST" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
