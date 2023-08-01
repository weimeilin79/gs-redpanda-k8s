In this tutorial, you'll create a "Hello, world" style Flink application, which reads a list of names from a Redpanda topic called `names`, and produces a friendly greeting to an output topic called `greetings`.

For example, given the following input records:

```json
{"name": "Flink", "website": "flink.apache.org"}
{"name": "Redpanda", "website": "redpanda.com"}
{"name": "Alpaca", "website": "alpaca.markets"}
```

Your streaming SQL application will produce the following output:

```json
{"greeting":"Hello, Flink"}
{"greeting":"Hello, Redpanda"}
{"greeting":"Hello, Alpaca"}
```

While this may seem simple, we'll build on these foundational concepts in subsequent tutorials to create more powerful streaming processing applications.

This tutorial is all about understanding the development workflow and the basic tools to help you on your journey.
