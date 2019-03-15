Historical Heroku -> AWS PG export/import
=========================================

Install the Heroku Toolbelt.
Capturing a backup will give you a backup_id, use it when generating a link.

Capture a backup from Heroku
----------------------------
`heroku pg:backups capture --app chasingtailsreports`

Download a backup
-----------------
```
heroku pg:backups public-url bnnn --app chasingtailsreports
curl -o latest.dump `heroku pg:backups public-url --app chasingtailsreports`
```

Import in Development
---------------------
`pg_restore --verbose --clean --no-owner -h localhost -d chasingtails_dev latest.dump`

Import into Production
----------------------
```
scp latest.dump ubuntu@tails-production:~
ssh ubuntu@tails-production
sudo -i -u postgres
pg_restore --verbose --clean -d tails_production /home/ubuntu/latest.dump
```

Log into Production
-------------------
```
ssh ubuntu@tails-production
sudo -i -u postgres
psql tails_production
```
