# If necessary, uncomment the line below to include explore_source.

# include: "prudhvi_yadav.model.lkml"

view: Top_N_Brands {
  derived_table: {
    explore_source: customer {
      column: p_brand { field: part.p_brand }
      column: total_retail_price { field: part.total_retail_price }
      column: count { field: part.count }
      derived_column: brand_rank {
        sql: rank() over (order by total_retail_price desc) ;;
      }
    }
  }
  dimension: p_brand {
    primary_key: yes
    type: string
    sql: ${TABLE}."P_BRAND";;
  }
  dimension: total_retail_price {
    type: number
    sql:${TABLE}."TOTAL_RETAIL_PRICE"  ;;
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
        WHEN ${brand_rank}<={% parameter top_rank_limit %} THEN ${p_brand}
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

  dimension: count {
    type: number
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
      {% if brand_rank_measure == "total_retail_price" %} ${total_retail_price}
      {% else %}  ${total_retail_price}
      {% endif %}
    ;;
  }
}
