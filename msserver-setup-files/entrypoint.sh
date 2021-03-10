#!/bin/bash

# Start SQL Server
/opt/mssql/bin/sqlservr &

sleep 20
# Start the script to create the DB and user
/usr/config/configure-db.sh

# Call extra command
eval $1
