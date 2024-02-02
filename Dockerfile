FROM php:apache-bullseye
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN apt update && apt install git unzip -y
COPY ./docker/config/http.conf /etc/apache2/sites-available/symfony.conf
RUN a2dissite 000-default.conf && a2ensite symfony.conf && a2enmod rewrite && service apache2 restart
COPY --chown=www-data:www-data ./composer.* .
RUN composer install --no-dev --no-scripts --no-interaction --prefer-dist --optimize-autoloader
COPY --chown=www-data:www-data . .
WORKDIR /var/www/symfony
RUN chown -R www-data:www-data /var/www/symfony
EXPOSE 80
CMD ["apache2-foreground"]