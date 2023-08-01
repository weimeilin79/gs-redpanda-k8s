You can run a consumer from the commandline using `rpk`.

For example, to consume data from the `names` topic, run the following command:

```
rpk topic consume names
```{{exec interrupt}}

You should see the messages that you published earlier being printed to the console. Note that the consumer keeps running until you interrupt it. Redpanda streams are **unbounded**, and theoretically infinite. Therefore, consumers will continue to wait for new messages.

To stop the consumer, hit `Ctrl+C` to exit.
