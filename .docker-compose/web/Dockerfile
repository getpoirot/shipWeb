# --------------------------------------------------------------------
# | Build Image:
# |   git clone https://github.com/E1101/nginx-php-fpm && cd nginx-php-fom
# |   docker build -t nginx-php-fpm:latest .
# |
# |
FROM richarvey/nginx-php-fpm:latest


## Arguments:
## ----------------------------------------------------------------------------------------
ARG PUID=1000
ARG PGID=1000
ARG INSTALL_PHP_PDOMYSQL=false
ARG INSTALL_PHP_MONGODB=false
ARG INSTALL_PHP_MONGODB_VER=1.2.9
ARG INSTALL_XDEBUG=false


ENV PHPIZE_DEPS \
    autoconf \
    cmake \
    file \
    g++ \
    gcc \
    libc-dev \
    pcre-dev \
    make \
    pkgconf \
    re2c

RUN apk update && apk add --no-cache --virtual \
    git

## Non-Root User:
## -----------------------------------------------------------------------------------------
# Add a non-root user to prevent files being created with root permissions on host machine.
ENV PUID ${PUID}
ENV PGID ${PGID}

RUN addgroup -g "$PGID" -S myuser \
    && adduser -u "$PUID" -G myuser -S myuser

# fix nginx/php user permission
RUN echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories
RUN apk --no-cache add shadow
RUN usermod -o -u "$PUID" www-data \
    && usermod -o -u "$PUID" nginx


RUN printf "\033[0;32m >> update phpize dependencies ...\n" \
    && printf "\033[0m\n" \
    && apk update && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS


## Mongo DB:
## -----------------------------------------------------------------------------------------
ENV INSTALL_PHP_MONGODB ${INSTALL_PHP_MONGODB}
ENV INSTALL_PHP_MONGODB_VER=${INSTALL_PHP_MONGODB_VER}

RUN if [ ${INSTALL_PHP_MONGODB} = "true" ]; then \
    printf "\033[0;32m > Install MongoDB Ver.${INSTALL_PHP_MONGODB_VER}...\n" \
    && printf "\033[0m\n" \
    && apk add --no-cache --virtual .persistent-deps \
        # for mongodb
        libssl1.1 \
    && MONGODB_FILENAME="mongodb-${INSTALL_PHP_MONGODB_VER}" \
           && MONGODB_SOURCE="https://github.com/mongodb/mongo-php-driver/releases/download/${INSTALL_PHP_MONGODB_VER}/${MONGODB_FILENAME}.tgz" \
           && curl -fSL --connect-timeout 30 ${MONGODB_SOURCE} | tar xz -C /tmp \
           && cd /tmp/${MONGODB_FILENAME} \
           && phpize \
           && ./configure \
           && make \
           && make install \
           && docker-php-ext-enable mongodb \
;fi


## Maria DB:
## -----------------------------------------------------------------------------------------
ENV INSTALL_PHP_PDOMYSQL ${INSTALL_PHP_PDOMYSQL}

RUN if [ ${INSTALL_PHP_PDOMYSQL} = "true" ]; then \
    printf "\033[0;32m > Install PDO MySQL ...\n" \
    && printf "\033[0m\n" \
    && docker-php-ext-install pdo_mysql \
;fi


## XDebug:
## -----------------------------------------------------------------------------------------
RUN if [ ${INSTALL_XDEBUG} = "true" ]; then \
    printf "\033[0;32m > Install XDebug ...\n" \
    && printf "\033[0m\n" \
    && git clone --depth 1 "https://github.com/xdebug/xdebug" xdebug \
        && ls -al \
        && cd xdebug \
        && phpize \
        && ./configure \
        && make \
        && make install \
        && docker-php-ext-enable xdebug \
;fi


## Cron:
## -----------------------------------------------------------------------------------------
RUN apk update && apk add dcron \
    && rm -rf /var/cache/apk/*

# Give execution rights on the cron job
# Create the log file to be able to run tail
RUN mkdir -p /var/log/cron \
    && touch /var/log/cron/cron.log \
    && mkdir -m 0644 -p /etc/cron.d \
    && chmod -R 0644 /etc/cron.d/.

COPY etc/cron.d /etc/cron.d/


## Nginx Setup:
## -----------------------------------------------------------------------------------------
ADD nginx/sites /etc/nginx/sites-enabled/


## Cleanup:
## -----------------------------------------------------------------------------------------
RUN apk del .build-deps


## Commands:
## -----------------------------------------------------------------------------------------
COPY ./scripts/ /docker/bin/
# compatible with windows
RUN chmod a+x /docker/bin/*.sh \
    && sed -i -e 's/\r$//' /docker/bin/*.sh \
    && ln -s /docker/bin/bootup.sh /usr/local/bin/bootup \
    && ln -s /docker/bin/initup.sh /usr/local/bin/initup

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/var/www/vendor/bin:/docker/bin


WORKDIR /var/www
CMD ["run.sh"]
