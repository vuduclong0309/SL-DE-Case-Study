-- Sample SQL Table Creation Script--

-- Note: this SQL is only for demonstration, syntax might not
-- completely right

--
-- Table structure for table products
--

--Spark SQL
-- We save ods snapshot table for retaining correct historical value
-- when rerun if we should
INSERT OVERWRITE TABLE ods_order PARTITION (grass_date)
SELECT
    *,
    {bizdate} AS grass_date
FROM
    orders
WHERE
    orders.order_date == {bizdate}

-- DML for other table should be more or less similar
