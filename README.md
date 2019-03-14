# ChasingTails Reports

A simple web app for dog walkers using Rails and Postgres.

## Development

### Docker

[Install Docker Engine for your platform](https://docs.docker.com/engine/installation/).
[Install Docker Compose](https://github.com/docker/compose/releases)

#### Quickstart

```
docker-compose build
docker-compose run web rake db:create
docker-comopose run web rake db:migrate
xgd-open http://localhost:3000
```

#### Tests

- Run tests once: `docker-compose run web rake test`
- Or continuously: `docker-compose run web guard`
- With coverage: `docker-compose run web rake test:coverage` (open `coverage/index.html`)
- Pessimize Gemfile: `docker-compose run web pessimize`
- Security Scan: `docker-compose run web brakeman`
- Lint: `docker-compose run rubocop`

There is a test that uploads a 1x1png to S3. You'll need to set up `tails-test` S3 Bucket same as `tails-dev`

#### More Docker commands

Rebuild container: `docker-compose build web`
Boot the app: `docker-compose up`
List containers: `docker-compose ps`
Run a one-off: `docker-compose run web rails db:migrate`
Get a shell: `docker-compose exec web /bin/bash`
Get a Rails console: `docker-compose run web rails console`

#### Poke around in Postgres

```
docker-compose exec db /bin/bash
su postgres
psql
\l
\d
\d users
select * from users;
```

#### Debugging

Add `binding.pry` where you want to stop.

## Production

### ENVironment

See `/.env.example` for specifying ENV variables.
We use [Dotenv](https://github.com/bkeepers/dotenv) to manage this.
Real `.env` files are NOT checked in!

Use an IAM user with limited ability for AWS credentials. User needs:

- `AmazonS3FullAccess` for S3 uploads
- `CloudWatchFullAccess` for CloudWatch logging
- `AmazonSESFullAccess` to send emails

### Packer / AWS AMI

Build AWS AMI with Packer:
`source .env && packer build image/server.json`

Now you can launch an EC2 node from the AWS UI
Pretty much everything should be installed and configured.
See `image/` for source code.

### Production Emails

Emails are delivered via Amazon SES. SES requires you to verify domain ownership by adding DNS/TXT record. SES requires manual setup via the SES dashboard.

### Boot Production

After launching the AMI you need to:

#### Create the database

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

Postgres backups happen via a build-in cron job. They upload to S3.
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

#### Set bucket policy for Cache

The Refile gem uploads direct to s3://tails-production/cache. Set a lifecycle policy to delete cache entries after some days.

#### Install deps

```
cd chasingtails-reports
sudo gem install bundler
bundle install
```

#### Add your env

Don't forget to add your environment via a new `.env` file.

Use an IAM user for the AWS credentialis. The user needs these permissions:

- `AmazonS3FullAccess`

#### Compile assets

`RAILS_ENV=production rake assets:precompile`

#### Migrate

```
sudo -i -u postgres
cd /home/ubuntu/chasingtails-reports
RAILS_ENV=production rake db:migrate
```

#### Set up monitoring

Metrics are added via an AWS script + cron that reports to CloudWatch.
https://console.aws.amazon.com/cloudwatch/

Our metric values have prefix "System/Linux".
Manually add "MemoryUtilization" and "DiskSpaceUtilization" to CloudWatch dashboards and Alarms.

#### SSH into server

`ssh -i .ssh\CTRO-AWS.pem ubuntu@52.35.135.245`

#### (re)Start the server

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
RAILS_ENV=production bundle exec rake db:migrate
exit
RAILS_ENV=production rake assets:precompile
sudo restart puma-manager
```

### Releases

Update `config/initializers/version.rb`

```
git tag v0.0.0
git push --tags
```

Log into github and "Draft a new release"

### Monitoring

App monitoring via Skylight:
https://www.skylight.io/app/applications/0QxbrpWtqtAy/recent/5m/endpoints

Instance monitoring via CloudWatch:
https://us-west-2.console.aws.amazon.com/cloudwatch/home?region=us-west-2#dashboards:name=Tails

Logs via Papertrail:
https://papertrailapp.com/groups/2167163/events

Papertrail also provides alerts on "500" or "Error -(RoutingError)" etc.

### Bugs

Cloudwatch and SES stopped working b/c system clock was too far off.

```
timedatectl  # to check date/time
sudo ntpdate-debian  # to re-set time
```

For now just keep the 'debian' version of ntpdate in cron so it keeps running.
`0 0 * * * sudo ntpdate-debian`
