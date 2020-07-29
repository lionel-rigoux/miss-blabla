FROM mayok/alpine-ruby

# communication with the database
RUN apk update -qq
RUN apk add nodejs postgresql-client
RUN apk add postgresql-dev

# install ruby 2.0.0
#RUN apk add software-properties-common
#RUN apt-add-repository ppa:brightbox/ruby-ng
#RUN apt-get update -qq
#RUN apt-get install -y ruby2.0
#RUN apt-get install -y ruby2.0-dev

# prepare app folder
RUN mkdir /myapp
WORKDIR /myapp

# install dependencies
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN gem install bundler -v "~>1.0"
RUN bundle install

# copy app
COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
