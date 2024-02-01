FROM php:apache-bullseye
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN apt update && apt install git unzip -y
COPY ./docker/config/http.conf /etc/apache2/sites-enabled/000-default.conf
RUN a2enmod rewrite
COPY ./composer.* .
RUN composer install --no-dev --optimize-autoloader
COPY . .
EXPOSE 80
CMD ["apache2-foreground"]