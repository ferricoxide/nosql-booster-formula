# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as nosql_booster with context %}

include:
{%- if grains.kernel == "Linux" %}
  - nosql-booster.package.lin_install
{%- elif grains.kernel == "Windows" %}
  - nosql-booster.package.win_install
{%- endif %}

Avoid being a null-router (package/install) - NoSQL Booster:
  test.nop: []
