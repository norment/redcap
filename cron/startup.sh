#! /bin/bash
printenv | grep -v "no_proxy" >> /etc/environment # https://stackoverflow.com/a/41938139
cron -f