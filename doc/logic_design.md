# SecretLab Data Engineering Case Study

## Bus matrix
|               | Date | Products | Orders | Orders_item | Customer | Departments / Categories ...  |
| :---          |:---: |  :---:   |  :---: |   :---:     |  :---:   |    :---:  |
| Item Sold     |  x   |    x     |        |             |    x     |           |
| Revenues      |  x   |    x     |        |             |    x     |           |
| Price changes |  x   |    x     |        |             |          |           |

As there are multiple of granularity, multilayered architecture are one desirable approach.

## Table selection
- Due to update frequency in minutes or hours, date dimension naturally become a part of partition key. Metrics by date would be available in dws (aggregation table). We put out of the scope temporarily

### Dim Table:
- We choose entity that are related our event of interest which are:
  - dim_products
  - dim_customer

### Fact (dwd) Table
- For other box, each tick describe an event of interest, we build each dwd table for a tick in bus matrix
  - dwd_products_item_sold_di
  - dwd_products_revenue_di
  - dwd_customer_item_sold_di
  - dwd_customer_revenue_di
  - dwd_products_price_changes_df

### Aggregation (dws) Table
- For additive facts (item sold / revenue) we further build table to aggregate with suitable time window. As business require need date, 1d is a nice selection.
  - dwd_products_item_sold_1d
  - dwd_customer_item_sold_1d
  - dwd_products_revenue_di
  - dwd_customer_item_sold_1d

The full data warehouse layers is demonstrated in the image below
