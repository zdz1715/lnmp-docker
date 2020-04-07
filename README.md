# php docker集成环境
### 包含的镜像：
* app：基于alpine的php-fpm和nginx的镜像
* mysql
* redis
* mongo
* mongo-express：mongod管理界面

### 使用方法
1. 复制`docker-compose.yml.sample、.env.sample`分别为
`docker-compose.yml、.env`
2. 选择使用已有app镜像还是自己构建，取消相对应注释
3. 执行`docker-compose up`或者后台运行`docker-compose up -d`
```dockerfile
version: '3'
services:
  app:
    cap_add:
      - SYS_PTRACE
#    image: zdzserver/lnmp-app # 使用已有的镜像（快速）
#    build: # 自己构建（php安装扩展越多，越慢）
#      context: .
#      args:
#        TZ: ${TZ}
#        ALPINE_REPOSITORIES: ${ALPINE_REPOSITORIES}
#        PHP_VERSION: ${PHP_VERSION:-7.4.3}
#        PHP_EXTENSIONS: ${PHP_EXTENSIONS}

``` 



#### php扩展
根据`.env`里的`PHP_EXTENSIONS`值安装，请根据需要安装，减少构建时间，支持的扩展如下：
* bcmath
* mysqli
* opcache
* pdo_mysql
* redis
* zip
* gd
* mongodb
* openssl
* rdkafka 
* swoole
* amqp
* soap
* xdebug

