# SecretLab Data Engineering Case Study
This section is a test of your conceptual data engineering understanding - you may code this out for illustration, or you may choose to simply discuss the issues with diagrams and sample code.
## Data Modelling
Create_DB_tables_pg.sql depecits how the data should be formatted after landing; how would you architecture base layer for OLAP purposes.
Assume the business will need to perform frequent analysis of:
- Revenue
- Item Sales
- Price Changes
- By Product
- By Customer
- By Date
Discuss your architecture considerations as well as pk/fks (soft or hard), indexes and partitions where appropraite - you may assume the real orders table is about 20-30 M records
What other helper tables would you build into the data warehouse?
## Data Pipelining
### Pipelining
How would you push these data sets assume each new file is incremental from S3 into
1. Provide a DAG or ochestration diagram 
2. This is not a docker skill test - you may use (AWS MWAA)
### Error Handling
1. Something is wrong with the data set when you attempt to load it - can you spot the problem is? 
2.  How would you go about handling the problem? Illustrate with some sample code.
## Analytical SQL
### Select Query
Sometimes products for whatever reason stop selling and a symptom can be an item that was selling well faces a stock out or de-listing (or something else). Write a query that shows products that have sold for more than 30 days in the last 60 days, but hasn't had sales for the last week.
1. Date
2. Product_id
3. Total Items sold to date 
4. number of days with sales
5. number of dates in the recent history where sales have ceased
### Implmenting Business logics in Data Marts
What would be the best way to implment this in Date/Product_id/Sum(sales)... type Data Mart with other sales information (i.e. without filters and group by)?
