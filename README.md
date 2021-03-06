# Example of Change Data Capture using Kafka Connect

This project is a example implementation of a CDC for SQLServer using Kafka Connect and MongoDB as sink.

It's structured using Docker containers and docker-compose orquestrator tool.

The base docker image used to create the Kafka cluster and related systems is landoop/fast-data-dev (https://github.com/lensesio/fast-data-dev).
It creates the Kafka Broker, Zookeeper, Schema Registry, REST Proxy and Kafka Connect Distributed.

The MSSql Server Source connector used is from Debezium (https://debezium.io/). 
The MongoDB Sink is from MongoDB (https://docs.mongodb.com/kafka-connector/current/).

## Requirements
- [docker-compose] (https://docs.docker.com/compose/install/)
- [docker] (https://docs.docker.com/get-docker/)

## Kafka Web Interfaces 
- [Landoop] UI (http://localhost:3030)

## Kafka REST Apis
- [Kafka Schema Registry] (http://localhost:8081)
- [Kafka REST] (http://localhost:8082)
- [Kafka Connect] (http://localhost:8083)

## Internal Components
- [Kafka Broker] 
- [MongoDB]   
- [SQLServer]

## Database Interfaces

- [MongoDB] (http://localhost:8011)
- SQLServer

```
docker-compose -f docker-compose.yml exec sqlserver bash -c '/opt/mssql-tools/bin/sqlcmd -U sa -P $MSSQL_SA_PASSWORD -d kafkaconnect'

```

## How to run the project

```
cd kafka-connect-cdc-example && ./run.sh

```

## Table with CDC enabled
```
docker-compose -f docker-compose.yml exec sqlserver bash -c '/opt/mssql-tools/bin/sqlcmd -U sa -P $MSSQL_SA_PASSWORD -Q "select * from kafkaconnect.dbo.teste"'

```

## Inserting test data to see the replication

```
docker-compose -f docker-compose.yml exec sqlserver bash -c \
'/opt/mssql-tools/bin/sqlcmd -U sa -P $MSSQL_SA_PASSWORD -Q "insert into kafkaconnect.dbo.teste(numero, numerogrande, dinheiro, decimo, numeral) values (1,2,3,4,5)"'

```




## Reference

[Mongo DB Kafka] (https://github.com/mongodb/mongo-kafka)

## License
Free to use and change for your own purposes.
