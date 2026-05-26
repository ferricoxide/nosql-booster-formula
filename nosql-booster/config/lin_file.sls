# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as nosql_booster with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

Ensure NoSQL Booster Contents are Readable:
  file.directory:
    - dir_mode: 755
    - file_mode: 644
    - group: root
    - name: '{{ nosql_booster.config.install_root }}'
    - recurse:
      - user
      - group
      - mode
    - require:
      - sls: {{ sls_package_install }}
    - user: root

NoSQL Booster Desktop Entry:
  file.managed:
    - context:
        install_root: {{ nosql_booster.config.install_root }}
    - group: root
    - mode: 644
    - name: /usr/share/applications/nosqlbooster.desktop
    - require:
      - sls: {{ sls_package_install }}
    - source: {{ files_switch(['nosqlbooster.desktop.jinja'], lookup='NoSQL Booster Desktop Entry') }}
    - template: jinja
    - user: root

Set NoSQL Booster Directory SELinux Context:
  selinux.fcontext_policy_present:
    - name: '{{ nosql_booster.config.install_root }}(/.*)?'
    - require:
      - sls: {{ sls_package_install }}
    - sel_type: usr_t

Set NoSQL Booster Binary SELinux Context:
  selinux.fcontext_policy_present:
    - name: '{{ nosql_booster.config.install_root }}/nosqlbooster4mongo'
    - require:
      - sls: {{ sls_package_install }}
    - sel_type: bin_t

Restore NoSQL Booster Context:
  module.run:
    - onchanges:
      - selinux: Set NoSQL Booster Directory SELinux Context
      - selinux: Set NoSQL Booster Binary SELinux Context
    - require:
      - selinux: Set NoSQL Booster Directory SELinux Context
      - selinux: Set NoSQL Booster Binary SELinux Context
      - sls: {{ sls_package_install }}
    - selinux.restorecon:
      - path: '{{ nosql_booster.config.install_root }}'
      - recursive: True  # Changed to True to cover the directory policy
