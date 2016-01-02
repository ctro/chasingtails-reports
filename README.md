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

1. Install rubies & other stuff.  Brew shows important instructions after some installs, so pay attention!
```
brew install postgres
brew install chruby
brew install ruby-install
brew install --HEAD https://raw.github.com/postmodern/gem_home/master/homebrew/gem_home.rb
gem update --system
ruby-install ruby:2.2.4
gem install bundler
```

2. Set up Postgres
```
$ createdb chasingtails_dev
$ psql chasingtails_dev
\l
\d
\d users
select * from users;
```

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

3. Boot Development
```
cd dev/chasingtails-reports
gem_home .
bundle
bundle exec rails s
open localhost:3000
```


ENV
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
See `image/` for source code.


Production Config
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

### Deploys
Are manual...
```
cd chasingtails-reports
git pull
bundle
sudo -i -u postgres
cd /home/ubuntu/chasingtails-reports
bundle exec rake db:migrate
exit
sudo restart puma-manager
```
