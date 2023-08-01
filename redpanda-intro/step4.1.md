You can also edit topics once they've been created. For example, if you describe the `greetings`{{}} topic, you'll see that it has a default retention period of `604800000` ms, or _7 days_.

```
# describe the 'greetings' topic
rpk topic describe greetings | grep -e cleanup -e retention.ms
```{{exec}}

If you want to store data for a longer period of time, you can update the `retention.ms` setting. Run the following command to update the retention for the `greetings` topic to _14 days_ (i.e. `1209600000` ms).

```
rpk topic alter-config greetings \
    --set retention.ms=1209600000
```{{exec}}

Describe the topic again to view your changes:

```
rpk topic describe greetings | grep -e cleanup -e retention.ms
```{{exec}}

You can view a list of topic configuration properties in <a href="https://docs.redpanda.com/docs/reference/topic-properties/" target="_blank">the official Redpanda docs</a>.