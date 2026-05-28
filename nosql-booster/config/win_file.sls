# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as nosql_booster with context %}

include:
  - {{ sls_package_install }}

NoSQL Booster Desktop Shortcut:
  file.shortcut:
    - icon_location: '{{ nosql_booster.config.install_root }}\NoSQLBooster for MongoDB.exe'
    - name: 'C:\Users\Public\Desktop\NoSQLBooster for MongoDB.lnk'
    - require:
      - cmd: 'Install NoSQL Booster'
    - target: '{{ nosql_booster.config.install_root }}\NoSQLBooster for MongoDB.exe'
    - working_dir: '{{ nosql_booster.config.install_root }}'

NoSQL Booster System Path Update:
  win_path.exists:
    - name: '{{ nosql_booster.config.install_root }}'
    - require:
      - cmd: 'Install NoSQL Booster'
      - file: 'NoSQL Booster Desktop Shortcut'
