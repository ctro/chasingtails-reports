DB SCRIPT
=========

Capturing a backup will give you a backup_id, use it when generating a link.

Capture a backup
----------------
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

Log into Production
-------------------
```
ssh ubuntu@ctro-postgres
sudo -i -u postgres
psql tails_production
```

Import into Production
----------------------
```
# 1. Capture and Download a backup
scp latest.dump ubuntu@ctro-postgres:~
ssh ubuntu@ctro-postgres
sudo -i -u postgres
pg_restore --verbose --clean -d tails_production /home/ubuntu/latest.dump
```