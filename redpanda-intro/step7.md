If you run the following command multiple times, you'll notice that the same messages get printed to the screen. Click the following snippet a few times to confirm this.

```
rpk topic consume names
```{{exec interrupt}}

If you want to **commit** your progress, you'll need to explicitly set a consumer group. This is true not only for `rpk`, but for stream processing frameworks like Apache Flink and for streaming ETL frameworks like Kafka Connect.

To specify a group called `my-group`, run the following command:

```
rpk topic consume names --group my-group
```{{exec interrupt}}


You should see the messages that you published in the previous step get printed to the console again. Now re-run the command:


```
rpk topic consume names --group my-group
```{{exec interrupt}}

You won't see any new messages appear unless you produce new messages to the `names` topic. That's because the consumer's progress has been committed and it won't reprocess the data.

To stop the consumer, hit `Ctrl+C` to exit.
