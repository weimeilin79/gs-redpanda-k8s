Sometimes, you'll want to check to make sure your consumers are online and healthy.

You can inspect consumer groups using the `rpk group` sub-command.

Go ahead and try a few commands:

```
# list the consumer groups
rpk group list
```{{exec interrupt}}

```
# describe a consumer group
rpk group describe my-group
```{{exec}}

You can also update the position of the consumer group to either:

- Rewind to the beginning of a topic:
    ```
    # rewind
    rpk group seek my-group \
        --topics names \
        --to start
    ```{{exec}}

    After rewinding, you can re-consume the records:
    ```
    # re-consume from the new position
    rpk topic consume names --group my-group
    ```{{exec}}

- Fast-forward to the end of a topic:
    ```
    # fast-forward
    rpk group seek my-group \
        --topics names \
        --to end
    ```{{exec}}
- Or even to start reading from a specific point in time:
    ```
    # helper function to get a timestamp (epoch in ms) for x minutes ago
    minago () {
        echo $(($(date +"%s000 - ($1 * 60000)")))
    }

    rpk group seek my-group \
        --topics names \
        --to $(minago 10)
    ```{{exec}}
