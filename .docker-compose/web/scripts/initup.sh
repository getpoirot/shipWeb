#!/bin/bash

## Set Environment From Docker To Global Bash
INSTALL_XDEBUG=$(bash -c 'echo "${INSTALL_XDEBUG?false}"')
HOST_IP=$(bash -c 'echo "${HOST_IP?false}"')


printf "\033[0;32m > Initialize Container ...\n\n"


PHPCONF="/usr/local/etc/php/conf.d/xdebug.ini"

if [[ "${INSTALL_XDEBUG:?}" == "true" ]]; then

    HAS_XDEBUG=$(php -r "echo (extension_loaded('xdebug') ? '' : 'non ')")
    if [[ "${HAS_XDEBUG:?}" == "non" ]]; then
        printf "\033[0;32m > XDebug Not Compiled Into Image ...\n"
        printf "\033[0;32m > compile image with xdebug enabled and try again. \n\n"
        exit
    fi

    printf "\033[0;32m > XDebug is Enabled\n"
    printf "\033[0;32m to using xdebug ?XDEBUG_SESSION_START query param.\n"
    printf "\033[0;32m to using xdebug profiler ?XDEBUG_PROFILE query param.\n\n"

    echo "xdebug.remote_enable=1" >> ${PHPCONF}
    echo "xdebug.remote_host=${HOST_IP}" >> ${PHPCONF}
    echo "xdebug.profiler_enable=0" >> ${PHPCONF}
    # ?XDEBUG_PROFILE
    echo "xdebug.profiler_enable_trigger=1" >> ${PHPCONF}
    echo "xdebug.profiler_output_dir=\"/v-share\"" >> ${PHPCONF}

else
    printf "\033[0;32m > XDebug Disabled ...\n"
    printf "\033[0;32m xdebug is disabled by environment variable. \n\n"

    if [ -f ${PHPCONF} ]; then
        rm ${PHPCONF}
    fi
fi


## Cron
#
printf "\033[0;32m > Start Cron ...\n"
printf "\033[0m\n"

# crond running in background and log file reading every second by tail to STDOUT
crond -s /etc/cron.d -b -L /var/log/cron/cron.log "$@" && tail -f /var/log/cron/cron.log &
