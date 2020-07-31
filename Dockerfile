FROM alpine:3.5

ENV RUBY_VERSION="2.3.8-r0"
ENV APP_USER=webuser
ENV APP_GROUP=webgroup
ENV APP_PATH=/web

# install core
RUN apk update \
 && apk add \
  bash \
  sudo \
  nodejs \
  postgresql-client \
  ruby=$RUBY_VERSION \
  ruby-bigdecimal

RUN apk add --no-cache --virtual .build-deps \
  build-base \
  ruby-dev \
  postgresql-dev

# prepare app folder
RUN mkdir $APP_PATH
WORKDIR $APP_PATH

RUN addgroup -S $APP_GROUP
RUN adduser -D $APP_USER
RUN echo "$APP_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $APP_USER

# install dependencies
RUN sudo gem install bundler -v "~>1.0" --no-ri --no-rdoc

COPY ./web/Gemfile $APP_PATH/Gemfile
RUN sudo chown -R $APP_USER $APP_PATH
RUN touch $APP_PATH/Gemfile.lock
RUN bundle install

RUN sudo apk del .build-deps

# copy app
COPY ./web $APP_PATH

# Add a script to be executed every time the container starts.
RUN sudo cp /web/entrypoint.sh /usr/bin/ \
 && sudo chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Start the main process.
CMD bundle exec puma
