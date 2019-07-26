#!/bin/bash

## Set Environment From Docker To Global Bash
INSTALL_XDEBUG=$(bash -c 'echo "${INSTALL_XDEBUG?false}"')


printf "\033[0;32m > Bootup ...\n\n"

if [ -f /docker/initialized ]; then
   rm /docker/initialized
fi

chmod 0777 -R /v-share/


if [[ "${INSTALL_XDEBUG:?}" == "true" ]]; then
    ## install composer
    #
    if [ -f /var/www/composer.json ]; then
        printf "\033[0;32m > Installing Composer Packages ...\n\n"
        composer install --ignore-platform-reqs
    fi
else
    if [ -f /var/www/composer.json ]; then
        printf "\033[0;32m > Installing Composer Packages ...\n\n"
        composer install --ignore-platform-reqs --no-dev
    fi
fi


(/docker/bin/gosu.sh)

touch /docker/initialized
