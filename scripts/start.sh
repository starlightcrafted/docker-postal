#!/bin/bash

## Generate keys if they do not exist
if [[ ! -f /opt/postal/config/signing.key ]]; then
	/opt/postal/app/bin/postal initialize-config
fi

## Set Hostname
sed -i "s/postal\.example\.com/$POSTAL_HOSTNAME/" /opt/postal/config/postal.yml

## Use augeas to set the MySQL/RabbitMQ setup
### MySQL Main DB
sed -i -e '/main_db:/!b' -e ':a' -e "s/host.*/host: mysql/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml
sed -i -e'/main_db:/!b' -e ':a' -e "s/username.*/username: root/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml
sed -i -e'/main_db:/!b' -e ':a' -e "s/password.*/password: <%= ENV['MYSQL_ROOT_PASSWORD'] %>/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml
sed -i -e'/main_db:/!b' -e ':a' -e "s/database.*/database: <%= ENV['MYSQL_DATABASE'] %>/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml
### MySQL Message DB
sed -i -e '/message_db:/!b' -e ':a' -e "s/host.*/host: mysql/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml
sed -i -e'/message_db:/!b' -e ':a' -e "s/username.*/username: root/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml
sed -i -e'/message_db:/!b' -e ':a' -e "s/password.*/password: <%= ENV['MYSQL_ROOT_PASSWORD'] %>/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml
### RabbitMQ
sed -i -e '/rabbitmq:/!b' -e ':a' -e "s/host.*/host: rabbitmq/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml
sed -i -e '/rabbitmq:/!b' -e ':a' -e "s/username.*/username: <%= ENV['RABBITMQ_DEFAULT_USER'] %>/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml
sed -i -e '/rabbitmq:/!b' -e ':a' -e "s/password.*/password: <%= ENV['RABBITMQ_DEFAULT_PASS'] %>/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml
sed -i -e '/rabbitmq:/!b' -e ':a' -e "s/vhost.*/vhost: \/<%= ENV['RABBITMQ_DEFAULT_VHOST'] %>/;t trail" -e 'n;ba' -e ':trail' -e 'n;btrail' /opt/postal/config/postal.yml

## Run
/opt/postal/app/bin/postal run
