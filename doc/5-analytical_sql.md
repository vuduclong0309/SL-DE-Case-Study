# SecretLab Data Engineering Case Study
## Analytical SQL

## SQL with base architecture
### Only creating dws_1d table
~~~~sql
WITH product_sale_day_l60d AS
(
    SELECT
        product_id,
        SUM(
          CASE
            WHEN item_sold > 0 THEN 1
            ELSE 0
          END) AS day_with_item_sold
    FROM dwd_products_item_sold_1d
    WHERE grass_date >= DATEADD({bizdate}, -60)
    GROUP BY product_id
),
product_sale_l7d AS
(
  SELECT
      product_id,
      SUM(item_sold) AS item_sold
  FROM dwd_products_item_sold_1d
  WHERE grass_date >= DATEADD({bizdate}, -7)
  GROUP BY product_id
),
product_has_stopped_selling AS
(
    SELECT
        product_id,    
    FROM
        product_sale_day_l60d
    LEFT JOIN
        product_sale_l7d
        ON product_sale_day_l60d.product_id == product_sale_l7d.product_id
    WHERE product_sale_day_l60d.day_with_item_sold >= 30
        AND (product_sale_l7d.item_sold == 0
            OR product_sale_l7d.item_sold IS NULL)
)
SELECT
    {bizdate} AS date,
    product_has_stopped_selling.product_id,
    SUM(item_sold) AS total_item_sold,
    SUM(
      CASE
        WHEN item_sold > 0 THEN 1
        ELSE 0
      END) AS day_with_sales,
    SUM(
      CASE
        WHEN item_sold == 0 THEN 1
        ELSE 0
      END) AS day_with_no_sales,
FROM
    product_has_stopped_selling
INNER JOIN
    dwd_products_item_sold_1d
    ON product_has_stopped_selling.product_id == dwd_products_item_sold_1d.product_id
~~~~

If we want to query item for all days, it is best to run this query per date to avoid expensive table joining.

## Implmenting Business logics in Data Marts
In term of optimal, notice that there is a new business requirement: item stopped selling, there is a new process this mart didn't capture: number of days with sales.

The bus matrix can be extended for this metrics "day_with_sales".

Moreover, we also should include 7d / 60d / td timewindow for better, should those information is frequently used.

*Note: td mean till date

In short, we can add these table:
- dwd_products_days_with_sales_60d
- dwd_products_item_sold_7d
- dwd_products_item_sold_td

Then this business logic could be simplified into:

~~~~sql
SELECT
    {bizdate} AS date,
    product_id,
    sales_day_l60d.product_id,
    sales_td.item_sold,
    sales_day_l60d.day_with_sales
    60 - sales_l60d.day_with_sales as day_with_no_sales_recent,
FROM
    dwd_products_days_with_sales_60d sales_day_l60d
LEFT JOIN
    dwd_products_item_sold_7d sales_7d
      ON sales_day_l60d.product_id == sales_7d.product_id
LEFT JOIN
    dwd_products_item_sold_td sales_td
      ON sales_day_l60d.product_id == sales_td.product_id
WHERE sales_7d.item_sold == 0 AND sales_day_l60d.day_with_sales > 30
~~~~
