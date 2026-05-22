# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as nosql_booster with context %}

nosql-booster-package-install-pkg-installed:
  pkg.installed:
    - name: {{ nosql_booster.pkg.name }}
