Using `rpk`{{}}, you can perform all of the CRUD operations (create, read, update, and delete)
on Redpanda topics. For example, to create a topic, you can run the `rpk topic create [topic-names] -p [partition-count]` command.

Run the following command to create three topics: `names`, `greetings`, and `purchases`. Each of these topics will contain four partitions.

```
rpk topic create names greetings purchases -p 4
```{{exec}}

You should see the following output:

```
TOPIC      STATUS
names      OK
greetings  OK
purchases  OK
```{{}}


Now, spend some time learning about the other `rpk topic` sub-commands by running `rpk topic --help`{{exec}}. Here are some example commands you can try:

```
# list the topics
rpk topic list
```{{exec}}

```
# delete a topic
rpk topic delete purchases
```{{exec}}
```
# describe a topic
rpk topic describe greetings
```{{exec}}