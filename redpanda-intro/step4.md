Topics are distinguished by their cleanup policy. Clean up policies are configured using the `cleanup.policy` config.

- **Regular topics** (or, _non-compacted topics_) retain data up to a configurable size or time limit. They are configured with `cleanup.policy=delete`{{}}
- **Compacted topics** retain *at least* the last known value for a given record key. They are configured with `cleanup.policy=compact`{{}} or `cleanup.policy=delete,compact`{{}}

All of the topics you've created so far are regular topics, since the default cleanup policy is `delete`. Now, create a compacted topic called `users` by passing in the relevant topic config (`-c cleanup.policy=compact`):

```
rpk topic create users \
    -c cleanup.policy=compact
```{{exec}}

If you describe the `users` topic with the following command, you'll see the `cleanup.policy` reflects the topic type (`compact`).

```
rpk topic describe users
```{{exec}}
