ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm-alpine

ARG TZ
ARG PHP_EXTENSIONS
ARG PHP_BUILD_EXTENSIONS_DIR
ARG ALPINE_REPOSITORIES
ARG PHP_PECL_REDIS_VERSION
ARG PHP_PECL_MONGODB_VERSION
ARG PHP_DEFAULT_INI_MODE

# 换源
RUN if [ "${ALPINE_REPOSITORIES}" != "" ]; then \
        sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_REPOSITORIES}/g" /etc/apk/repositories;\
        apk update; \
    fi


# 修改时区
RUN apk --no-cache add tzdata \
    && cp "/usr/share/zoneinfo/$TZ" /etc/localtime \
    && echo "$TZ" > /etc/timezone


# 安装扩展
COPY ./php/ext ${PHP_BUILD_EXTENSIONS_DIR}
WORKDIR ${PHP_BUILD_EXTENSIONS_DIR}

ENV EXTENSIONS = ",${PHP_EXTENSIONS},"

RUN export MC="-j$(nproc)" \
    && cp /usr/local/etc/php/php.ini-${PHP_DEFAULT_INI_MODE} /usr/local/etc/php/php.ini \
    && chmod +x install.sh \
    && dos2unix install.sh \
    && sh install.sh \
    && rm -rf  ${PHP_BUILD_EXTENSIONS_DIR}

WORKDIR /srv/www
