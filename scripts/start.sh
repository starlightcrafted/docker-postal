#!/bin/bash

## Refresh config
cp -R /opt/postal/config-original/* /opt/postal/config

## Generate keys
/opt/postal/bin/postal initialize-config

if [[ $(cat /opt/postal/config/postal.yml| grep -i web_server |wc -l) == 0 ]]; then
	cat /docker/webserver_bind.yml >> /opt/postal/config/postal.yml
fi

## Set MySQL/RabbitMQ usernames/passwords
### MySQL Main DB
sed -i -e '/main_db:/!b' -e ':a' -e "s/host.*/host: mysql/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml
sed -i -e'/main_db:/!b' -e ':a' -e "s/username.*/username: root/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml
sed -i -e'/main_db:/!b' -e ':a' -e "s/password.*/password: $MYSQL_ROOT_PASSWORD/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml
sed -i -e'/main_db:/!b' -e ':a' -e "s/database.*/database: $MYSQL_DATABASE/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml
### MySQL Message DB
sed -i -e '/message_db:/!b' -e ':a' -e "s/host.*/host: mysql/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml
sed -i -e'/message_db:/!b' -e ':a' -e "s/username.*/username: root/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml
sed -i -e'/message_db:/!b' -e ':a' -e "s/password.*/password: $MYSQL_ROOT_PASSWORD/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml
### RabbitMQ
sed -i -e '/rabbitmq:/!b' -e ':a' -e "s/host.*/host: rabbitmq/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml
sed -i -e '/rabbitmq:/!b' -e ':a' -e "s/username.*/username: $RABBITMQ_DEFAULT_USER/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml
sed -i -e '/rabbitmq:/!b' -e ':a' -e "s/password.*/password: $RABBITMQ_DEFAULT_PASS/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml
sed -i -e '/rabbitmq:/!b' -e ':a' -e "s/vhost.*/vhost: \/$RABBITMQ_DEFAULT_VHOST/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml

## Clean Up
rm -rf /opt/postal/tmp/pids/*

## Initialize DB
echo "== Waiting for MySQL to start up =="
while ! mysqladmin ping -h mysql --silent; do
    sleep 1
done
if [[ $(mysql -h mysql -uroot -p$MYSQL_ROOT_PASSWORD -s --skip-column-names -e "SELECT COUNT(DISTINCT table_name) FROM information_schema.columns WHERE table_schema = 'postal'") == 0 ]]; then
	/opt/postal/bin/postal initialize
else
	/opt/postal/bin/postal upgrade
fi

## Run
/opt/postal/bin/postal run
