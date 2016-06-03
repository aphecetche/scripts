#!/bin/sh

test=`alien-token-info | grep -c expired`

if [ $test -gt 0 ]; then
  echo "Token expired. Getting a new token"
  alien-token-destroy
  alien-token-init
elif [ ! -e /tmp/gclient_env_$UID ]; then
  echo "Getting a token"
  alien-token-init
fi

if [ ! -e /tmp/gclient_env_$UID ]; then
  echo "No token. Exiting"
  exit
fi

source /tmp/gclient_env_$UID

export alien_API_USER=laphecet

$*
