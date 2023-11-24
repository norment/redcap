# must be ended with a new line "LF" (Unix) and not "CRLF" (Windows)
12 0 * * * BASH_ENV=/etc/profile /etc/cron.d/redcap_backup.sh > /proc/1/fd/1 2>/proc/1/fd/2
# An empty line is required at the end of this file for a valid cron file.
