postgres:
  pg_hba.conf: salt://postgres/pg_hba.conf

  postgresconf: |
    listen_addresses = 'localhost,*'
