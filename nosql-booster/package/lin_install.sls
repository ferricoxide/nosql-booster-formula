# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as nosql_booster with context %}

Install NoSQL Booster Dependencies:
  pkg.installed:
    - pkgs:
      - alsa-lib
      - at-spi2-atk
      - atk
      - cups-libs
      - dejavu-sans-fonts
      - gtk3
      - libX11
      - libXScrnSaver
      - libXcomposite
      - libXcursor
      - libXdamage
      - libXext
      - libXfixes
      - libXi
      - libXrandr
      - libXrender
      - libXtst
      - libdrm
      - mesa-libgbm
      - nss
      - pango
