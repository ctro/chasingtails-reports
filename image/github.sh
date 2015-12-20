#! /bin/bash

# Git / Github
sudo apt-get -y install git
ssh-keygen -t rsa -b 4096 -C "clint@ctro.net" -f ~/.ssh/id_rsa -N ''
echo "Here comes the public key... add it to github/deploy_keys now."
echo "I'll wait, press something when you're done..."
cat ~/.ssh/id_rsa.pub
read -n 1 -s

echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
git clone git@github.com:ctro/chasingtails-reports.git
