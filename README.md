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

*  The site's Pillar's `nosql-booster:lookup:pkg:download_uri`[^3] parameter's value is the URI that this formula should attempt to download the NoSQL Booster setup-file or installation-archive from.
*  The site's Pillar's `nosql-booster:lookup:pkg:download_sig`[^3] parameter's value is calculated by performing

    ```bash
    curl -L <DOWNLOAD_URI> | \
    sha256sum | \
    awk '{ print "sha256=" $1 }'
    ```




### Linux:

1.  When launching from a terminal session's interactive shell, the `nosqlbooster` command may emit informational messages like:
    ```bash
    $ nosqlbooster
    (node:1838) electron: The default of contextIsolation is deprecated and will be changing from false to true in a future release of Electron.  See https://github.com/electron/electron/issues/23506 for more information
    $
    ```
    These are generally innocuous
1.  A successful launch on a freshely-built instance will produce a window like:
    <img src="/docs/images/NoSQLBooster-SplashPage-RHEL9.png">

### Windows:

1.  Due to peculiarities in the Windows setup/installer EXE, it was necessary to work around those issues by leveraging filesystem-junctions. The use of filesystem-junctions ensure that the installer places files in the desired directory (default: `C:\Program Files\NoSQLBooster`; see [`.../default.yaml`](nosql-booster/parameters/defaults.yaml) or [`pillar.example`](pillar.example) for more information) for override-options). However, the result of this workaround is that registry-entries need to be modified after the setup/installer EXE finishes its execution. This adds the further requirement that a site's Pillar payload need also include an associated GUID for the requested installer-download.
1.  To get the GUID-value mentioned in the prior list-entry:

    1.   Execute the target version of the setup.EXE
    1.   Execute the following PS snippet:

            ```
	        $path = "Registry::HKEY_USERS\S-1-5-18\Software\Microsoft\Windows\CurrentVersion\Uninstall"
	        Get-ChildItem -Path $path | Get-ItemProperty |
                    Where-Object { $_.DisplayName -like "*NoSQLBooster*" } |
                    Select-Object DisplayName, PSChildName
            ```

    1.   The preceding will produce two, labeled columns of output like:

            ```
	        DisplayName                     PSChildName
	        -----------                     -----------
	        NoSQLBooster for MongoDB 10.1.7 {227bc20d-e19b-5c52-9f1d-31ef30b24843}
            ```

    The target GUID-value is in the `PSChildName` column. This will be the value to set for the site's Pillar's `nosql-booster:lookup:pkg:reg_guid` parameter.
1.  The automation will update the system's `PATH` env, add a launcher-icon on _new_ users[^4] desktops and add a launcher-icon to the system's `Start` menu


[^1]: As of this README's writing, only Enterprise Linux and related distros (Red Hat and Oracle Enterprise, CentOS Stream, Rocky and Alma Linux). It has only been specifically tested with EL **_9_** variants.
[^2]: As of this README's writing, this functionality has only been tested on Windows Server 2022
[^3]: The `nosql-booster:lookup:pkg:download_uri` and `nosql-booster:lookup:pkg:download_sig` are per-platform values. Ensure that the site's Pillar-file uses platform-keyed entries.
[^4]: It's anticipated that this automation will be run _prior_ to the creations of application-users. Any users created before this formula is run may not receive the mentioned icon-updates. If any such users need and are missing these icons, their absence can be fixed by running a short PowerShell script like:
    ```
    # Define targeted users
    $targetUsers = @("<USER_1>", "<USER_2>", ... "<USER_N>")
    
    # Source paths from global locations
    $srcD = "C:\Users\Public\Desktop\NoSQLBooster for MongoDB.lnk"
    $srcS = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\" +
            "NoSQLBooster for MongoDB.lnk"
    
    foreach ($user in $targetUsers) {
        $uPath = "C:\Users\$user"
        
        if (Test-Path $uPath) {
            Write-Host "Processing user: $user" -ForegroundColor Cyan
            
            # Target Desktop
            $dstD = Join-Path $uPath "Desktop\NoSQLBooster for MongoDB.lnk"
            if (Test-Path $srcD) {
                Copy-Item $srcD $dstD -Force -ErrorAction SilentlyContinue
            }
    
            # Target Start Menu
            $sm = "AppData\Roaming\Microsoft\Windows\Start Menu\Programs"
            $dstS = Join-Path $uPath "$sm\NoSQLBooster for MongoDB.lnk"
            if (Test-Path $srcS) {
                Copy-Item $srcS $dstS -Force -ErrorAction SilentlyContinue
            }
        } else {
            Write-Warning "Profile not found for user: $user"
        }
    }
    ```
