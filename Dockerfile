FROM php:7.3-apache

# 0. Atualiza o sistema
RUN apt-get update

# 1. Deps necessárias para as extensões do PHP
RUN apt-get install -y \
    git \
    zip \
    curl \
    sudo \
    unzip \
    libzip-dev \
    libicu-dev \
    libbz2-dev \
    libpng-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libreadline-dev \
    libfreetype6-dev \
    libonig-dev \
    g++

# 2. apache configs + document root
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# 3. mod_rewrite pra URL rewrite e mod_headers pros cabeçalhos extra do .htaccess como Access-Control-Allow-Origin-
RUN a2enmod rewrite headers

# 4. Começa com uma config básica do php e então adiciona as extensões
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN docker-php-ext-install \
    bz2 \
    intl \
    iconv \
    bcmath \
    opcache \
    calendar \
    mbstring \
    pdo_mysql \
    zip

# 5. Instala o composer no servidor, o guia original fala pra copiar da imagem do composer, mas tem algum problema com multicamadas no docker que não dá, aí vamos instalar assim mesmo via composer installer
RUN curl -sS http://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 6. Precisamos de um usuário com o mesmo UID/GID do usuário host (usuário dev que está rodando a imagem, no S.O. host)
# pra que quando executarmos os comandos CLI do artisan por exemplo, a propriedade de todos os arquivos permaneça intacta.
# Caso contrário o comando executado dentro do container criaria arquivos e diretórios pertencentes ao root
ARG uid
RUN useradd -G www-data,root -u $uid -d /home/devuser devuser
RUN mkdir -p /home/devuser/.composer && \
    chown -R devuser:devuser /home/devuser
