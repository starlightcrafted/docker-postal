#!/bin/bash

## Clean Up
rm -rf /opt/postal/tmp/pids/*
rm -rf /tmp/postal

## Check if existing config
if [ $(ls /storage | wc -l) > 0 ]; then
  cp /storage/* /opt/postal/config/*
fi

## Generate config
if [ ! -f /opt/postal/config/postal.yml ] || [[ $(cat /opt/postal/config/postal.yml | wc -l) < 2 ]]; then
  ## Build Jinja2 Template
  p2 -t /templates/postal.example.yml.j2 -o /opt/postal/config/postal.example.yml
  ## Add in secret key building
  echo "rails:" >> /opt/postal/config/postal.example.yml
  echo "  secret_key: {{secretkey}}" >> /opt/postal/config/postal.example.yml
  ## Generate config and keys
  /opt/postal/bin/postal initialize-config
  ## Wait for MySQL and RabbitMQ to start up
  echo "== Waiting for MySQL and RabbitMQ to start up =="
  dockerize -timeout 60m -wait tcp://mysql:3306 -wait tcp://rabbitmq:5672
  /opt/postal/bin/postal initialize
  /create-user.sh
  ## Copy over config to persistent storage
  cp /opt/postal/config/postal.yml /storage/postal.yml
  cp /opt/postal/config/fast_server.cert /storage/fast_server.cert
  cp /opt/postal/config/fast_server.key /storage/fast_server.key
  cp /opt/postal/config/lets_encrypt.pem /storage/lets_encrypt.pem
  cp /opt/postal/config/signing.key /storage/signing.key
else
  ## Wait for MySQL and RabbitMQ to start up
  echo "== Waiting for MySQL and RabbitMQ to start up =="
  dockerize -timeout 60m -wait tcp://mysql:3306 -wait tcp://rabbitmq:5672
fi
## Start Postal
/opt/postal/bin/postal "$@"
