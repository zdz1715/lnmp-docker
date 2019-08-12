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
    # 换源
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
    apk update

    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        autoconf \
        freetype-dev \
        icu-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libzip-dev \
        openldap-dev \
        pcre-dev
fi

echo "---------- Install extra dependencies ----------"

if [ -z "${EXTENSIONS##*,mysqli,*}" ]; then
    echo "---------- mysqli ----------"
    docker-php-ext-install ${MC} mysqli
fi


echo "---------- Del  build-deps ----------"
if [ "${PHP_EXTENSIONS}" != "" ]; then
    	apk del .build-deps
fi


