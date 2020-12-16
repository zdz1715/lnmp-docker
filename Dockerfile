ARG PHP_VERSION=7.4.8
# alpine php-fpm
FROM php:${PHP_VERSION}-fpm-alpine
ARG TZ=Asia/Shanghai
ARG ALPINE_REPOSITORIES=mirrors.aliyun.com
#################################### 内置扩展 ################################################
## Core,ctype,curl,date,dom,fileinfo,filter,ftp,hash,iconv,json,libxml,mbstring,mysqlnd,
## openssl,pcre,PDO,pdo_sqlite,Phar,posix,readline,Reflection,session,SimpleXML,sodium,SPL,
## sqlite3,standard,tokenizer,xml,xmlreader,xmlwriter,zlib
#################################### 可选 ###################################################
## amqp,bcmath,gd,mongodb,mysqli,opcache, pcntl,pdo_mysql,rdkafka,redis,soap,swoole,xdebug,xmlrpc,zip
ARG PHP_EXTENSIONS=amqp,bcmath,gd,mongodb,mysqli,opcache,pcntl,pdo_mysql,redis,soap,swoole,xdebug,xmlrpc,zip

ARG PHP_ETC=/usr/local/etc

# 换源
RUN if [ "${ALPINE_REPOSITORIES}" != "" ]; then \
        sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_REPOSITORIES}/g" /etc/apk/repositories;\
        apk update; \
        echo ${ALPINE_REPOSITORIES}; \
    fi


# 设置时区
RUN apk --no-cache add tzdata \
    && cp "/usr/share/zoneinfo/$TZ" /etc/localtime \
    && echo "$TZ" > /etc/timezone

# 安装nginx 1.18.0
RUN apk add nginx \
    && apk add supervisor

# 安装php扩展
COPY ./php/build /tmp/php-build
WORKDIR /tmp/php-build

ENV EXTENSIONS = ",${PHP_EXTENSIONS},"

RUN export MC="-j$(nproc)" \
    && chmod +x install.sh \
    && dos2unix install.sh \
    && sh install.sh \
    && rm -rf  /tmp/php-build

# 安装composer
RUN curl -o /usr/bin/composer https://mirrors.aliyun.com/composer/composer.phar \
    && chmod +x /usr/bin/composer

EXPOSE 80 433
WORKDIR /srv/www

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh \
    && dos2unix /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
