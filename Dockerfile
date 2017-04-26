FROM ruby:2.4

## Install augeas
RUN apt-get -y update \
&& apt-get -y install augeas-lenses augeas-tools nodejs

## Install required gems
RUN gem install bundler && gem install procodile

## Create user for postal
RUN useradd -r -m -d /opt/postal -s /bin/bash postal

## Clone postal
RUN git clone https://github.com/atech/postal /opt/postal/app \
&& chown -R postal:postal /opt/postal/

## Install gems required by postal
RUN /opt/postal/app/bin/postal bundle /opt/postal/app/vendor/bundle

## Stick in startup script
ADD scripts/start.sh /start.sh

## Clean up apt
RUN rm -rf /var/lib/apt/lists/*

## Entrypoint
ENTRYPOINT ["/start.sh"]
