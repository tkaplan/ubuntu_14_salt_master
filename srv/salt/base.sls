include:
  - openssh
  - openssh.config

vim:
  pkg.installed: []

build-essential:
  pkg.installed: []

git:
  pkg.installed: []

/home/node/.ssh/authorized_keys:
  file.managed:
    - makedirs: True
    - require:
      - pkg: openssh
    - source: salt://authorized_keys
