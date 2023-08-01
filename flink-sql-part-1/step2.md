The greetings application that you'll be building will read from a source topic called `names`, and produce greetings to an output topic called `greeting`. Therefore, before writing your application, you need to pre-create these topics.

To do so, you'll use Redpanda's CLI: `rpk`.

First, set the following alias so that any invocation of the `rpk`{{}} command
invokes the pre-installed version inside the Docker container.

```
alias rpk="docker-compose exec -T redpanda-1 rpk"
```{{exec}}

Then, create the topics with the following command:

```
rpk topic create names greetings -p 4
```{{exec}}

You should see the following output:

```
TOPIC        STATUS
names        OK
greetings    OK
```{{}}

Now, pre-populate the `names` topic by running:

```
json_records=(
    '{"name": "Flink", "website": "flink.apache.org"}'
    '{"name": "Redpanda", "website": "redpanda.com"}'
    '{"name": "Alpaca", "website": "alpaca.markets"}'
)

for json in "${json_records[@]}"; do
    echo $json | rpk topic produce names --allow-auto-topic-creation
done
```{{exec}}
