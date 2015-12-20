#! /bin/bash

# Ruby 2.2.4
sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-dev
wget https://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.4.tar.gz
tar -xzf ruby-2.2.4.tar.gz

# Just build system-wide, from source.
cd ruby-2.2.4
./configure
make
sudo make install

sudo gem update --system

cd ~
rm ruby-2.2.4.tar.gz
rm -rf ruby-2.2.4
echo "Your ruby is now: `ruby -v`"
