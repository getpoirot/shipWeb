#!/bin/bash

## Set Environment From Docker To Global Bash
INSTALL_XDEBUG=$(bash -c 'echo "${INSTALL_XDEBUG?false}"')
HOST_IP=$(bash -c 'echo "${HOST_IP?false}"')


## Server Start Up
#
printf "\033[0;32m > Server Running ...\n"
printf "\033[0;35m ${HOST_IP} \n"


## Boot Server
#
if [ ! -f /docker/initialized ]; then
   bootup
fi

initup


# Start supervisord and services
exec /usr/bin/supervisord -n -c /etc/supervisord.conf
