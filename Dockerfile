FROM php:8.0.3-fpm-alpine

RUN apk update && apk upgrade
# Install dependencies
RUN apk add mariadb-client libpng-dev postgresql-dev libssh-dev zip libzip-dev libxml2-dev jpegoptim optipng pngquant gifsicle unzip git libxslt-dev curl rabbitmq-c-dev icu-dev oniguruma-dev

RUN docker-php-ext-install zip opcache pdo_mysql pdo_pgsql mysqli mbstring bcmath sockets xsl exif gd intl

RUN curl -L -o /usr/local/bin/pickle https://github.com/FriendsOfPHP/pickle/releases/download/v0.6.0/pickle.phar \
&& chmod +x /usr/local/bin/pickle

# Install extensions
RUN apk add --no-cache $PHPIZE_DEPS \
   && pickle install redis \
   && docker-php-ext-enable redis

WORKDIR /var/www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]