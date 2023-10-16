In this scenario, we looked at a streaming ETL pipeline in action.

Using Debezium as the CDC mechanism enabled capturing the changes made to the source database in real time. Once captured, Debezium streamed the changes as event streams into Redpanda, which provided a scalable ingestion capability.

We used Apache Flink to implement the streaming ETL pipeline with Flink SQL as the programming language. Flink Kafka connector enabled Flink to ingest change feeds from Redpanda, process them in real-time, and write the resulting table to Postgres via Flink JDBC connector. 

Significant difference here is that once deployed, this pipeline (Flink application) continues to run, computing top selling products, and updating the Postgres table continuously. That provides businesses near real-time insights into what's happening with their business and enalbing them to act fast.