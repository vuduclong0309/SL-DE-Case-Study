#Physical Design

## Final touch on table declaration
- All dim, dwd & dws table has been declared
- Now we have to cater for problem when a job might fail or need historical backfill.
  - For table such as orders / orders_item, which order status might change overtime, we need to build additional ods tables to keep snapshot.

- Other tables like user & products we will assume to not have modification, thus dim table should be sufficient.

This led into our final physical design, shown in 3-physic_design.png
