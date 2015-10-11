#!/bin/bash
mv /etc/postgresql/9.3/main/pg_hba.conf /etc/postgresql/9.3/main/pg_hba-default.conf
cp /tmp/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf

echo "listen_addresses = '*'" >> /etc/postgresql/9.3/main/postgresql.conf
sudo -u postgres psql -U postgres -d postgres -c "alter user postgres with password '${POSTGRES_PASS}';"
