ChasingTails Reports
====================

A simple web app for dog walkers using Rails and Postgres.

Development
-----------

I run this on a mac using `homebrew` and these tools:
- https://github.com/postmodern/chruby
- https://github.com/postmodern/ruby-install
- https://github.com/postmodern/gem_home

Here are some loose guidelines:

### Install rubies & other stuff.  Brew shows important instructions after some installs, so pay attention!
```
brew install postgres
brew install chruby
brew install ruby-install
brew install --HEAD https://raw.github.com/postmodern/gem_home/master/homebrew/gem_home.rb
gem update --system
ruby-install ruby:2.2.4
gem install bundler
```

### Set up Postgres
```
$ createdb chasingtails_dev
$ psql chasingtails_dev
\l
\d
\d users
select * from users;
```

### Boot Development
```
cd dev/chasingtails-reports
gem_home .
bundle
bundle exec rails s
open localhost:3000
```

### Debugging
Add `binding.pry` where you want to stop.

Tests
-----
Run tests once: `bundle exec rake test`

Continuous tests: `bundle exec guard`

Code Coverage:
```
bundle exec rake test:coverage
open coverage/index.html
```

There is a test that uploads a 1x1png to S3.  You'll need to set up `tails-test` S3 Bucket same as `tails-dev`


ENVironment
-----------
See `/.env.example` for specifying ENV variables.
We use [Dotenv](https://github.com/bkeepers/dotenv) to manage this.
Real `.env` files are NOT checked in!


Packer / AWS AMI
----------------
Build AWS AMI with Packer:
`source .env && packer build image/server.json`

Now you can launch an EC2 node from the AWS UI
Pretty much everything should be installed and configured.
See `image/` for source code.


Production Emails
-----------------
Emails are delivered via Amazon SES.  SES requires you to verify domain ownership by adding DNS/TXT record.  SES requires manual setup via the SES dashboard.


Boot Production
---------------
After launching the AMI you need to:

### Create the database
```
sudo -i -u postgres
createdb "tails_production"
```

You can log into psql and do useful things:
```
$ sudo -i -u postgres
$ psql
\l  
\d
\dt
\c <db>
\q
```
See `db/backups/DUMP.markdown` for DB Export/Import instructions.

Postgres backups happen via a build-in cron job.  They upload to S3.
You need to create the bucket `tails-backups` and give it a policy restricted to the EC2 node's EIP
```
{
	"Version": "2012-10-17",
	"Id": "S3pgsqlBackup",
	"Statement": [
		{
			"Sid": "IPAllow",
			"Effect": "Allow",
			"Principal": "*",
			"Action": "s3:*",
			"Resource": "arn:aws:s3:::tails-backups/*",
			"Condition": {
				"IpAddress": {
					"aws:SourceIp": "52.35.135.245/32"
				}
			}
		}
	]
}
```

You also want to set up a Lifecycle policy on the `tails-backups` bucket in the AWS UI.
Currently Delete after 11 days.

#### Restore a Database backup

1. Log into S3 and download the latest backup
2. `scp <filename> ubuntu@tails-production:~`
3. `ssh ubuntu@tails-production`
4. `sudo chown postgres <filename>`
5. `sudo -i -u postgres`
6. `cd /home/ubuntu`
7. `psql <database_name> < <filename>`


### Set bucket policy for Cache
The Refile gem uploads direct to s3://tails-production/cache.  Set a lifecycle policy to delete cache entries after some days.

### Install deps
```
cd chasingtails-reports
sudo gem install bundler
bundle install
```

### Add your env
Don't forget to add your environment via a new `.env` file.

### Compile assets
`RAILS_ENV=production rake assets:precompile`

### Migrate
```
sudo -i -u postgres
cd /home/ubuntu/chasingtails-reports
RAILS_ENV=production rake db:migrate
```

### Set up monitoring

Metrics are added via an AWS script + cron that reports to CloudWatch.
https://console.aws.amazon.com/cloudwatch/

Our metric values have prefix "System/Linux".
Manually add "MemoryUtilization" and "DiskSpaceUtilization" to CloudWatch dashboards and Alarms.

### (re)Start the server
```
sudo restart puma-manager
```

Deploys
-------
Are manual...
```
cd chasingtails-reports
git pull
bundle
sudo -i -u postgres
cd /home/ubuntu/chasingtails-reports
RAILS_ENV=production bundle exec rake db:migrate
exit
RAILS_ENV=production rake assets:precompile
sudo restart puma-manager
```

Releases
--------
Update `config/initializers/version.rb`
```
git tag v0.0.0
git push --tags
```
Log into github and "Draft a new release"


Monitoring
----------
App monitoring via Skylight:
https://www.skylight.io/app/applications/0QxbrpWtqtAy/recent/5m/endpoints

Instance monitoring via CloudWatch:
https://us-west-2.console.aws.amazon.com/cloudwatch/home?region=us-west-2#dashboards:name=Tails

Logs via Papertrail:
https://papertrailapp.com/groups/2167163/events

Papertrail also provides alerts on "500" or "Error -(RoutingError)" etc.
