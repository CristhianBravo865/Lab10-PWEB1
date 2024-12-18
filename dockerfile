# Usa una imagen base de Debian para instalar Apache, Perl y MariaDB
FROM debian:latest

# Instala Apache, Perl, MariaDB y módulos necesarios
RUN apt-get update && \
    apt-get install -y apache2 libapache2-mod-perl2 perl mariadb-server \
    libdbi-perl libdbd-mysql-perl && \
    apt-get clean

# Habilita el módulo CGI de Apache
RUN a2enmod cgi

# Crea el directorio CGI y da permisos
RUN mkdir -p /usr/lib/cgi-bin
RUN chmod +x /usr/lib/cgi-bin

# Copia el script Perl en el directorio CGI
COPY basedatos.pl /usr/lib/cgi-bin/basedatos.pl
RUN chmod +x /usr/lib/cgi-bin/basedatos.pl

# Copia el archivo de configuración de Apache
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Elimina la inicialización manual de la base de datos, ya que MariaDB maneja esto automáticamente
RUN mysqld_safe --skip-networking & \
    sleep 5 && \
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS prueba;" && \
    mysql -u root -e "CREATE USER 'cgi_user'@'localhost' IDENTIFIED BY 'tu_password';" && \
    mysql -u root -e "GRANT ALL PRIVILEGES ON prueba.* TO 'cgi_user'@'localhost';" && \
    mysql -u root -e "FLUSH PRIVILEGES;" && \
    mysql -u root -e "USE prueba; \
        CREATE TABLE actores (actor_id INT PRIMARY KEY AUTO_INCREMENT, nombre VARCHAR(100)); \
        CREATE TABLE peliculas (pelicula_id INT PRIMARY KEY AUTO_INCREMENT, nombre VARCHAR(100), year INT, vote INT, score DECIMAL(3,1)); \
        CREATE TABLE casting (casting_id INT PRIMARY KEY AUTO_INCREMENT, pelicula_id INT, actor_id INT, papel VARCHAR(100), \
            FOREIGN KEY (pelicula_id) REFERENCES peliculas(pelicula_id) ON DELETE CASCADE, \
            FOREIGN KEY (actor_id) REFERENCES actores(actor_id) ON DELETE CASCADE);" && \
    mysql -u root -e "USE prueba; \
        INSERT INTO actores (nombre) VALUES ('Robert Downey Jr.'), ('Scarlett Johansson'), ('Chris Hemsworth'); \
        INSERT INTO peliculas (nombre, year, vote, score) VALUES ('Avengers: Endgame', 2019, 8500, 8.4), ('Iron Man', 2008, 4000, 7.9), ('Thor', 2011, 3200, 7.0); \
        INSERT INTO casting (pelicula_id, actor_id, papel) VALUES (1, 1, 'Iron Man'), (1, 2, 'Black Widow'), (1, 3, 'Thor'), (2, 1, 'Iron Man'), (3, 3, 'Thor');"

# Exponer el puerto 80
EXPOSE 80

# Comando para iniciar Apache y MariaDB
CMD mysqld_safe --skip-networking & apache2ctl -D FOREGROUND
