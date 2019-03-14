# Github Actions environment doesn't support docker-compose yet. Until then
# Start w/ postgres, then copy the rest of the dockerfile for now
FROM postgres:9.4

# Apt install node and ruby, etc
RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y libpq-dev
RUN apt-get install -y nodejs
RUN apt-get install -y ruby2.3-dev
RUN apt-get install -y zlib1g-dev

# Set UTF-8 locale in container
ENV LC_ALL="C.UTF-8"

RUN pwd
RUN ls

# Latest v1 bundler
RUN gem install bundler -v "~> 1.17"

ENV DATABASE_URL="postgres://Postgres:@localhost/chasingtails_test"

