-- Sample SQL Table Creation Script--

-- Note: this SQL is only for demonstration, syntax might not
-- completely right

--
-- Table structure for table products
--

--Spark SQL
INSERT OVERWRITE TABLE dim_products
SELECT
    product_id,
    product_category_id,
    product_name,
    product_description,
    product_price,
    product_image,
FROM
    products

-- DML for other table should be more or less similar
