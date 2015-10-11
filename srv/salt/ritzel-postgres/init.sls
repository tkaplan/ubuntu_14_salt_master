include:
  - postgres

/tmp/pg_hba.conf:
  file.managed:
    - source: salt://postgres/pg_hba.conf

ritzel_postgres_conf:
  cmd.script:
    - name: ritzel_postgres_conf
    - source: salt://postgres/ritzel-postgres-conf.sh
    - require:
      - file: /tmp/pg_hba.conf
      - sls: postgres

