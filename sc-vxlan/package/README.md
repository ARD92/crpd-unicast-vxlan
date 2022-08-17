This directory consists of all the necessary files for the package to work.
some of the files may not be necessary and will be copied accordingly into the container during buildtime.

The below files are not used
- install.sh
  This is for reference only and has been carried forward from the previous version. The installation is now handled during build time directly and this file is not used
- basic-crpd-config
    This file contains the base config needed for the package to work. Once cRPD is up and in case the config is not loaded, perform the below

    ```
    configure
    load set /var/opt/unicast-vxlan/base-crpd-config
    commit
    ```

ensure juniper.conf is present in main-crpd-config volume mount before starting. This makes sure all configs would be present at start up
