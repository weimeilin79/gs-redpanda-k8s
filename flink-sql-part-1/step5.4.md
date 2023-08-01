The last step is to simply verify that the Flink pipeline is producing messages to the output topic.

You can inspect the `greetings` topic using `rpk`. Run the following command to do so:

```sh
# consume the messages and only print the value
rpk topic consume greetings -f '%v\n'
```{{exec}}

You should see the following records:

```json
{"greeting":"Hello, Round Robin Publishing","processing_time":"2023-07-28 16:14:24.494Z"}
{"greeting":"Hello, Redpanda","processing_time":"2023-07-28 16:14:24.543Z"}
{"greeting":"Hello, Alpaca","processing_time":"2023-07-28 16:14:24.545Z"}
{"greeting":"Hello, Flink","processing_time":"2023-07-28 16:14:24.538Z"}
```{{}}