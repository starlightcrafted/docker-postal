## Docker container for [atech/postal](https://github.com/atech/postal)

### Instructions
Change configuration in docker-compose.yml to update passwords for MySQL/RabbitMQ.
Both passwords in the `postal` service, `mysql` service and `rabbitmq` service have to be changed.

Then, start postal by running
```
docker-compose up -d
```

Default password is avaliable at https://github.com/atech/postal/wiki/Installation#accessing-the-web-interface

### Configuration
Configuration is located at data/postal after the first start. Note that non-config files (i.e. files in https://github.com/atech/postal/tree/master/config) will be overwritten each time the container starts up. See https://github.com/atech/postal/blob/master/config/postal.defaults.yml for all possible configuration options

Be sure to do some port mappings to allow your SMTP server and HTTP(s) server to be accessed. I suggest simply port mapping the SMTP server and using [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) to proxy the HTTP server.

Still WIP
