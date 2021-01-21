#!/usr/bin/env bash

sudo apt-get update

sudo apt-get install -y \
  g++ linux-headers-amd64 libpq-dev build-essential postgresql postgresql-client git chrpath \
  libssl-dev libxft-dev libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev postgresql-contrib libreadline-dev imagemagick curl libyaml-0-2 libxml2-dev libxslt1-dev \
  linux-headers-`uname -r` dkms

# VirtualBox Guest Additions
wget http://download.virtualbox.org/virtualbox/6.1.14/VBoxGuestAdditions_6.1.14.iso
sudo mkdir /mnt/VBoxGuestAdditions
sudo mount -o loop,ro VBoxGuestAdditions_6.1.14.iso /mnt/VBoxGuestAdditions
sudo sh /mnt/VBoxGuestAdditions/VBoxLinuxAdditions.run
rm VBoxGuestAdditions_6.1.14.iso
sudo umount /mnt/VBoxGuestAdditions
sudo rmdir /mnt/VBoxGuestAdditions
cd /opt/VBoxGuestAdditions-6.1.14/init/
sudo ./vboxadd setup
cd ~

## redis
#wget http://download.redis.io/releases/redis-6.0.7.tar.gz
#tar xvzf redis-6.0.7.tar.gz
#cd redis-6.0.7
#make
#sudo make install
#sudo mkdir /etc/redis
#sudo mkdir -p /var/redis/6379
#sudo cp /vagrant/.vagrant_cfg/redis_init_script_6379 /etc/init.d/redis_6379
#sudo cp /vagrant/.vagrant_cfg/redis.conf /etc/redis/6379.conf
#sudo update-rc.d redis_6379 defaults
#sudo /etc/init.d/redis_6379 start
#cd ~

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | /bin/bash
source ~/.nvm/nvm.sh
source ~/.bashrc
nvm install v12
nvm alias default v12

# rbenv
RBENV_ROOT=~/.rbenv
git clone https://github.com/rbenv/rbenv.git ${RBENV_ROOT}

cat << EOF > ~/.bashrc
# rbenv setup
export RBENV_ROOT='$RBENV_ROOT'
export PATH="$RBENV_ROOT/bin:$PATH"
EOF
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
cd ~

# rbenv plugins
RBENV_PLUGINS_ROOT=${RBENV_ROOT}/plugins
mkdir -p ${RBENV_PLUGINS_ROOT}

# rbenv plugin: ruby-build
git clone https://github.com/sstephenson/ruby-build.git ${RBENV_PLUGINS_ROOT}/ruby-build

# rbenv plugin: rvm-download
# git clone https://github.com/garnieretienne/rvm-download.git ${RBENV_PLUGINS_ROOT}/rvm-download

# rbenv plugin: rbenv-gem-rehash
git clone https://github.com/sstephenson/rbenv-gem-rehash.git ${RBENV_PLUGINS_ROOT}/rbenv-gem-rehash

# rbenv plugin: default-gems
git clone https://github.com/sstephenson/rbenv-default-gems.git ${RBENV_PLUGINS_ROOT}/rbenv-default-gems

rbenv install 2.7.1
rbenv global 2.7.1
rbenv rehash
gem install bundler --no-document
rbenv rehash

# default gems
cat << EOF > ${RBENV_ROOT}/default-gems
bundler
EOF

# production installing gems skipping ri and rdoc
cat << EOF > ~/.gemrc
install: --no-document
update: --no-document
EOF

# rbenv plugin: rbenv-bundler
git clone -- https://github.com/carsomyr/rbenv-bundler.git ${RBENV_PLUGINS_ROOT}/bundler

# database setup
sudo -u postgres psql -c "DROP DATABASE IF EXISTS ror_lernportal_development;"
sudo -u postgres psql -c "DROP USER IF EXISTS vagrant;"

sudo -u postgres psql -c "CREATE USER vagrant WITH PASSWORD 'ror_lernportal-4zw%HnR85&5280' CREATEDB;"
sudo -u postgres psql -c "CREATE DATABASE ror_lernportal_development;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE ror_lernportal_development TO vagrant;"
sudo -u postgres psql -c "ALTER ROLE vagrant WITH SUPERUSER;"

# yarn
npm install --global yarn
