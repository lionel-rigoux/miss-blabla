FROM alpine:3.5

# install core
RUN apk update \
 && apk add \
  bash \
  sudo \
  nodejs \
  postgresql-client \
  ruby \
  ruby-bigdecimal

RUN apk add --no-cache --virtual .build-deps \
  build-base \
  ruby-dev \
  postgresql-dev

# prepare app folder
RUN mkdir /web
WORKDIR /web

RUN echo "myuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN adduser -D myuser

USER myuser

# install dependencies
RUN sudo gem install bundler -v "~>1.0" --no-ri --no-rdoc

COPY ./web/Gemfile /web/Gemfile
RUN sudo chown -R myuser /web
RUN touch /web/Gemfile.lock
RUN bundle install

RUN sudo apk del .build-deps

# copy app
COPY ./web /web

# Add a script to be executed every time the container starts.
RUN sudo cp /web/entrypoint.sh /usr/bin/ \
 && sudo chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Start the main process.
CMD bundle exec puma
