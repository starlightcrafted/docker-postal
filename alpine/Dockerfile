FROM ruby:2.6-alpine

ENV DOCKERIZE_VERSION v0.6.1

RUN wget https://github.com/wrouesnel/p2cli/releases/download/r5/p2 -O /usr/local/bin/p2 \
        && chmod +x /usr/local/bin/p2

RUN apk --no-cache add nodejs mariadb-client git bash libcap build-base mariadb-dev tzdata mariadb-connector-c openssl expect\
        && git clone https://github.com/atech/postal.git /opt/postal \
	&& rm -rf /var/lib/apt/lists/* \
	&& gem install bundler \
	&& gem install procodile \
	&& gem install tzinfo-data \
	&& addgroup -S postal \
	&& adduser -S -G postal -h /opt/postal -s /bin/bash postal \
	&& chown -R postal:postal /opt/postal/ \
	&& /opt/postal/bin/postal bundle /opt/postal/vendor/bundle \
	&& apk del git mariadb-dev \
	&& rm -rf /var/cache/apk/*

## Install jwilder/dockerize
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

## Adjust permissions
RUN setcap 'cap_net_bind_service=+ep' /usr/local/bin/ruby

## Stick in required files
ADD src/docker-entrypoint.sh /docker-entrypoint.sh
ADD src/create-user.sh /create-user.sh
ADD src/templates /templates

## Expose
EXPOSE 5000

## Startup
# ENV RUBYOPT --jit
ENTRYPOINT ["/bin/bash", "-c", "/docker-entrypoint.sh ${*}", "--"]
