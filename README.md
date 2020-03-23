# php docker集成环境
### 包含的镜像：
* app：基于alpine的php-fpm和nginx的镜像
* mysql
* redis
* mongo
* mongo-express：mongod管理界面

### 使用方法
复制docker-compose.yml.sample、env.sample分别为
docker-compose.yml、.env，然后执行`docker-compose up`或者后台运行`docker-compose up -d`

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

