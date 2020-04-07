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

if [ -z "${EXTENSIONS##*,openssl,*}" ]; then
    echo "---------- Install openssl ----------"
    apk add --no-cache --virtual .build-openssl-deps \
        libressl-dev

fi

if [ -z "${EXTENSIONS##*,mongodb,*}" ]; then
    echo "---------- Install mongodb ----------"
    pecl install mongodb
    docker-php-ext-enable mongodb
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
    pecl install redis
    docker-php-ext-enable redis
fi

if [ -z "${EXTENSIONS##*,zip,*}" ]; then
    echo "---------- Install zip ----------"
    apk add --no-cache --virtual .build-zip-deps \
       libzip-dev

    docker-php-ext-install ${MC} zip
fi

if [ -z "${EXTENSIONS##*,amqp,*}" ]; then
    echo "---------- Install amqp ----------"
    apk add --no-cache --virtual .build-amqp-deps \
       rabbitmq-c-dev

    pecl install amqp

    docker-php-ext-enable amqp
fi

if [ -z "${EXTENSIONS##*,rdkafka,*}" ]; then
    echo "---------- Install rdkafka ----------"
    apk add --no-cache --virtual .build-rdkafka-deps \
       librdkafka-dev

    pecl install rdkafka

    docker-php-ext-enable rdkafka
fi

if [ -z "${EXTENSIONS##*,swoole,*}" ]; then
    echo "---------- Install swoole ----------"
    pecl install swoole

    docker-php-ext-enable swoole
fi

if [ -z "${EXTENSIONS##*,soap,*}" ]; then
    echo "---------- Install soap ----------"
    apk add --no-cache libxml2-dev
	  docker-php-ext-install ${MC} soap
fi

if [ -z "${EXTENSIONS##*,xdebug,*}" ]; then
    echo "---------- Install xdebug ----------"
    pecl install xdebug
    docker-php-ext-enable xdebug
fi

echo "---------- Install Complete ---------"

if [ "${PHP_EXTENSIONS}" != "" ]; then
    echo "---------- Del  build-deps ----------"
    apk del .build-deps
fi

