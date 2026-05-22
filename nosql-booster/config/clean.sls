# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as nosql_booster with context %}

include:
{%- if grains.kernel == "Linux" %}
  - nosql-booster.config.lin_clean
{%- elif grains.kernel == "Windows" %}
  - nosql-booster.config.win_clean
{%- endif %}

Avoid being a null-router (config/clean) - NoSQL Booster:
  test.nop: []
