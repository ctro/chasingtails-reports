#! /bin/bash

sudo apt-get -y update

# Other app-specific apt-get installs.
sudo apt-get -y install imagemagick  # for Refile gem
sudo apt-get -y install awscli  # For PG backups -> S3
