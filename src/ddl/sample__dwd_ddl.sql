-- Sample SQL Table Creation Script--

-- Note: this SQL is only for demonstration, syntax might not
-- completely right

-- Notes: dwd_order_item_revenue is almost similar, we wont list
-- We separate to minimize impact for table rerun.
CREATE TABLE dwd_orders_item_item_sold_di (
  customer_id INT NOT NULL,
  order_item_id INT NOT NULL,
  product_id INT NOT NULL,
  item_sold INT NOT NULL,
  grass_hour INT NOT NULL,
  grass_date DATE NOT NULL,
  PRIMARY KEY (order_item_id),
  PARTITION KEY (grass_hour),
  PARTITION KEY (grass_date)
);

-- Fact table for price changes
CREATE TABLE dwd_products_price_changes_df (
  product_id INT NOT NULL,
  price_before INT NOT NULL,
  price_after INT NOT NULL,
  grass_hour INT NOT NULL,
  grass_date DATE NOT NULL,
  PRIMARY KEY (order_item_id),
  PARTITION KEY (grass_hour),
  PARTITION KEY (grass_date)
);
