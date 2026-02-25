#!/usr/bin/env bash
set -euo pipefail

target="${1:-redcap/webtools2/ldap/ldap_config.php}"

if [ ! -f "$target" ]; then
  echo "error: ldap_config.php not found at $target" >&2
  echo "usage: $0 /path/to/redcap/webtools2/ldap/ldap_config.php" >&2
  exit 1
fi

tmp="$(mktemp)"
replacement="$(cat <<'EOF'
$GLOBALS['ldapdsn'] = array(
  'url'           => 'ldap://tsd-dc01.tsd.usit.no',
  'port'          => 389,
  'version'       => 3,
  'referrals'     => false,
  'basedn'        => 'dc=tsd,dc=usit,dc=no',
  'binddn'        => $_POST['username'].'@tsd.usit.no',
  'bindpw'        => $_POST['password'],
  'userattr'      => 'samAccountName',
  'userfilter'    => '(samAccountName='.$_POST['username'].')'
);
EOF
)"

awk -v replacement="$replacement" '
  BEGIN {
    replaced = 0
    skipping = 0
  }
  {
    if (!replaced && $0 ~ /^[[:space:]]*\\$GLOBALS\\[\\x27ldapdsn\\x27\\][[:space:]]*=/) {
      print replacement;
      replaced = 1;
      skipping = 1;
      next;
    }
    if (skipping) {
      if ($0 ~ /^[[:space:]]*\\);[[:space:]]*$/) {
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
' "$target" > "$tmp"

for needle in "tsd-dc01.tsd.usit.no" "samAccountName" "ldapdsn"; do
  if ! grep -q "$needle" "$tmp"; then
    echo "error: failed to set $needle in $target" >&2
    rm -f "$tmp"
    exit 1
  fi
done

mv "$tmp" "$target"
