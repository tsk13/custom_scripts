#!/bin/bash
#Author - Tamil Selvan K
#Script to Install the Postgres database
#Cloudera Inc.
###########################################

echo 'Installing Postgres database with Script for DAS'

##### Incomplete -- Work in Progress #######

### Auto Setup Postgres db for DAS

yum -y install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

yum -y install postgresql96-contrib postgresql96-server

/usr/pgsql-9.6/bin/postgresql96-setup initdb


echo 'local   all             dasuser                              md5
host    all             dasuser      0.0.0.0/0               md5
host    all             dasuser      ::/0                    md5
local   all             postgres         ident' >> /var/lib/pgsql/9.6/data/pg_hba.conf


sed -i 's/#listen_addresses =*/listen_addresses = '*'/' /var/lib/pgsql/9.6/data/postgresql.conf

echo 'starting postgres service' | service postgresql-9.6 start

sleep 1

echo 'Setting up the Postgres database for Das' | sudo su postgres -

psql -tc "SELECT 1 FROM pg_database WHERE datname = dasdb" | grep 1 || (
psql -c "CREATE ROLE dasuser WITH LOGIN PASSWORD daspwd;" &&
psql -c "ALTER ROLE dasuser SUPERUSER;" &&
psql -c "ALTER ROLE dasuser CREATEDB;" &&
psql -c "CREATE DATABASE dasdb;" &&
psql -c "GRANT ALL PRIVILEGES ON DATABASE dasdb TO dasuser;")

echo 'DAS Postgres database Installed and Started Successfully'
