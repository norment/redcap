#!/usr/bin/env bash
export memory_limit=4G
export max_execution_time=800
export post_max_size=8G
export upload_max_filesize=8G
export max_input_vars=100000

for key in upload_max_filesize post_max_size max_execution_time max_input_vars memory_limit
do
 sed -i "s/^\($key\).*/\1 $(eval echo = \${$key})/" /usr/local/etc/php/php.ini
 sed -i "s/^;\($key\).*/\1 $(eval echo = \${$key})/" /usr/local/etc/php/php.ini
done