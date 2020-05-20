#!/bin/bash

## Clean Up
rm -rf /opt/postal/tmp/pids/*
rm -rf /tmp/postal

## Check if existing config
if [ -f /storage/postal.yml ]; then
  cp /storage/postal.yml /opt/postal/config/postal.yml
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
else
  ## Wait for MySQL and RabbitMQ to start up
  echo "== Waiting for MySQL and RabbitMQ to start up =="
  dockerize -timeout 60m -wait tcp://mysql:3306 -wait tcp://rabbitmq:5672
fi
## Start Postal
/opt/postal/bin/postal "$@"
