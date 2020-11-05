FROM ruby:2.7
#FROM ruby:3.0-rc # && sed -i 's@minitest (5.14.1)@minitest (5.14.2)@g' /opt/postal/Gemfile.lock

ENV DOCKERIZE_VERSION v0.6.1

RUN curl -L https://github.com/wrouesnel/p2cli/releases/download/r5/p2 -o /usr/local/bin/p2 \
        && chmod +x /usr/local/bin/p2

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
        && apt-get install -y nodejs

RUN apt-get -y update \
	&& apt-get -y install --no-install-recommends nodejs mariadb-client git-core libcap2-bin wget expect libjemalloc2 \
        && git clone --depth=1 https://github.com/atech/postal.git /opt/postal \
        && sed -i 's/1.17.2/2.1.4/g' /opt/postal/Gemfile.lock \
	&& rm -rf /var/lib/apt/lists/* \
	&& gem install bundler \
	&& gem install procodile \
	&& gem install tzinfo-data \
	&& useradd -r -d /opt/postal -s /bin/bash postal \
	&& chown -R postal:postal /opt/postal/ \
	&& /opt/postal/bin/postal bundle /opt/postal/vendor/bundle \
	&& apt-get -y purge python-dev git-core \
	&& apt-get -y autoremove \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Install jwilder/dockerize
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

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
