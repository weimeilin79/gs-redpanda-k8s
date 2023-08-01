Before you create the output topic, let's explore some other statements.

Run the following statements individually inside of the SQL shell, hitting `<Enter>` after each one.

- List the tables
    ```sql
    SHOW TABLES ;
    ```{{copy}}
- Describe the `names` table:
    ```sql
    DESCRIBE names ;
    ```{{copy}}
- View the records in the `names` table:
    ```sql
    SELECT * FROM names ;
    ```{{copy}}

Note: this last statement will take a few seconds to return a result. By using a `SELECT` statement, you just submitted a stream processing job to your Flink cluster.

In a previous step, you opened the Flink UI in a separate tab. Now, go back to that tab and click on the __Jobs -> Running Jobs__ link. You'll see your job running.

Go back to the Flink SQL shell, and hit `Ctrl-C`{{}} to interrupt the job. Then, back to the UI. Your job will no longer appear in the `Running` state since you stopped it. But if you visit the __Jobs -> Completed Jobs__ page, you'll see that it was `Canceled`.
