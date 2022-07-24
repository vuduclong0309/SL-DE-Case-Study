# SecretLab Data Engineering Case Study

## Pipelining
How would you push these data sets assume each new file is incremental from S3 into
1. Provide a DAG or ochestration diagram
- Tech of choice: Airflow
- Deploy 4 Airflow DAG, each dag for 1 layer of tables (or dim & ods table can be merged into 1 DAG)
- DWD should have ExternalTaskSensor waiting for DIM / ODS dag, DWS should wait for DWD
- Demo Airflow code can be found in src/airflow folder


## Enrich with external API
### Webhook
- Webhook is event based, each event server will sent info.
- If we use this is update table, updating process is prone to overloading if there are too many event in short timespan

Approach: use info dump file as an output for webhook. From this info dump file we will schedule a reading job and then insert into our database. (refer to the image 4-ingestion_pipeline_with_restapi.png)

### API
- For System with RestfulAPI is request based. We can control how much request to call. However, data is less real time.
- The system design with restAPI would be more standard (refer to the image 4-ingestion_pipeline_with_restapi)

### Webhook vs Api
| RestAPI | Webhook  |
|:---:    |  :---:   |
|  Request based   |    Event based     |
|  Data control by client   |    Data control by server (info by subscription)   |
|  Less real time           |    Real time     |  
|  Request latency can be determined |  Latency based on amount of event |   
|  Transmit overflow is more controllable (still have problem if data block is too big) | More prone to transmit overflow (spike)  |
