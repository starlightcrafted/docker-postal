#!/bin/bash

## Generate config
if [ ! -f /opt/postal/config/postal.yml ] || [[ $(cat /opt/postal/config/postal.yml | wc -l) < 2 ]]; then
	## Build Jinja2 Template
	j2 /templates/postal.example.yml.j2 > /opt/postal/config/postal.example.yml
	## Add in secret key building
	echo "rails:" >> /opt/postal/config/postal.example.yml
	echo "  secret_key: {{secretkey}}" >> /opt/postal/config/postal.example.yml
	## Generate config and keys
	/opt/postal/bin/postal initialize-config
fi

## Clean Up
rm -rf /opt/postal/tmp/pids/*

## Wait for MySQL to start up
echo "== Waiting for MySQL to start up =="
while ! mysqladmin ping -h mysql --silent; do
    sleep 0.5
done

## Start Postal
/opt/postal/bin/postal "$@"
