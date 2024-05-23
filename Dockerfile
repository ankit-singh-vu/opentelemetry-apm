# Pull in dependencies with composer
FROM composer:2.5 as build
COPY composer.json ./
RUN composer install --ignore-platform-reqs
FROM wordpress:latest
# WORKDIR /usr/src/wordpress
# WORKDIR /var/www/html
# Install the opentelemetry and protobuf extensions
RUN apt-get install gcc make autoconf
RUN pecl install opentelemetry protobuf
RUN apt-get update
RUN apt-get install zlib1g-dev
RUN pecl install grpc \
  && docker-php-ext-enable grpc
COPY otel.php.ini $PHP_INI_DIR/conf.d/.
COPY --from=build /app/vendor /var/www/otel