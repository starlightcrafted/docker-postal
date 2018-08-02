FROM ruby:2.4-alpine

RUN apk --no-cache add nodejs mysql-client git bash python libcap py-setuptools py-pip build-base python-dev mariadb-dev \
	&& pip install j2cli \
        && git clone https://github.com/atech/postal.git /opt/postal \
	&& rm -rf /var/lib/apt/lists/* \
	&& gem install tzinfo-data \
	&& gem install bundler \
	&& gem install procodile \
	&& addgroup -S postal \
	&& adduser -S -G postal -h /opt/postal -s /bin/bash postal \
	&& chown -R postal:postal /opt/postal/ \
	&& /opt/postal/bin/postal bundle /opt/postal/vendor/bundle \
	&& rm -rf /var/cache/apk/*

## Adjust permissions
RUN setcap 'cap_net_bind_service=+ep' /usr/local/bin/ruby

## Stick in required files
ADD src/docker-entrypoint.sh /docker-entrypoint.sh
ADD src/templates /templates

## Expose
EXPOSE 5000

## Startup
ENTRYPOINT ["/bin/bash", "-c", "/docker-entrypoint.sh ${*}", "--"]
