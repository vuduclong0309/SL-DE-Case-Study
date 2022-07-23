# SecretLab Data Engineering Case Study

## Key facts:
- Source data: 6 tables, not wide (<10 columns), details in Create_DB_tables_pg.
- Business oriented data.
- Assume the number of maintainer is 1 and time factor is considered.


- Largest amount of processing data: 20-30M order, data is not too large, normalize can be optional
- Appear to be in infancy stage (can be enriched by external API to come), full scope is not clear yet.


## Design consideration:
- Preferred Data Warehouse choice: Kimball model, for:
  - Business process oriented, allow deep insight
  - Faster deployment

  - Maintainance is not too much higher (at the moment)
    - For change in process, new satellite DataMart can be implemented.
  - Data redundancy not significant

### Business requirement study

- Business Process to model: Order sale by customers

- Granularity:
  - Lowest: per item in an order of a Customer.

- Involved entities: Product, Item, Order, Customer, Date

Required metrics:
- Additive: Revenues & Item sold
- Non-additive: Price Changes (?) need more elaboration, assume to be a record of changes in price of an item.

|             | Date   | Products | Orders | Orders_item | Customer | Departments / Categories ... |
| :---          |:---: |  :---:   |  :---: |   :---:     |  :---:   |    :---:  |
| Item Sold     |  x   |    x     |        |             |    x     |           |
| Revenues      |  x   |    x     |        |             |    x     |           |
| Price changes |  x   |    x     |        |             |          |           |
