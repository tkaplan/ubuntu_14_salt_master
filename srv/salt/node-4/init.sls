include:
  - node

node_4:
  pkg.installed:
    - pkgs:
      - node

upgrade_node:
  cmd.script:
    - name: upgrade_node
    - source: salt://upgrade-node.sh
    - cwd: /
    - require:
      - pkg: node_4