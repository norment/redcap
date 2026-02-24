**Overview**
This directory contains helper scripts to apply local configuration changes to a REDCap source tree after unzipping it.

**configure_database_php.sh**
Usage:
```bash
bash scripts/configure_database_php.sh /path/to/redcap/database.php
```
Default target: `redcap/database.php`

What it does:
- Sets `$hostname` to `'database'`.
- Reads `$db`, `$username`, and `$password` from `$_ENV`.
- Sets `$salt` from `$_ENV['REDCAP_SALT']`.

Notes:
- Safe to re-run; it overwrites the existing values in the MySQL connection section and `$salt`.

**configure_ldap_config_usit_tsd.sh**
Usage:
```bash
bash scripts/configure_ldap_config_usit_tsd.sh /path/to/redcap/webtools2/ldap/ldap_config.php
```
Default target: `redcap/webtools2/ldap/ldap_config.php`

What it does:
- Replaces the `$GLOBALS['ldapdsn']` array with the USIT TSD LDAP settings.

Notes:
- This script is specific to USIT TSD. For other environments, copy and edit the script or update `ldap_config.php` manually.
- Safe to re-run; it overwrites the first `$GLOBALS['ldapdsn']` block it finds.
