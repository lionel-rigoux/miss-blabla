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
RUN mkdir /myapp
WORKDIR /myapp

# install dependencies
RUN gem install bundler -v "~>1.0" --no-ri --no-rdoc
RUN apk add --no-cache --virtual .build-deps \
  build-base \
  ruby-dev \
  postgresql-dev

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

RUN apk del .build-deps

# copy app
COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
