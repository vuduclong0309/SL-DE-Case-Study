-- Sample SQL Table Creation Script--

-- Note: this SQL is only for demonstration, syntax might not
-- completely right

-- Notes: other dws table are almost similar, we wont list
-- We separate to minimize impact for table rerun.
CREATE TABLE dws_product_item_sold_1d (
  product_id INT NOT NULL,
  grass_date DATE NOT NULL,
  PRIMARY KEY (order_item_id),
  PARTITION KEY (grass_date)
);
