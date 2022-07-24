-- Sample SQL Table Creation Script--

-- Note: this SQL is only for demonstration, syntax might not
-- completely right

--
-- Table structure for table products
--

--Spark SQL
INSERT OVERWRITE TABLE dwd_orders_item_item_sold_di PARTITION (grass_date, grass_hour)
SELECT
    ods_order_items.order_item_id,
    ods_order_items.item_sold,
    dim_customer.customer_id,
    dim_products.product_id,
    {bizdate_hour} AS grass_hour,
    {bizdate} AS grass_date,
FROM
    ods_order_items
LEFT JOIN
    ods_order
    ON ods_order_items.order_item_order_id == ods_order.order_id
LEFT JOIN
    dim_customer
    ON ods_order.customer_id == dim_customer.customer_id
LEFT JOIN
    dim_products
    ON ods_order_items.order_item_product_id = dim_products.product_id
WHERE
    ods_order.order_date == {bizdate} AND ods_order.order_status IN ('COMPLETED', etc...)

-- DML for other table should be more or less similar
