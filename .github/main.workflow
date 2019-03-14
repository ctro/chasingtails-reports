# Workflow

# On Push
workflow "Build and Test" {
  on = "push"
  resolves = ["Lint"]
}

## Build the Dockerfile in the .github folder
action "Docker Build" {
  uses = "./.github/"
}

## Install gems
action "Bundle" {
  needs = "Docker Build"
  uses = "./.github/"
  args = "bundle install"
}

## Migrate the Database
action "Migrate Database" {
  needs = "Docker Build"
  uses = "./.github/"


  args = "bundle exec rake db:create"


  env = {
    RAILS_ENV = "test"
  }
}

## Run Tests
action "Run Tests" {
  needs = ["Migrate Database"]

  # Use a custom Dockerfile for Github Actions
  uses = "./.github/" 
  args = "bundle exec rake test"
  env = {
    S3_BUCKET = "tails-dev"
    AWS_DEFAULT_REGION = "us-west-2"
  }
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
}

## Security Scan
action "Security Scan" {
  needs = ["Run Tests"]
  uses = "./.github/"
  args = "bundle exec brakeman"
}

## Linter
action "Lint" {
  needs = ["Security Scan"]
  uses = "./.github/"
  args = "bundle exec rubocop"
}