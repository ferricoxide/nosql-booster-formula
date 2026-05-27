# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as nosql_booster with context %}

Desktop Entry Removal:
  file.absent:
    - name: '/usr/share/applications/nosqlbooster.desktop'

License Key Removal (Skel):
  file.absent:
    - name: '/etc/skel/.config/nosqlbooster4mongo/license.key'

SELinux Binary Context Removal:
  selinux.fcontext_policy_absent:
    - name: '{{ nosql_booster.config.install_root }}/nosqlbooster4mongo'

SELinux Directory Context Removal:
  selinux.fcontext_policy_absent:
    - name: '{{ nosql_booster.config.install_root }}(/.*)?'
