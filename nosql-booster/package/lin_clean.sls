# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as nosql_booster with context %}

include:
  - {{ sls_config_clean }}

Binary Wrapper Removal:
  file.absent:
    - name: '/usr/local/bin/nosqlbooster'

Install Root Removal:
  file.absent:
    - name: '{{ nosql_booster.config.install_root }}'
