# Workflow

# TODO: add database supported tests when Actions has docker-compose support.

# On Push
workflow "Scans" {
  on = "push"
  resolves = ["Rubocop Scan"]
}

action "Brakeman Scan" {
  uses = "./.github/brakeman/"
  args = "brakeman"
}

action "Rubocop Scan" {
  needs = "Brakeman Scan"
  uses = "./.github/rubocop/"
  args = "rubocop --rails"
}