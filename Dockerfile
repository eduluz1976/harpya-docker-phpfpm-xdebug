FROM centos:latest

LABEL name="harpya-fpm-xdebug"
LABEL vcs-url="https://github.com/eduluz1976/harpya-docker-phpfpm-xdebug"
LABEL maintainer="Eduardo Luz <eduardo at eduardo-luz dot com>"
LABEL version="0.2.1"
LABEL release-date="2019-10-13"

WORKDIR /srv/app

COPY  run_fpm.sh /root
COPY  xdebug-2.7.2.tgz /root

COPY xdebug.ini /usr/local/etc/php/conf.d



RUN  yum -y install epel-release
RUN  yum -y --nobest install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN  yum-config-manager --enable remi-php72



RUN curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.rpm.sh |  bash

RUN  yum -y install initscripts
RUN  yum -y update
RUN  yum -y install php php-common.x86_64 php-devel.x86_64  php-fpm.x86_64 php-gd.x86_64 \
                    php-intl.x86_64 php-json.x86_64 php-mbstring.x86_64 php-mysqlnd.x86_64 \
                    php-pdo.x86_64 php-pecl-igbinary.x86_64 php-pecl-mongodb.x86_64 \
                    php-pecl-swoole4.x86_64 php-pgsql.x86_64 php-process.x86_64 php-bcmath.x86_64 \
                    php-xml.x86_64 php-opcache.x86_64 php-pecl-redis.x86_64 php-pecl-zip.x86_64 \
                    php72u-phalcon php-phalcon4.x86_64 php-sodium.x86_64 composer.noarch \
                    php-pecl-decimal.x86_64 php-pecl-ds.x86_64

RUN yum -y install wget curl vim unzip git autoconf libc-dev pkg-config \
                         libicu-dev libmcrypt-dev libpq-dev libxml2-dev unzip zlib1g-dev vim libsodium-dev \
                       libcurl4-openssl-dev libssl-dev make pkgconfig

RUN  cd /root && tar -xvzf xdebug-2.7.2.tgz && cd xdebug-2.7.2 \
        && phpize && ./configure \
        &&  make && cp modules/xdebug.so /usr/lib64/php/modules/ \
        && echo "zend_extension = /usr/lib64/php/modules/xdebug.so" >> /etc/php.ini


RUN composer global require --no-interaction hirak/prestissimo

RUN mkdir /run/php-fpm
RUN rm -f /etc/php-fpm.d/www.conf

ENV PATH $HOME/.composer/vendor/bin:$PATH

COPY www.conf /etc/php-fpm.d/

EXPOSE 9000

#start PHP-FPM
CMD [ "php-fpm", "-F"]

