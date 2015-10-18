#!/bin/bash

# Get remote ips
echo "Lets setup your master salt"
ifconfig
echo "What ips do you want postgres to allow? Use a value like 192.168.0.0/24 where 0 is a wild card"
read pgip_remote
export PGIP_REMOTE=$pgip_remote
ifconfig
echo "What is the ip of your salt master?"
read salt_master_ip
export SALT_MASTER_IP=$salt_master_ip

echo "What do you want your postgres db password to be?"
read postgres_pass
export POSTGRES_PASS=$postgres_pass

if [ -f /home/$USER/.ssh/id_rsa.pub ]; then
  echo "Detected ssh keys. We are using this for ssh key access to your salt minions."
else
  echo "Lets generate an ssh key for you! Press anything to continue."
  read anything
  echo /home/$USER/.ssh/id_rsa | ssh-keygen -t rsa
  echo "Public key path is /home/$USER/.ssh/id_rsa"
fi

echo "Making /srv/salt-nfs"
mkdir -p /srv/salt-nfs/postgres

cp /home/$USER/.ssh/id_rsa.pub /srv/salt-nfs/authorized_keys
echo "Ssh key added"

# Install dependencies
add-apt-repository ppa:saltstack/salt
apt-get update
apt-get install -y software-properties-common
apt-get install -y python-software-properties
apt-get install -y salt-master salt-syndic salt-cloud salt-ssh salt-api

# Make required directories
echo "Building required directories in /srv"
mkdir -p /srv/pillar/openssh /srv/pillar/postgres-dev /srv/salt/node-4 /srv/salt/ritzel-api
cp -rf ./srv/pillar/* /srv/pillar
cp -rf ./srv/salt/* /srv/salt
cp ./srv/salt-nfs/* /srv/salt-nfs

# Replace our pg_hba.conf file
echo "Replaced pg_hba.conf file in /srv/salt-nfs/postgres/pg_hba.conf"
perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg' < ./srv/salt-nfs/postgres/pg_hba.conf > /srv/salt-nfs/postgres/pg_hba.conf

echo "Creating default master"
mv /etc/salt/master /etc/salt/master-default

# Replace our master
perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg' < ./master > /etc/salt/master

perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg' < ./srv/salt-nfs/postgres/ritzel-postgres-conf.sh > /srv/salt-nfs/postgres/ritzel-postgres-conf.sh

service postgresql restart

echo "Setup complete. sudo pkill salt-master to stop. sudo salt-master -d to start."
