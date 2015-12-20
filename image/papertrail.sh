#! /bin/bash

# Push all system messages
echo "*.*          @logs3.papertrailapp.com:51424" | sudo tee -a /etc/rsyslog.conf
sudo service rsyslog restart

# Push app specific logs
wget "https://github.com/papertrail/remote_syslog2/releases/download/v0.15/remote_syslog_linux_amd64.tar.gz"
tar xzf remote_syslog_linux_amd64.tar.gz
cd remote_syslog
sudo cp ./remote_syslog /usr/local/bin

# init.d
cd ~
wget https://raw.githubusercontent.com/papertrail/remote_syslog2/master/examples/remote_syslog.init.d
sudo mv remote_syslog.init.d /etc/init.d/remote_syslog
chmod +x /etc/init.d/remote_syslog
sudo update-rc.d remote_syslog defaults

# Clean up
cd ~
rm remote_syslog_linux_amd64.tar.gz
rm -rf remote_syslog
