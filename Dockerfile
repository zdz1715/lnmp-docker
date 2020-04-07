ARG PHP_VERSION=7.4.3
# alpine php-fpm
FROM php:${PHP_VERSION}-fpm-alpine
ARG TZ=Asia/Shanghai
ARG ALPINE_REPOSITORIES=mirrors.aliyun.com
ARG PHP_EXTENSIONS=bcmath,mysqli,opcache,pdo_mysql,redis,zip,gd,mongodb,openssl,rdkafka,swoole,amqp,soap,xdebug

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

# 安装nginx
RUN apk add nginx && mkdir /var/run/nginx

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
