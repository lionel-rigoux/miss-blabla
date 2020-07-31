FROM alpine:3.5

ENV RUBY_VERSION="2.3.8-r0"
ENV APP_USER=webuser
ENV APP_GROUP=webgroup
ENV APP_PATH=/web

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
  postgresql-dev

# Create non root user
RUN addgroup -S $APP_GROUP
RUN adduser -D $APP_USER $APP_GROUP
RUN echo "$APP_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# create and copy app folder
RUN mkdir $APP_PATH
COPY --chown=$APP_USER:$APP_GROUP ./web $APP_PATH

# Add a script to be executed every time the container starts.
RUN mv /web/entrypoint.sh /usr/bin/ \
 && chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# bundle for end user
USER $APP_USER
WORKDIR $APP_PATH
RUN bundle install

# clean up
RUN sudo apk del .build-deps

# Start the main process.
CMD bundle exec puma
