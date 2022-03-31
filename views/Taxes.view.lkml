# include: "prudhvi_yadav.model.lkml"

  view: taxes_details {
    derived_table: {
      explore_source: customer {
        column: p_brand { field: part.p_brand }
        column: o_totalprice { field: orders.o_totalprice }
        column: p_retailprice { field: part.p_retailprice }
        derived_column: taxes {
          sql: o_totalprice - p_retailprice ;;
        }
      }
    }
    dimension: p_brand {}
    dimension: o_totalprice {
      type: number
    }
    dimension: p_retailprice {
      type: number
    }
    measure: count {
      type: count
      drill_fields: []
    }
  }
