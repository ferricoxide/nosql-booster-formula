## nosql-booster-formula

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

### 0.1.1

**Released**: 2026.05.28

**Summary**:

*   Adds Windows functionality:
    *   Uses the NoSQLBooster setup EXE to install the binaries (Pillar-overridable default is `C:\Program Files\NoSQLBooster`)
    *   Sets up desktop launcher-icons for each user created after the formula is run
    *   Sets up `Start` menu launcher-icons for each user created after the formula is run
    *   Updates the OS-wide `PATH` environment-variable to allow easy launch from a `cmd.exe` or PowerShell prompt
    *   Installs any license-files (specified via Pillar) into `C:\Users\Default\AppData\Roaming\NoSQLBooster for MongoDB\license.key`. This _should_ ensure that users get access to the NoSQLBooster application's licensed functionalities
*   Updates Pillar.example to explain the further, Windows-oriented parameters/inputs that may be specified via Pillar
*   Update README with generic and platform-specific (i.e., "Windows") notes

### 0.1.0

**Released**: 2026.05.27

**Summary**:

*   Adds Linux functionality:
    *   Installs the NoSQLBooster binary (as downloaded from [vendor site](https://nosqlbooster.com/downloads))
    *   Creates a wrapper-script at `/usr/local/bin/nosqlbooster`
    *   Sets appropriate file-modes and SELinux contexts on binaries and wrappers
    *   Installs any license-files (specified via Pillar) into `/etc/skel/.config/nosqlbooster4mongo/license.key` (so that subsequently-created users get it populated into their `${HOME}/config/nosqlbooster4mongo/` directory
    *   Implements "cleanup" for all of the preceeding
*   Adds pillar.example to explain parameters/inputs that may be specified via Pillar
*   Update README with platform-notes - includes (LFS-hosted) illustration

### 0.0.1

**Released**: 2026.05.22

**Summary**:

*   Cloned project from https://github.com/plus3it/repo-template
*   Created nosql-booster directory-tree contents by:
    1.   Cloning https://github.com/saltstack-formulas/template-formula.git
    2.   Executing `bin/convert-formula.sh nosql-booster` in the new repo-copy
    3.   Moving the resulting `nosql-booster` directory into this project's space
    4.   Updating all imports from "`redis__insight`" to "`redis_insight`"
*   Update [LICENSE](LICENSE), CHANGELOG.md (this file), [README.md](README.md) and [.bumpversion.cfg](.bumpversion.cfg) per the P3 repo-template guidance
*   Update the `.github` and `tests` directories' contents  per the P3 repo-template guidance

