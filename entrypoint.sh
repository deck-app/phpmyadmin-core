#!/bin/sh

export PHP_UPLOAD_MAX_FILESIZE=${PHP_UPLOAD_MAX_FILESIZE:-200M}
export PHP_POST_MAX_SIZE=${PHP_POST_MAX_SIZE:-80M}
export PHP_MEMORY_LIMIT=${PHP_MEMORY_LIMIT:-128M}
export PHP_MAX_EXECUTION_TIME=${PHP_MAX_EXECUTION_TIME:-600}

config=$PHPMYADMIN_DIR/config.inc.php
if [ "`grep NO_SECRET $config`" != "" ]; then
  secret=$(cat /dev/urandom  | uuencode -m - | head -2 | tail -1)
  sed -i "s,NO_SECRET,$secret," $config
fi

if [ "$1" = "" ]; then
  exec /usr/sbin/httpd -D FOREGROUND
else
  exec "$@"
fi