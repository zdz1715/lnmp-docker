#!/bin/sh

# nginx
if [ ! -d "/run/nginx/" ];then
  mkdir /run/nginx/
fi;

nginx

# php-fpm
php-fpm
