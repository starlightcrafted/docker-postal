#!/bin/bash

## Clean Up
rm -rf /opt/postal/tmp/pids/*
rm -rf /tmp/postal

## Wait for MySQL and RabbitMQ to start up
echo "== Waiting for MySQL and RabbitMQ to start up =="
dockerize -timeout 60m -wait tcp://mysql:3306 -wait tcp://rabbitmq:5672

echo "== Building Config =="
echo "postal.yml"
if [ -f /storage/postal.yml ]; then
  rm -f /opt/postal/config/postal.yml
  ln -s /storage/postal.yml /opt/postal/config/postal.yml
elif [ ! -f /opt/postal/config/postal.yml ] || [[ $(cat /opt/postal/config/postal.yml | wc -l) < 2 ]]; then
  ## Build Jinja2 Template
  p2 -t /templates/postal.example.yml.j2 -o /opt/postal/config/postal.example.yml
  ## Add in secret key building
  echo "rails:" >> /opt/postal/config/postal.example.yml
  echo "  secret_key: {{secretkey}}" >> /opt/postal/config/postal.example.yml
  ## Generate config and keys
  /opt/postal/bin/postal initialize-config
  /opt/postal/bin/postal initialize
  /create-user.sh
  ## Copy over config to persistent storage
  cp -p /opt/postal/config/postal.yml /storage/postal.yml
  rm /opt/postal/config/postal.yml
  ln -s /storage/postal.yml /opt/postal/config/postal.yml
fi
echo "fast_server.cert"
if [ -f /storage/fast_server.cert ]; then
  rm -f /opt/postal/config/fast_server.cert
  ln -s /storage/fast_server.cert /opt/postal/config/fast_server.cert
elif [ -f /opt/postal/config/fast_server.cert ] && [ ! -L /opt/postal/config/fast_server.cert ]; then
  cp -p /opt/postal/config/fast_server.cert /storage/fast_server.cert
  rm /opt/postal/config/fast_server.cert
  ln -s /storage/fast_server.cert /opt/postal/config/fast_server.cert
fi
echo "fast_server.key"
if [ -f /storage/fast_server.key ]; then
  rm -f /opt/postal/config/fast_server.key
  ln -s /storage/fast_server.key /opt/postal/config/fast_server.key
elif [ -f /opt/postal/config/fast_server.key ] && [ ! -L /opt/postal/config/fast_server.key ]; then
  cp -p /opt/postal/config/fast_server.key /storage/fast_server.key
  rm /opt/postal/config/fast_server.key
  ln -s /storage/fast_server.key /opt/postal/config/fast_server.key
fi
echo "lets_encrypt.pem"
if [ -f /storage/lets_encrypt.pem ]; then
  rm -f /opt/postal/config/lets_encrypt.pem
  ln -s /storage/lets_encrypt.pem /opt/postal/config/lets_encrypt.pem
elif [ -f /opt/postal/config/lets_encrypt.pem ] && [ ! -L /opt/postal/config/lets_encrypt.pem ]; then
  cp -p /opt/postal/config/lets_encrypt.pem /storage/lets_encrypt.pem
  rm /opt/postal/config/lets_encrypt.pem
  ln -s /storage/lets_encrypt.pem /opt/postal/config/lets_encrypt.pem
fi
echo "signing.key"
if [ -f /storage/signing.key ]; then
  rm -f /opt/postal/config/signing.key
  ln -s /storage/signing.key /opt/postal/config/signing.key
elif [ -f /opt/postal/config/signing.key ] && [ ! -L /opt/postal/config/signing.key ]; then
  cp -p /opt/postal/config/signing.key /storage/signing.key
  rm /opt/postal/config/signing.key
  ln -s /storage/signing.key /opt/postal/config/signing.key
fi

## Start Postal
/opt/postal/bin/postal "$@"
