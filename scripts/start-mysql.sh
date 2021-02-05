#!/bin/sh

brew services start mysql

sleep 5

mysql -u root < mysql.sql
