#!/bin/bash

## Clean Up
rm -rf /opt/postal/tmp/pids/*
rm -rf /tmp/postal

## Generate config
if [ ! -f /opt/postal/config/postal.yml ] || [[ $(cat /opt/postal/config/postal.yml | wc -l) < 2 ]]; then
  ## Build Jinja2 Template
  p2 -t /templates/postal.example.yml.j2 -o /opt/postal/config/postal.example.yml
  ## Add in secret key building
  echo "rails:" >> /opt/postal/config/postal.example.yml
  echo "  secret_key: {{secretkey}}" >> /opt/postal/config/postal.example.yml
  ## Generate config and keys
  /opt/postal/bin/postal initialize-config
  ## Wait for MySQL to start up
  echo "== Waiting for MySQL to start up =="
  while ! mysqladmin ping -h mysql --silent; do
    sleep 0.5
  done
  while ! mysql -hmysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "use $MYSQL_DATABASE" 2> /dev/null; do
    sleep 0.5
  done
  /opt/postal/bin/postal initialize
  /opt/postal/bin/postal make-user << EOF
    $POSTAL_EMAIL
    $POSTAL_FNAME
    $POSTAL_LNAME
    $POSTAL_PASSWORD
  EOF
else
  ## Wait for MySQL to start up
  echo "== Waiting for MySQL to start up =="
  while ! mysqladmin ping -h mysql --silent; do
    sleep 0.5
  done
  while ! mysql -hmysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "use $MYSQL_DATABASE" 2> /dev/null; do
    sleep 0.5
  done
fi
## Start Postal
/opt/postal/bin/postal "$@"
