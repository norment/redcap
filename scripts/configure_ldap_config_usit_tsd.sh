#!/usr/bin/env bash
set -euo pipefail

target="${1:-redcap/webtools2/ldap/ldap_config.php}"

if [ ! -f "$target" ]; then
  echo "error: ldap_config.php not found at $target" >&2
  echo "usage: $0 /path/to/redcap/webtools2/ldap/ldap_config.php" >&2
  exit 1
fi

tmp="$(mktemp)"
awk '
  BEGIN {
    replaced = 0
    skipping = 0
    q = sprintf("%c", 39)
  }
  function print_replacement() {
    print "$GLOBALS[" q "ldapdsn" q "] = array("
    print "  " q "url" q "           => " q "ldap://tsd-dc01.tsd.usit.no" q ","
    print "  " q "port" q "          => 389,"
    print "  " q "version" q "       => 3,"
    print "  " q "referrals" q "     => false,"
    print "  " q "basedn" q "        => " q "dc=tsd,dc=usit,dc=no" q ","
    print "  " q "binddn" q "        => $_POST[" q "username" q "]." q "@tsd.usit.no" q ","
    print "  " q "bindpw" q "        => $_POST[" q "password" q "],"
    print "  " q "userattr" q "      => " q "samAccountName" q ","
    print "  " q "userfilter" q "    => " q "(samAccountName=" q ".$_POST[" q "username" q "]." q ")" q
    print ");"
  }
  {
    # Match either $GLOBALS['ldapdsn'] = ... or $ldapdsn = ...
    if (!replaced && ($0 ~ /^[[:space:]]*\$ldapdsn[[:space:]]*=/ || (index($0, "$GLOBALS[") > 0 && index($0, "ldapdsn") > 0 && index($0, "=") > 0))) {
      print_replacement();
      replaced = 1;
      skipping = 1;
      next;
    }
    if (skipping) {
      if ($0 ~ /^[[:space:]]*\);[[:space:]]*$/) {
        skipping = 0;
      }
      next;
    }
    print;
  }
  END {
    if (!replaced) {
      exit 2;
    }
  }
' "$target" > "$tmp" || {
  rc=$?
  if [ "$rc" -eq 2 ]; then
    echo "error: could not find ldapdsn block in $target" >&2
  else
    echo "error: failed to process $target" >&2
  fi
  rm -f "$tmp"
  exit 1
}

for needle in "tsd-dc01.tsd.usit.no" "samAccountName" "ldapdsn"; do
  if ! grep -q "$needle" "$tmp"; then
    echo "error: failed to set $needle in $target" >&2
    rm -f "$tmp"
    exit 1
  fi
done

mv "$tmp" "$target"
