# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as nosql_booster with context %}

include:
  - {{ sls_config_clean }}

nosql-booster-package-clean-pkg-removed:
  pkg.removed:
    - name: {{ nosql_booster.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
