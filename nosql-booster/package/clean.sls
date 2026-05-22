# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as nosql_booster with context %}

include:
  - {{ sls_config_clean }}
{%- if grains.kernel == "Linux" %}
  - nosql-booster.package.lin_clean
{%- elif grains.kernel == "Windows" %}
  - nosql-booster.package.win_clean
{%- endif %}

Avoid being a null-router (package/clean) - NoSQL Booster:
  test.nop: []
