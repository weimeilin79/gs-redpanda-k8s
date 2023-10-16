In this scenario, we looked at a simple batch ETL pipeline in action. 

There, whenever the source database is updated, you have to manually run the Python job to calculate the top selling products and write them to the target database, Postrgres. That can be avoided if we use an orchestrator like Apache Airflow or Dagster to schedule the ETL job. We have omitted that in the scenario to make it simpler.

Even if the pipeline is scheduled, it runs on slightly old data, producing delayed insights. This can be eliminated by switching from a batch to streaming ETL pipeline where it does the processing as data arrives. 

We will see that in the next lab.