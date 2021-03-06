FROM heroku/cedar:14
MAINTAINER Terence Lee <terence@heroku.com>

RUN mkdir -p /app/user
WORKDIR /app/user

COPY ./heroku-docker-ruby-util /usr/local/bin/ruby-util
RUN chmod +x /usr/local/bin/ruby-util
RUN mkdir -p /app/heroku/ruby/

# Install Ruby
ONBUILD COPY ["Gemfile", "/app/user/"]
ONBUILD RUN ruby-util install-ruby /app/user/Gemfile /app/heroku/ruby /app/.profile.d/ruby.sh

# Install Bundler
ONBUILD RUN ruby-util install-bundler 1.9.10 /app/heroku/ruby/.bundle/config /app/.profile.d/ruby.sh

# Run bundler to cache dependencies
ONBUILD COPY ["Gemfile.lock", "/app/user/"]
ONBUILD RUN ruby-util bundle-install /app/heroku/ruby/bundle /app/.profile.d/ruby.sh

# Install Node
ONBUILD RUN ruby-util install-node 0.12.7 /app/heroku/ruby/ /app/.profile.d/ruby.sh

# Create database.yml
ONBUILD ADD . /app/user
ONBUILD RUN ruby-util database-yml /app/user/config/ /app/.profile.d/ruby.sh

# run assets:precompile if the task exists
ONBUILD RUN ruby-util rails-env /app/.profile.d/ruby.sh
ONBUILD RUN ruby-util assets-precompile /app/user/Rakefile /app/.profile.d/ruby.sh

RUN mkdir -p /app/.profile.d/
RUN echo "cd /app/user/" > /app/.profile.d/home.sh

COPY ./init.sh /usr/bin/init.sh
RUN chmod +x /usr/bin/init.sh

ENTRYPOINT ["/usr/bin/init.sh"]
