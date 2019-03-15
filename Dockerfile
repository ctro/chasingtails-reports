FROM ruby:2.3.8

# Set UTF-8 locale in container
ENV LC_ALL="C.UTF-8"

# General Dev
RUN apt-get update
RUN apt-get install -y build-essential

# Postgres drivers
RUN apt-get install -y libpq-dev

# For JS Runtime
RUN apt-get install -y nodejs

# Latest v1 bundler
RUN gem install bundler -v "~> 1.17"

# Bundle install first for a simple gem cache
COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install

# Set app working direcotry and copy app there.
ENV app /reports
RUN mkdir $app
WORKDIR $app
ADD . /$app