#! /bin/bash
sudo apt-get -y install postgresql postgresql-contrib libpq-dev

sudo sed -i 's/local   all             all                                     md5/local   all             all                                     trust/' /etc/postgresql/9.3/main/pg_hba.conf
sudo sed -i 's/host    all             all             127.0.0.1\/32            md5/host    all             all             127.0.0.1\/32            trust/' /etc/postgresql/9.3/main/pg_hba.conf

sudo chown postgres /etc/postgresql/9.3/main/pg_hba.conf

# Create a directory for backups. backups happen via Cron
mkdir /home/ubuntu/backups
