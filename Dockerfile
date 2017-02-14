FROM ruby:2.2.6

# General Dev
RUN apt-get update
RUN apt-get install -y build-essential

# Postgres drivers
RUN apt-get install -y libpq-dev

# For JS Runtime
RUN apt-get install -y nodejs

# Project things
RUN mkdir /reports
WORKDIR /reports
ADD Gemfile /reports/Gemfile
RUN bundle install
ADD . /reports
