
Redpanda comes with a powerful CLI, called `rpk`{{}}. This CLI can be used for:

- Managing topics, consumer groups, ACLs, and cluster configs
- Producing and consuming data
- Deploying WASM scripts for simple, stateless stream processing tasks
- Viewing information about a Redpanda or Kafka cluster
- and more

You've already deployed a local Redpanda cluster, so no separate installation is required
to start using this powerful tool.

To use `rpk`{{}} in this tutorial, set the following alias so that any invocation of
the `rpk`{{}} command invokes the pre-installed version inside the broker container.

```
alias rpk="docker exec -ti redpanda-1 rpk"
```{{exec}}

Now, simply type `rpk`{{exec}} to view the available sub-commands:

```
rpk
```{{exec}}
