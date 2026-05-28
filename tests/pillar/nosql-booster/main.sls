nosql-booster:
  lookup:
    pkg:
      {%- if grains.os_family == "RedHat" %}
      download_uri: 'https://s3.nosqlbooster.com/download/releasesv10/nosqlbooster4mongo-10.1.7.tar.gz'
      {%- elif grains.os_family == "Windows" %}
      download_sig: 'sha256=a3acb4438272902284c1469a17fef5ad22a43ff76a539a7753d94be2106bd011'
      download_uri: 'https://s3.nosqlbooster.com/download/releasesv10/nosqlbooster4mongo-10.1.7.exe'
      name: 'nosqlbooster'
      reg_guid: '{227bc20d-e19b-5c52-9f1d-31ef30b24843}'
      {%- endif %}
