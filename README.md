ChasingTails Reports
====================

A simple web app for dog walkers using Rails and Postgres.

Development
-----------

I run this on a mac using `homebrew` and these tools:
- https://github.com/postmodern/chruby
- https://github.com/postmodern/ruby-install
- https://github.com/postmodern/gem_home

Here are some loos guidelines:

1. Install rubies & other stuff.  Brew shows important instructions after install, so pay attention!
```
brew install postgres
brew install chruby
brew install ruby-install
brew install --HEAD https://raw.github.com/postmodern/gem_home/master/homebrew/gem_home.rb
gem update --system
ruby-install ruby:2.2.4
gem install bundler
```

2. Boot up the rails app
```
cd dev/chasingtails-reports
gem_home .
bundle
bundle exec rails s
open localhost:3000
```

3. Get a psql prompt
```
psql chasingtails_dev
\dt
\d users
select * from users;
```

Environment
-----------
See `/.env.example` for specifying ENV variables.
We use [Dotenv](https://github.com/bkeepers/dotenv) to manage this.
Real `.env` files are NOT checked in!


Packer
------
Build AWS AMI with Packer:
`source .env && packer build image/server.json`

Now you can launch an EC2 node from the AWS UI
Pretty much everything should be installed and configured.

Boot Production
---------------
After launching the AMI you need to:

*Create the database*
```
sudo -i -u postgres
createdb "tails_production"

# You can log into psql like this:
# sudo -i -u postgres
# psql
# \l  \dt \c  \d  \q  <-- some useful commands
```
See `db/backups/DUMP.markdown` for DB Export/Import instructions.

*Install deps*
```
cd chasingtails-reports
sudo gem install bundler
bundle install
```

*Add your env*
Don't forget to add your environment via .env

*Compile assets, migrate*
RAILS_ENV=production rake assets:precompile
RAILS_ENV=production rake db:migrate


*Set up monitoring*

Metrics are added via an AWS script + cron that reports to CloudWatch.
https://console.aws.amazon.com/cloudwatch/

Our metric values have prefix "System/Linux".
Manually add "MemoryUtilization" and "DiskSpaceUtilization" to CloudWatch dashboards and Alarms.

*Start the server*
```
sudo restart puma-manager
```
