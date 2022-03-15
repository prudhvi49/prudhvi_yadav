view: sql_runner_query {
  derived_table: {
    sql: SELECT
          part."P_BRAND"  AS "part.p_brand",
          COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE( ( part."P_RETAILPRICE"  )  ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + (TO_NUMBER(MD5( part."P_PARTKEY"  ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0) ) - SUM(DISTINCT (TO_NUMBER(MD5( part."P_PARTKEY"  ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') % 1.0e27)::NUMERIC(38, 0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0) AS "part.total_retail_price",
          rank() over (order by "part.total_retail_price" desc) AS "BRAND_RANK",
          COUNT(DISTINCT part."P_PARTKEY" ) AS "part.count"

      FROM "TPCH_SF1"."CUSTOMER"
           AS customer
      LEFT JOIN "TPCH_SF1"."PART"
           AS part ON (customer."C_CUSTKEY")=(part."P_PARTKEY")
      GROUP BY
          1
      ORDER BY
          2 DESC
      FETCH NEXT 500 ROWS ONLY
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: part_p_brand {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}."part.p_brand" ;;
  }

  dimension: part_total_retail_price {
    type: number
    hidden: yes
    sql: ${TABLE}."part.total_retail_price" ;;
  }

  dimension: part_count {
    type: number
    sql: ${TABLE}."part.count" ;;
  }

  dimension: brand_rank {
    type: string
    sql: ${TABLE}."BRAND_RANK" ;;
  }

  parameter: top_rank_limit {
    view_label: " TOTT | Top N Ranking"
    type: unquoted
    default_value: "5"
    allowed_value: {
      label: "Top 5"
      value: "5"
    }
    allowed_value: {
      label: "Top 10"
      value: "10"
    }
    allowed_value: {
      label: "Top 15"
      value: "15"
    }

  }

  dimension: brand_name_top_brands {
    view_label:  "TOTT | Top N Ranking"
    order_by_field: brand_rank_top_brands
    type: string
    sql:
      CASE
        WHEN ${brand_rank}<={% parameter top_rank_limit %} THEN ${part_p_brand}
        ELSE 'Other'
      END
    ;;
  }

  dimension: brand_rank_top_brands {
    view_label:  "TOTT | Top N Ranking"
    type: string
    sql:
      CASE
        WHEN ${brand_rank}<={% parameter top_rank_limit %}
          THEN
            CASE
              WHEN ${brand_rank}<10 THEN  0 || cast(${brand_rank} as varchar)
              ELSE to_char(${brand_rank})
            END
        ELSE 'Other'
      END
    ;;
  }

  parameter: brand_rank_measure {
    view_label: " TOTT | Top N Ranking"
    type: unquoted
    default_value: "total_retail_price"
    allowed_value: {
      label: "total_retail_price"
      value: "total_retail_price"
    }

  }

  measure: dynamic_measure {
    view_label: " TOTT | Top N Ranking"
    label_from_parameter: brand_rank_measure
    type: sum
    sql:
      {% if brand_rank_measure == "total_retail_price" %} ${part_total_retail_price}
      {% else %}  ${part_total_retail_price}
      {% endif %}
    ;;
  }



  set: detail {
    fields: [part_p_brand, part_total_retail_price, part_count]
  }
}
