nosql-booster-formula
==================

A SaltStack formula designed to install and configure the [NoSQL Boster IDE for MongoDB](https://nosqlbooster.com/) on installation-targets.

It is primarily expected that this formula will be run via [P3](https://www.plus3it.com/)'s "[watchmaker](https://watchmaker.readthedocs.io/en/stable/)" framework.

This formula is able to install the NoSQL Boster IDE for MongoDB on both Linux[^1] and Windows Server[^2] operating environments. Intallation for internet-connected systems may come from the NoSQL Boster IDE for MongoDB product's ["Downloads" page](https://nosqlbooster.com/downloads). Alternately:

* Sites whose installation-targets won't be able to reach the NoSQL Boster IDE for MongoDB product's "Downloads" page will need to self-host copies of the desired content.
* Sites that wish to use a specific version of the NoSQL Boster IDE for MongoDB will need to target that content

Targeting specific versions of the NoSQL Boster IDE for MongoDB or local copies of the install-archives can be directed to do so by adding appropriate content to the formula's associated Pillar-data (see thish projct's [pillar.example](pillar.example) file for guidance).


## Available states

- [nosql-booster](#nosql-booster)
- [nosql-booster.clean](#nosql-booster.clean)
- [nosql-booster.package](#nosql-booster.package)
- [nosql-booster.package.clean](#nosql-booster.package.clean)
- [nosql-booster.config](#nosql-booster.config)
- [nosql-booster.config.clean](#nosql-booster.config.clean)

### nosql-booster

Executes the `package` and `config` states to install and configure the NoSQL Boster IDE for MongoDB

### nosql-booster.clean

Executes the `package` and `config` states' `clean` actions to fully uninstall the NoSQL Boster IDE for MongoDB and remove previously-installed browser policy-configs (and, on Windows, associated registry entries)

### nosql-booster.package

Executes _just_ the `package` state to install the NoSQL Boster IDE for MongoDB package.

### nosql-booster.package.clean

Executes _just_ the `package.clean` state to uninstall the NoSQL Boster IDE for MongoDB package.

### nosql-booster.config

Executes _just_ the `config` state to install/configure the NoSQL Boster IDE for MongoDB client-configuration (etc.) files

### nosql-booster.config.clean

Executes _just_ the `config` state to uninstall the NoSQL Boster IDE for MongoDB client-configuration (etc.) files and, on Windows, remove any registry-keys set by prior install-runs of the formula.

## Compatibility Notes:


[^1]: As of this README's writing, only Enterprise Linux and related distros (Red Hat and Oracle Enterprise, CentOS Stream, Rocky and Alma Linux). It has only been specifically tested with EL **_9_** variants.
[^2]: As of this README's writing, this functionality has only been tested on Windows Server 2022
