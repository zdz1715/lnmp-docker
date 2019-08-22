#!/bin/sh

echo
echo "============================================"
echo "PHP version               : ${PHP_VERSION}"
echo "Extra Extensions          : ${PHP_EXTENSIONS}"
echo "Multicore Compilation     : ${MC}"
echo "Work directory            : ${PWD}"
echo "============================================"
echo

if [ "${PHP_EXTENSIONS}" != "" ]; then
    echo "---------- Install general dependencies ----------"
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS
fi

echo "---------- Install extra dependencies ----------"

if [ -z "${EXTENSIONS##*,bcmath,*}" ]; then
    echo "---------- Install bcmath ----------"
    docker-php-ext-install ${MC} bcmath
fi

if [ -z "${EXTENSIONS##*,gd,*}" ]; then
    echo "---------- Install gd ----------"
    apk add --no-cache --virtual .build-gd-deps \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
    docker-php-ext-install ${MC} gd
fi

if [ -z "${EXTENSIONS##*,mysqli,*}" ]; then
    echo "---------- Install mysqli ----------"
    docker-php-ext-install ${MC} mysqli
fi

if [ -z "${EXTENSIONS##*,opcache,*}" ]; then
    echo "---------- Install opcache ----------"
    docker-php-ext-install ${MC} opcache
fi

if [ -z "${EXTENSIONS##*,pdo_mysql,*}" ]; then
    echo "---------- Install pdo_mysql ----------"
    docker-php-ext-install ${MC} pdo_mysql
fi

if [ -z "${EXTENSIONS##*,redis,*}" ]; then
    echo "---------- Install redis ----------"
    pecl install redis-${PHP_PECL_REDIS_VERSION}
    docker-php-ext-enable redis
fi

if [ -z "${EXTENSIONS##*,zip,*}" ]; then
    echo "---------- Install zip ----------"
    apk add --no-cache --virtual .build-zip-deps \
       libzip-dev

    docker-php-ext-install ${MC} zip
fi

echo "---------- Install Complete ---------"

if [ "${PHP_EXTENSIONS}" != "" ]; then
    echo "---------- Del  build-deps ----------"
    apk del .build-deps
fi

