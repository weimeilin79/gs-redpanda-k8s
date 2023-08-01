Topics are sub-divided into smaller units, called **partitions**. Partitions allow topics to grow
very large (beyond the size of a single broker) since they can be distributed and replicated across different machines. They also allow cooperating consumers to share the read workload for a given topic.

The partition count should be chosen based on the specific requirements and characteristics of your use case. You'll need to consider factors such as cluster size, message throughput, data size, and your desired consumer parallelism.

The latter item (desired consumer parallelism) is probably the easiest for application developers to reason about, and selecting a number between `4` and `100` should be sufficient for most use cases. In general<sup>*</sup>, higher partition counts improve scalability and throughput. Always plan for growth when selecting a partition count.

<sub>*Too many partitions can increase resource overhead, file handles, and end-to-end latency.</sub>
