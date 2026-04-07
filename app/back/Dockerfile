FROM php:8.2-apache

# Instalamos extensiones para conectar con la DB
RUN docker-php-ext-install pdo pdo_mysql mysqli

# Habilitamos CORS y Rewrite para que las peticiones de React no reboten
RUN a2enmod rewrite headers

# COPIAMOS EL BACKEND A LA RAÍZ DE APACHE (/var/www/html) 
COPY . /var/www/html/

# Permisos para que PHP pueda escribir sesiones y archivos
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 777 /var/www/html