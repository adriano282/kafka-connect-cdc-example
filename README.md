# Simple Demonstration of CDC using Kafka Connect

This project is simple implementation of a CDC for SQLServer using Kafka Connect and MongoDB as sink

It's structured using Docker containers and docker-compose orquestrator.

## Kafka Web Interfaces
- [Landoop] UI (http://localhost:3030)

## Kafka REST Apis
- [Kafka Schema Registry] (http://localhost:8081)
- [Kafka REST] (http://localhost:8082)
- [Kafka Connect] (http://localhost:8083)

## Internal Compoenents
- [Kafka Broker] 
   internal host: kafka-systems
   internal port: 9092

- [MongoDB]
   
  replica1
  * internal host: mongo1
  * internal port: 27017

  replica2 (commented)
  * internal host: mongo2
  * internal port: 27017

  replica3 (commented)
  - internal host: mongo2
  - internal port: 27017

- [SQLServer]

  internal host: sqlserver
  internal port: 1433

## Database Interfaces

- [MongoDB] (http://localhost:8011)
- SQLServer
  ```docker-compose -f docker-compose.yml exec sqlserver bash -c '/opt/mssql-tools/bin/sqlcmd -U sa -P $MSSQL_SA_PASSWORD -d kafkaconnect'
```

## How to run the project

```bash
./run.sh
```

## Reference

[Mongo DB Kafka] (https://github.com/mongodb/mongo-kafka)

## License
Free to use and change for your own purposes.
