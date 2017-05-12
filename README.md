## Docker container for [atech/postal](https://github.com/atech/postal)

### Docker Hub Daily Builds
Builds are done every 6 hours by [Codeship](http://codeship.com/)

| tag           | Status                                                                                                                                   | Docker Hub                                                    |
| ------------- | ---------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| latest        | ![Daily Build](https://app.codeship.com/projects/aef32ad0-1807-0135-b213-7e299b644564/status?branch=master)                              | [\[DockerHub\]](https://hub.docker.com/r/alinuxninja/postal/) |

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

### Ports
Port mappings may change (as they have in the past). If SMTP/HTTP(s) is not working, verify that the mapped ports are correct.
