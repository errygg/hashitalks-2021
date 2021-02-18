#!/bin/sh

echo "Starting MySql server..."
brew services start mysql

sleep 5

mysql -u root < mysql.sql
