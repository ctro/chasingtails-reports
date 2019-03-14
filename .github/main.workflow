# Workflow

# On Push
workflow "Build and Test" {
  on = "push"
  resolves = ["Lint"]
}

## Build the Dockerfile in the project root
action "Docker Build" {
  uses = "./"
}

## Run Tests
action "Run Tests" {
  needs = ["Docker Build"]
  uses = "./"
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
  uses = "./"
  args = "bundle exec brakeman"
}

## Linter
action "Lint" {
  needs = ["Security Scan"]
  uses = "./"
  args = "bundle exec rubocop"
}