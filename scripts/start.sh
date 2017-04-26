#!/bin/bash

## Generate keys if they do not exist
if [[ ! -f /opt/postal/config/signing.key ]]; then
	/opt/postal/app/bin/postal initialize-config
fi

## Use augeas to set the MySQL/RabbitMQ setup

## Run
