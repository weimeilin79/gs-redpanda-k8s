Redpanda applications use the publish-subscribe (pub/sub) communication pattern to pass data
between systems.

Systems that write data to Redpanda topics are called **producers**. Producers don't need to communicate directly with downstream systems that are interested in their data. They simply **publish** the data to Redpanda, allowing any interested parties to subscribe to their data stream.

**Consumers**, on the other hand, **subscribe** to Redpanda topics in order to read data. We'll cover consumers shortly.

Most non-trivial producers and consumers will run *outside* of the Redpanda cluster. For example, stream processing applications written in Flink will run on a separate Flink cluster. WASM scripts are an exception to the rule, but are out of scope for this tutorial.
