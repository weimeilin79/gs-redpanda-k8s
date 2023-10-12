

curl -X POST -H "Content-type: application/json; artifactType=AVRO" -H "X-Registry-ArtifactId: share-price" --data '{"type":"record","name":"price","namespace":"com.example","fields":[{"name":"symbol","type":"string"},{"name":"price","type":"string"}]}' http://localhost:8081/apis/registry/v2/groups/my-group/artifacts


curl -X POST -H "Content-Type: application/json; artifactType=AVRO" \
  -H "X-Registry-ArtifactId: movie" \
  --data '{"namespace": "org.demo","type": "record","name": "Movie","fields": [{"name": "title",type": "string"},{"name": "year","type": "int"}]}' \
  localhost:8081/apis/registry/v2/groups/rp-group/artifacts

curl http://localhost:8081/apis/registry/v2/groups 


docker exec -it assets-kafka-1 kafka-console-consumer --bootstrap-server localhost:29094 --topic movies




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