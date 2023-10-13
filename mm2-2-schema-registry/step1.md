Welcome to the lab! Here, we'll dive into migrating your schema registry, shifting from Confluent to Redpanda. If you're curious about data replication to a new cluster, refer to this [lab](https://killercoda.com/redpanda/scenario/mm2-1-replication).

### Initial Environment
Let's first get a feel for our environment. Fire this up:
```
docker ps --format '{{.Names}}'
```

You should notice three running components - a Kafka broker, Zookeeper, and the Confluent schema registry. 
```
View 3 docker images
```

Before making any move, let’s first check out the current state of our Confluent Schema Registry. The initial step? Ensuring if it has any registered schemas:

To check if the registry is empty, use the following command to call the API on the registry:
```
curl -X GET http://localhost:8081/subjects

```

It fetches all subjects (or topics) for which schemas have been registered. If the output is an empty array [], your registry is empty.
```
[]
```

While auto-registering a schema during topic publishing is feasible, we'll try the manual route first:

```
curl -X POST 'http://localhost:8081/subjects/podcast/versions' --header 'Content-Type: application/vnd.schemaregistry.v1+json' --data '{\"schema\": \"{\"namespace": \"org.demo\",\"type\": \"record\",\"name\": \"Podcast\","fields\": [{\"name\": \"title\",\"type\": \"string\"},{\"name\": \"month\",\"type\": \"string\"},{\\"name": \"host\",\"type\": \"string\"}]}"}'
```

Validate its registration with:
```
curl -X GET http://localhost:8081/subjects
```

You should be able to see 

Naming 

### Start producer and register schema

Let's now try automatically register it by setup the producer, we will will use Quarkus, a popular Java framework, to set up our Kafka producer and integrate it with Avro schemas. If you're unfamiliar with Avro, it not only provides a compact and rich data structure but also good in its support for schema evolution. This means you can modify your data schema over time without worrying about breaking compatibility.

When Avro is coupled with Schema Registry, it ensures that producers and consumers have a unified understanding of the data format, which further guarantees data integrity and compatibility. Here's the magic: the schema registry will store our Avro schemas, and this aids Producer & consumer in efficiently serializing and deserializing messages. Embracing Avro with Schema Registry equips us with both backward and forward compatibility, streamlining the evolution of data models and associated applications.

Let's get started, navigate to the editor tab. In the left explorer panel, drill down to the directory path _quarkus-apps/avro-schema-producer/src/main_. Within this directory, create a new folder named **avro**. Inside this newly-minted folder, create a file with the name **movie.avsc**. Now, populate this file with the following content:
```
{
  "namespace": "org.demo",
  "type": "record",
  "name": "Movie",
  "fields": [
    {
      "name": "title",
      "type": "string"
    },
    {
      "name": "year",
      "type": "int"
    }
  ]
}
```{{copy}}

After setting up the schema, take a moment to examine the producer. In the same editor tab and left explorer panel, navigate to the directory _quarkus-apps/avro-schema-producer/src/main/java/org/demo_. Here, open the **MovieResource.java** file. You'll observe that, upon initialization, it activates a REST endpoint designed to receive movie data entries, which are then dispatched to a Kafka endpoint named movies.

Click on the **+** icon at the top to add a new tab, labeled _tab 2_. In _tab 2_, initiate the process by executing the following command:

```
cd  cd quarkus-apps/avro-schema-producer/
./mvnw generate-resources
./mvnw install
./mvnw qurakus:run
```

### Start Consumer and download the schema

And we'll need a consumer, our consumer will be grabbing the latest schema from the registry. Go to avro-schema-consumer


```
./mvnw process-resources
```

It'll down load the schema into src/main/avro

Now build
```
./mvnw install
```

```
./mvnw quarkus:run
```

start sending into the topic


```
curl -X POST 'http://localhost:8081/subjects/movies/versions' \
--header 'Content-Type: application/vnd.schemaregistry.v1+json' \
--data '{"schema": "{\"namespace\": \"org.demo\",\"type\": \"record\",\"name\": \"Movie\",\"fields\": [{\"name\": \"title\",\"type\": \"string\"},{\"name\": \"year\",\"type\": \"int\"}]}"}'

curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"title":"The Shawshank Redemption","year":1994}' \
  http://localhost:8080/movies

curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"title":"The Godfather","year":1972}' \
  http://localhost:8080/movies

curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"title":"The Dark Knight","year":2008}' \
  http://localhost:8080/movies

curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"title":"12 Angry Men","year":1957}' \
  http://localhost:8080/movies

```

Now, we are going to migrate what's in the Confluent Registry to Redpanda's so we don't have to maintain 3 separate components to keep the broker running. 