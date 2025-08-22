FROM php:8.1-fpm

MAINTAINER sagit

# 安装系统依赖
RUN apt-get update && apt-get install -y \
        libicu-dev \
        libxml2-dev \
        libzip-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libonig-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libmcrypt-dev \
        libxslt1-dev \
        libkrb5-dev \
        zlib1g-dev \
        wget unzip git nano \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        mysqli \
        gd \
        intl \
        zip \
        mbstring \
        curl \
        soap \
        exif \
        bcmath \
        opcache \
    && rm -rf /var/lib/apt/lists/*

# 安装 ionCube Loader
RUN curl -fsSL https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    | tar -xz -C /tmp \
    && cp /tmp/ioncube/ioncube_loader_lin_8.1.so /usr/local/lib/php/extensions/no-debug-non-zts-*/ \
    && echo "zend_extension=ioncube_loader_lin_8.1.so" > /usr/local/etc/php/conf.d/00-ioncube.ini \
    && rm -rf /tmp/ioncube

# 设置 PHP 配置
RUN echo "output_buffering = 4096" > /usr/local/etc/php/conf.d/php.ini \
    && echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/php.ini \
    && echo "upload_max_filesize = 50M" >> /usr/local/etc/php/conf.d/php.ini \
    && echo "post_max_size = 50M" >> /usr/local/etc/php/conf.d/php.ini \
    && echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/php.ini

WORKDIR /var/www/html

