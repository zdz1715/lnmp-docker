ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm-alpine

ARG TZ
ARG PHP_EXTENSIONS
ARG PHP_BUILD_EXTENSIONS_DIR
# 修改时区
#RUN apk --no-cache add tzdata \
#    && cp "/usr/share/zoneinfo/$TZ" /etc/localtime \
#    && echo "$TZ" > /etc/timezone

# 安装扩展
COPY ./php/ext ${PHP_BUILD_EXTENSIONS_DIR}
WORKDIR ${PHP_BUILD_EXTENSIONS_DIR}

ENV EXTENSIONS = ",${PHP_EXTENSIONS},"
ENV MC="-j $(nproc)"

RUN chmod +x install.sh \
    && sh install.sh \
    && rm -rf  ${PHP_BUILD_EXTENSIONS_DIR}\
    && echo 'end'

WORKDIR /srv/www

