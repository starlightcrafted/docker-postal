FROM ruby:2.7-alpine
#FROM ruby:3.0-rc-alpine # && sed -i 's@minitest (5.14.1)@minitest (5.14.2)@g' /opt/postal/Gemfile.lock

ENV DOCKERIZE_VERSION v0.6.1

RUN wget https://github.com/wrouesnel/p2cli/releases/download/r5/p2 -O /usr/local/bin/p2 \
        && chmod +x /usr/local/bin/p2

RUN apk --no-cache add nodejs mariadb-client git bash libcap build-base mariadb-dev tzdata mariadb-connector-c openssl expect libjemalloc2 \
        && git clone --depth=1 https://github.com/atech/postal.git /opt/postal \
        && sed -i 's/1.17.2/2.1.4/g' /opt/postal/Gemfile.lock \
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

# NGINX (X-Accel-Redirect)
RUN sed -i '/config.action_dispatch.x_sendfile_header/s/^# //g' /opt/postal/config/environments/production.rb

# Protection against identification by automatic bots on vulnerability
ENV REBRAND_MAILER=MySendClient
RUN if [ ! -z "${REBRAND_MAILER}" ]; then \
           sed -i -E "s@(by )Postal@\1${REBRAND_MAILER}@g" /opt/postal/app/models/*message*.rb; \
           sed -i -E "s@(X(\\\)?-)Postal@\1${REBRAND_MAILER}@g" /opt/postal/lib/postal/message_db/message.rb; \
           sed -i -E "s@(ESMTP )Postal@\1${REBRAND_MAILER}@g" /opt/postal/lib/postal/smtp_server/server.rb; \
           sed -i -E "s@(ESMTP )Postal@\1${REBRAND_MAILER}@g" /opt/postal/lib/postal/smtp_server/client.rb; \
           sed -i "s@Welcome to Postal@Welcome to ${REBRAND_MAILER}@g" /opt/postal/app/mailers/app_mailer.rb; \
           sed -i "s@Welcome to Postal@Welcome to ${REBRAND_MAILER}@g" /opt/postal/lib/postal/smtp_server/server.rb; \
           sed -i "s@Welcome to Postal@Welcome to ${REBRAND_MAILER}@g" /opt/postal/app/views/organizations/index.html.haml; \
           sed -i "s@Welcome to Postal@Welcome to ${REBRAND_MAILER}@g" /opt/postal/app/views/user/join.html.haml; \
           sed -i "s@Welcome to Postal@Welcome to ${REBRAND_MAILER}@g" /opt/postal/app/views/sessions/new.html.haml; \
           sed -i "s@\[\"Postal\"\]@\[\"${REBRAND_MAILER}\"\]@g" /opt/postal/app/controllers/application_controller.rb; \
           # bash -c "sed -i \"s@_postal_session@_${REBRAND_MAILER}_session@g\" /opt/postal/config/initializers/session_store.rb"; \
           sed -i "s@_postal_session@_$(echo -n ${REBRAND_MAILER}|tr '[:upper:]' '[:lower:]')_session@g" /opt/postal/config/initializers/session_store.rb; \
         fi

## Expose
EXPOSE 5000

## Startup
ENV RUBYOPT --jit
# ENV MALLOC_ARENA_MAX 2
ENV LD_PRELOAD /usr/lib/x86_64-linux-gnu/libjemalloc.so.2
ENTRYPOINT ["/bin/bash", "-c", "/docker-entrypoint.sh ${*}", "--"]
