view: cumulative {
  derived_table: {
    sql: SELECT
          part."P_BRAND"  AS "part.p_brand",
          part."P_RETAILPRICE"  AS "part.p_retailprice",
          ( part."P_RETAILPRICE"  )  AS "part.cumulative_total_revenue"
      FROM "TPCH_SF1"."CUSTOMER"
           AS customer
      LEFT JOIN "TPCH_SF1"."PART"
           AS part ON (customer."C_CUSTKEY")=(part."P_PARTKEY")
      GROUP BY
          1,
          2
      ORDER BY
          1
      FETCH NEXT 500 ROWS ONLY
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: part_p_brand {
    type: string
    sql: ${TABLE}."part.p_brand" ;;
  }

  dimension: part_p_retailprice {
    type: number
    sql: ${TABLE}."part.p_retailprice" ;;
  }

  dimension: part_cumulative_total_revenue {
    type: number
    sql: ${TABLE}."part.cumulative_total_revenue" ;;
  }

  set: detail {
    fields: [part_p_brand, part_p_retailprice, part_cumulative_total_revenue]
  }
}
