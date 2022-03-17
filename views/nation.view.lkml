view: nation {
  sql_table_name: "TPCH_SF1"."NATION"
    ;;


  dimension: n_comment {
    type: string
    sql: ${TABLE}."N_COMMENT" ;;
  }

  dimension: n_name {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."N_NAME" ;;
    case_sensitive: yes

  }

  dimension: n_nationkey {
    type: number
    sql: ${TABLE}."N_NATIONKEY" ;;
  }


  dimension: n_regionkey {
    type: number
    sql: ${TABLE}."N_REGIONKEY" ;;
  }

  measure: count {
    type: count
    drill_fields: [n_name]
  }
}
