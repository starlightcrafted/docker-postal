FROM ruby:2.6

ENV DOCKERIZE_VERSION v0.6.1

RUN curl -L https://github.com/wrouesnel/p2cli/releases/download/r5/p2 -o /usr/local/bin/p2 \
        && chmod +x /usr/local/bin/p2

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
        && apt-get install -y nodejs

RUN apt-get -y update \
	&& apt-get -y install --no-install-recommends nodejs mariadb-client git-core libcap2-bin wget expect\
        && git clone https://github.com/atech/postal.git /opt/postal \
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

## Expose
EXPOSE 5000

## Startup
# ENV RUBYOPT --jit
ENTRYPOINT ["/bin/bash", "-c", "/docker-entrypoint.sh ${*}", "--"]
