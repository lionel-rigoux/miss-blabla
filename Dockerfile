FROM alpine:3.5

ARG RAKE_ENV=development

ENV RUBY_VERSION="2.3.8-r0"
ENV APP_USER=webuser
ENV APP_GROUP=webgroup
ENV APP_PATH=/web
ENV RAKE_ENV=$RAKE_ENV
ENV TERM=dumb

# install core
RUN apk update \
 && apk add \
  bash \
  nodejs \
  postgresql-client \
  ruby=$RUBY_VERSION \
  ruby-bigdecimal

# install bundler and building tools
RUN gem install bundler -v "~>1.0" --no-ri --no-rdoc
RUN apk add --no-cache --virtual .build-deps \
  sudo \
  build-base \
  ruby-dev \
  postgresql-dev \
  zlib-dev

# Create non root user
RUN addgroup -S $APP_GROUP
RUN adduser -D $APP_USER $APP_GROUP
RUN echo "$APP_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# create app folder
RUN mkdir $APP_PATH

# Add a script to be executed every time the container starts.
WORKDIR /usr/bin/
ADD /web/entrypoint.sh .
RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# install gems
USER $APP_USER
WORKDIR $APP_PATH
COPY --chown=$APP_USER:$APP_GROUP web/Gemfile* ./
RUN bundle install

# install app
COPY --chown=$APP_USER:$APP_GROUP ./web ./

# clean up
RUN sudo apk del .build-deps

# Start the main process.
CMD bundle exec puma
