-- Sample SQL Table Creation Script--

-- Note: this SQL is only for demonstration, syntax might not
-- completely right

--
-- Table structure for table products
--

--Spark SQL
INSERT OVERWRITE TABLE dws_product_item_sold_1d PARTITION (grass_date)
SELECT
  customer_id,
  SUM(item_sold) AS item_sold,
  {bizdate} AS grass_date,
FROM
    dwd_orders_item_item_sold_di
WHERE
    grass_date == {bizdate}
GROUP BY
    customer_id, grass_date
-- DML for other 1d table should be more or less similar

INSERT OVERWRITE TABLE dws_product_item_sold_7d PARTITION (grass_date)
SELECT
  customer_id,
  SUM(item_sold) AS item_sold,
  {bizdate} AS grass_date,
FROM
    dws_product_item_sold_1d
WHERE
    grass_date >= DATEADD({bizdate}, -7)
GROUP BY
    customer_id, grass_date
-- DML for other 1d table should be more or less similar to above
