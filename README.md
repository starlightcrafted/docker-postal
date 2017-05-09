## Docker container for [atech/postal](https://github.com/atech/postal)

### Docker Hub Build Status

| tag           | Status                                                                                                                                           |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| latest        | ![Daily Build](https://api.travis-ci.org/ALinuxNinja/docker-postal.svg?branch=latest)                                                            |

### Instructions
Change configuration in docker-compose.yml to update passwords for MySQL/RabbitMQ.
Both passwords in the `postal` service, `mysql` service and `rabbitmq` service have to be changed.

Then, begin by following the directions at https://github.com/atech/postal/wiki/Installation#initialize-database--assets.
Postal can be accessed by checking the section below. Note that "intialize-config" is already run for you, as the database parameters need to be configured before the postal tool can be used.

After configuration is done, run the following to bring the container up.
```
docker-compose up -d
```
### Using the `postal` tool.
To use the `postal` tool, simply run
```
docker-compose run postal <parameter>
```
For example, the following command runs `postal initialize` inside the container.
```
docker-compose run postal initialize
```

### Migrations
See https://github.com/atech/postal/wiki/Upgrading.

Be sure to do some port mappings to allow your SMTP server and HTTP(s) server to be accessed. I suggest simply port mapping the SMTP server and using [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) to proxy the HTTP server.

Still WIP
