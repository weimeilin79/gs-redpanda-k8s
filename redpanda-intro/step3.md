Applications that interact with Redpanda read from and write to Redpanda topics. **Topics**
are named streams that store data. Conceptually, they serve a similar purpose
as tables in a database (though topics do not have schemas).

Some people prefer to put a single type of data in a topic. These are called **homogenous topics**. For example, you could create a topic called `clicks` to store only click events from a website.

You can also combine multiple event types into a single topic. These are called **heterogenous** topics. For example, you could create a topic called `web-events` to hold click events, page views, etc.

You don't need to configure this directly, but it's good practice to name your topics in a way that reflects the scope of what they store.
