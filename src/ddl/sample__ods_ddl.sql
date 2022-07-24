-- Sample SQL Table Creation Script--

-- Note: this SQL is only for demonstration, syntax might not
-- completely right

--
-- Table structure for table orders
--

CREATE TABLE ods_orders (
  order_id INT NOT NULL,
  order_date TIMESTAMP NOT NULL,
  order_customer_id INT NOT NULL,
  order_status VARCHAR(45) NOT NULL,
  grass_hour INT NOT NULL,
  grass_date DATE NOT NULL,
  PRIMARY KEY (order_id),
  PARTITION KEY (grass_date)
);

--
-- Table structure for table order_items
--

CREATE TABLE ods_order_items (
  order_item_id INT NOT NULL,
  order_item_order_id INT NOT NULL,
  order_item_product_id INT NOT NULL,
  order_item_quantity INT NOT NULL,
  order_item_subtotal FLOAT NOT NULL,
  order_item_product_price FLOAT NOT NULL,
  grass_hour INT NOT NULL,
  grass_date DATE NOT NULL,
  PRIMARY KEY (order_item_id),
  PARTITION KEY (grass_date)
);
