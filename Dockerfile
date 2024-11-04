# Utilise l'image officielle de Wordpress
FROM wordpress:latest

# Ajoute un plugin ou un thème spécifique
COPY ./themes/my-theme /var/www/html/wp-content/themes/my-theme
COPY ./plugins/my-plugin /var/www/html/wp-content/plugins/my-plugin

# Change les permissions si nécessaire
RUN chown -R www-data:www-data /var/www/html/wp-content

# Installe les dépendances PHP supplémentaires si besoin
RUN docker-php-ext-install pdo pdo_mysql

# Expose le port par défaut de Wordpress
EXPOSE 80 443