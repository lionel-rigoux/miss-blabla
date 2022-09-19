FROM alpine:3.9

ARG R_ENV

ENV RUBY_VERSION="2.5.8-r0"
ENV APP_USER=webuser
ENV APP_GROUP=webgroup
ENV APP_PATH=/web
ENV RAKE_ENV=$R_ENV
ENV RAILS_ENV=$R_ENV
ENV TERM=dumb

# install core
RUN apk update \
 && apk add \
  bash \
  curl \
  nodejs \
  postgresql-client \
  ruby=$RUBY_VERSION \
  ruby-bigdecimal \
  ruby-etc

# install bundler and building tools
RUN gem install bundler -v "~>1.0" --no-ri --no-rdoc
RUN apk add --no-cache --virtual .build-deps \
  sudo \
  build-base \
  ruby-dev \
  postgresql-dev \
  zlib-dev

# install pdf maker
RUN apk add ttf-ubuntu-font-family wkhtmltopdf


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
COPY web/Gemfile* ./
RUN sudo chown -R ${APP_USER}:${APP_GROUP} ./
RUN bundle install

# install app
COPY ./web ./
RUN sudo chown -R ${APP_USER}:${APP_GROUP} ./

# compile assets if necessary
RUN bundle exec rake assets:precompile
RUN bundle exec rake assets:clean

# allow to execute migration tasks
RUN sudo chmod u+x ./release-tasks.sh

# clean up
RUN sudo apk del .build-deps

CMD ["bundle", "exec", "puma"]
