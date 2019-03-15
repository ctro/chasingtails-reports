#! /bin/bash

sudo apt-get -y install unzip
sudo apt-get -y --force-yes install libwww-perl libdatetime-perl

cd ~
wget http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip
unzip CloudWatchMonitoringScripts-1.2.1.zip
rm CloudWatchMonitoringScripts-1.2.1.zip
cd aws-scripts-mon
