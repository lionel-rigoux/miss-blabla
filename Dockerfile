FROM alpine:3.5

# install core
RUN apk update
RUN apk add \
  bash \
  nodejs \
  postgresql-client \
  ruby \
  ruby-bigdecimal

# prepare app folder
RUN mkdir /web
WORKDIR /web

# install dependencies
RUN gem install bundler -v "~>1.0" --no-ri --no-rdoc
RUN apk add --no-cache --virtual .build-deps \
  build-base \
  ruby-dev \
  postgresql-dev

COPY ./web/Gemfile /web/Gemfile
RUN touch /web/Gemfile.lock
RUN bundle install

RUN apk del .build-deps

# copy app
COPY ./web /web

# Add a script to be executed every time the container starts.
COPY ./web/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Start the main process.
CMD bundle exec puma
