#! /bin/bash

# Puma+Nginx
# https://github.com/puma/puma/tree/master/tools/jungle/upstart
# Assumes that github script has already been run.
cd ~/chasingtails-reports
mkdir -p shared/pids shared/sockets shared/log  #Puma needs these

# https://github.com/puma/puma/tree/master/tools/jungle/upstart
cd ~
wget https://raw.githubusercontent.com/puma/puma/master/tools/jungle/upstart/puma-manager.conf
wget https://raw.githubusercontent.com/puma/puma/master/tools/jungle/upstart/puma.conf
sed -i 's/setuid apps/setuid ubuntu/' puma.conf
sed -i 's/setgid apps/setgid ubuntu/' puma.conf
sudo mv puma.conf puma-manager.conf /etc/init
echo "/home/ubuntu/chasingtails-reports" | sudo tee -a /etc/puma.conf


sudo apt-get install -y nginx nodejs
