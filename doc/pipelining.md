# SecretLab Data Engineering Case Study

## Pipelining
How would you push these data sets assume each new file is incremental from S3 into
1. Provide a DAG or ochestration diagram
- Tech of choice: Airflow
- Deploy 4 Airflow DAG, each dag for 1 layer of tables (or dim & ods table can be merged into 1 DAG)
- DWD should have ExternalTaskSensor waiting for DIM / ODS dag, DWS should wait for DWD
- Demo Airflow code can be found in src/airflow folder
