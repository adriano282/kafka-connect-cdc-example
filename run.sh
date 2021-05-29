echo "Creating external volume ./plugins"
docker volume create --name=plugins

echo "Starting docker ."
docker-compose up -d --build 

function clean_up {
    echo -e "\n\nSHUTTING DOWN\n\n"
    curl --output /dev/null -X DELETE http://localhost:8083/connectors/msserver-source || true
    curl --output /dev/null -X DELETE http://localhost:8083/connectors/mongo-sink || true
    docker-compose exec mongo1 /usr/bin/mongo --eval "db.dropDatabase()"
    docker-compose down
    if [ -z "$1" ]
    then
      echo -e "Bye!\n"
    else
      echo -e $1
    fi
}

sleep 5
echo -ne "\n\nWaiting for the systems to be ready.."
function test_systems_available {
  COUNTER=0
  until $(curl --output /dev/null --silent --head --fail http://localhost:$1); do
      printf '.'
      sleep 5
      let COUNTER+=1
      if [[ $COUNTER -gt 50 ]]; then
        MSG="\nWARNING: Could not reach configured kafka system on http://localhost:$1 \nNote: This script requires curl.\n"

          if [[ "$OSTYPE" == "darwin"* ]]; then
            MSG+="\nIf using OSX please try reconfiguring Docker and increasing RAM and CPU. Then restart and try again.\n\n"
          fi

        echo -e $MSG
        clean_up "$MSG"
        exit 1
      fi
  done
}

test_systems_available 8082
test_systems_available 8083

trap clean_up EXIT

echo -e "\nKafka Topics:"
curl -X GET "http://localhost:8082/topics" -w "\n"

echo -e "\nKafka Connectors:"
curl -X GET "http://localhost:8083/connectors/" -w "\n"

echo -e "\nCreating MongoSink Connector:"
curl -X POST -H "Content-Type: application/json" --data '
{  "name": "mongo-sink",
      "config": {
        "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
        "tasks.max":"1",
        "topics":"sqlserver.dbo.teste",
	"connection.uri":"mongodb://mongo1:27017",
        "database":"sink",
        "collection":"numeros",

        "value.converter.schemas.enable": true,
        "key.converter.schemas.enable": true,
        "value.converter.schema.registry.url": "http://localhost:8081",
        "value.converter": "io.confluent.connect.avro.AvroConverter",
        "key.converter": "io.confluent.connect.avro.AvroConverter",
        "key.converter.schema.registry.url": "http://localhost:8081",
	
        "transforms": "extractValue",
        "transforms.extractValue.type":"org.apache.kafka.connect.transforms.ExtractField$Value",
        "transforms.extractValue.field":"after",
	
	"document.id.strategy":"com.mongodb.kafka.connect.sink.processor.id.strategy.PartialValueStrategy",
	"document.id.strategy.partial.value.projection.list":"numero,numerogrande,decimal,numeral",
	"document.id.strategy.partial.value.projection.type":"AllowList",
	"writemodel.strategy":"com.mongodb.kafka.connect.sink.writemodel.strategy.ReplaceOneBusinessKeyStrategy"

}}' http://localhost:8083/connectors -w "\n"

sleep 5

echo -e "\nCreating MSServer Source Connector:"
curl -X POST -H "Content-Type: application/json" --data '
{  "name": "msserver-source",
      "config": {
       	"tasks.max":"1",
	"connector.class":"io.debezium.connector.sqlserver.SqlServerConnector",
	"database.server.name":"sqlserver",
	"database.dbname":"kafkaconnect",
	"database.hostname":"sqlserver",
	"database.port":"1433",
	"database.user":"sa",
	"database.password":"Testing1122",
	"key.converter":"io.confluent.connect.avro.AvroConverter",
	"key.converter.schema.registry.url":"http://localhost:8081",
	"key.converter.schemas.enable": "true",
	"value.converter":"io.confluent.connect.avro.AvroConverter",
	"value.converter.schema.registry.url":"http://localhost:8081",
	"value.converter.schemas.enable": "true",
	"database.history.kafka.bootstrap.servers":"127.0.0.1:9092",
	"database.history.kafka.topic":"numbers-topic",
	"table.whitelist":"dbo.teste",
	"time.precision.mode":"connect"

}}' http://localhost:8083/connectors -w "\n"

sleep 2
echo -e "\nKafka Connectors: \n"
curl -X GET "http://localhost:8083/connectors/" -w "\n"

echo -e '''
==============================================================================================================
Examine the topics in the Landoop UI: http://localhost:3030

Examine de Mongo Collections in the Mongo Express: http://localhost:8011

Insert Data in SQL Server Teste Table:  
      
      docker-compose -f docker-compose.yml exec sqlserver bash -c '/opt/mssql-tools/bin/sqlcmd -U sa -P \$MSSQL_SA_PASSWORD -d kafkaconnect'
==============================================================================================================

Use <ctrl>-c to quit'''

read -r -d '' _ </dev/tty
