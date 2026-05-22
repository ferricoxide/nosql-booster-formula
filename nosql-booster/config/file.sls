# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as nosql_booster with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

nosql-booster-config-file-file-managed:
  file.managed:
    - name: {{ nosql_booster.config }}
    - source: {{ files_switch(['example.tmpl'],
                              lookup='nosql-booster-config-file-file-managed'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ nosql_booster.rootgroup }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        nosql_booster: {{ nosql_booster | json }}
