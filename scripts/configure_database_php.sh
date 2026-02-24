#!/usr/bin/env bash
set -euo pipefail

target="${1:-redcap/database.php}"

if [ ! -f "$target" ]; then
  echo "error: database.php not found at $target" >&2
  echo "usage: $0 /path/to/redcap/database.php" >&2
  exit 1
fi

tmp="$(mktemp)"
awk '
  {
    if ($0 ~ /^[[:space:]]*\$hostname[[:space:]]*=/) {
      print "$hostname   = '\''database'\'';";
      next
    }
    if ($0 ~ /^[[:space:]]*\$db[[:space:]]*=/) {
      print "$db        = $_ENV['\''MYSQL_DATABASE'\''];";
      next
    }
    if ($0 ~ /^[[:space:]]*\$username[[:space:]]*=/) {
      print "$username  = $_ENV['\''MYSQL_REDCAP_USER'\''];";
      next
    }
    if ($0 ~ /^[[:space:]]*\$password[[:space:]]*=/) {
      print "$password  = $_ENV['\''MYSQL_ROOT_PASSWORD'\''];";
      next
    }
    if ($0 ~ /^[[:space:]]*\$salt[[:space:]]*=/) {
      print "$salt      = $_ENV['\''REDCAP_SALT'\''];";
      next
    }
    print
  }
' "$target" > "$tmp"

for needle in "MYSQL_DATABASE" "MYSQL_REDCAP_USER" "MYSQL_ROOT_PASSWORD" "REDCAP_SALT"; do
  if ! grep -q "$needle" "$tmp"; then
    echo "error: failed to set $needle in $target" >&2
    rm -f "$tmp"
    exit 1
  fi
done

if ! grep -Eq "^[[:space:]]*\\$hostname[[:space:]]*=[[:space:]]*'database';" "$tmp"; then
  echo "error: failed to set hostname to database in $target" >&2
  rm -f "$tmp"
  exit 1
fi

mv "$tmp" "$target"
