# Use the official PHP 8.3 image as a base
FROM php:8.3-apache

# Install necessary extensions
RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip git curl libzip-dev libjpeg-dev libpng-dev \
    libfreetype6-dev libicu-dev libxml2-dev libmariadb-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install mysqli zip gd intl soap exif pdo_mysql opcache && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

# Clone Moodle (only required branch, shallow clone)
RUN git clone --depth 1 --branch MOODLE_405_STABLE git://git.moodle.org/moodle.git /var/www/html

# Set PHP settings for Moodle
RUN echo "max_input_vars=5000" >> /usr/local/etc/php/conf.d/docker-php-moodle.ini && \
    echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/docker-php-opcache.ini && \
    echo "opcache.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-opcache.ini && \
    echo "opcache.memory_consumption=128" >> /usr/local/etc/php/conf.d/docker-php-opcache.ini && \
    echo "opcache.interned_strings_buffer=8" >> /usr/local/etc/php/conf.d/docker-php-opcache.ini && \
    echo "opcache.max_accelerated_files=10000" >> /usr/local/etc/php/conf.d/docker-php-opcache.ini && \
    echo "opcache.revalidate_freq=60" >> /usr/local/etc/php/conf.d/docker-php-opcache.ini && \
    echo "opcache.validate_timestamps=1" >> /usr/local/etc/php/conf.d/docker-php-opcache.ini && \
    echo "upload_max_filesize=64M" >> /usr/local/etc/php/conf.d/docker-php-moodle.ini && \
    echo "post_max_size=64M" >> /usr/local/etc/php/conf.d/docker-php-moodle.ini 

# Create moodledata directory
RUN mkdir -p /var/www/moodledata && \
    chown -R www-data:www-data /var/www/moodledata && \
    chmod -R 777 /var/www/moodledata

# Set working directory
WORKDIR /var/www/html

# Expose port 80
EXPOSE 80
