# If necessary, uncomment the line below to include explore_source.

# include: "prudhvi_yadav.model.lkml"

view: cumulative_totals {
  derived_table: {
    explore_source: customer {

      column: p_partkey { field: part.p_partkey }
      column: p_brand { field: part.p_brand }
      column: p_retailprice { field: part.p_retailprice }
      column: cumulative_total_revenue { field: part.cumulative_total_revenue }

      derived_column: ranking {
        sql: rank() over (order by part.cumulative_total_revenue desc)  ;;
      }

    }
  }
  dimension: p_partkey {
    type: number
    primary_key: yes
    sql: ${TABLE}."P_PARTKEY" ;;
  }
  dimension: p_brand {
    type: string
    hidden: yes
    sql: ${TABLE}."P_BRAND" ;;

  }
  dimension: p_retailprice {
    type: number
    hidden: yes
    sql: ${TABLE}."P_RETAILPRICE" ;;
  }
  dimension: cumulative_total_revenue {
    type: number
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
      label: "Top 20"
      value: "20"
    }
    allowed_value: {
      label: "Top 50"
      value: "50"
    }
  }
}
