FROM ruby:2.4

## Install nodejs and mysql-client
RUN apt-get -y update \
&& apt-get -y install nodejs mysql-client\
&& rm -rf /var/lib/apt/lists/*

## Install required gems
RUN gem install bundler && gem install procodile

## Create user for postal
RUN useradd -r -d /opt/postal -s /bin/bash postal

## Clone postal
RUN git clone https://github.com/atech/postal /opt/postal \
&& chown -R postal:postal /opt/postal/

## Install gems required by postal
RUN /opt/postal/bin/postal bundle /opt/postal/vendor/bundle

## Move config folder
RUN mv /opt/postal/config /opt/postal/config-original

## Stick in required files
ADD wrapper.sh /wrapper.sh

## Expose
EXPOSE 5000

## Startup
ENTRYPOINT ["/bin/bash", "-c", "/wrapper.sh ${*}", "--"]
