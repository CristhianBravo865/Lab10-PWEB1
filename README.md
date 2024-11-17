# Lab10-PWEB1 - Comandos para montar el contenedor mariadb2
docker build -t servidor-web-perl-mariadb .      
docker run -d -p 8112:80 --name servidor-web servidor-web-perl-mariadb
docker run -d --name mariadb2 -e MARIADB_ROOT_PASSWORD=tu_contraseña_segura -p 3307:3306 mariadb:latest //PowerShell

#Crear Red Para que se comuniquen ambos contenedores
PS C:\Users\gatog\Desktop\Lab-10-PWEB01> docker network connect mi_red servidor-web
PS C:\Users\gatog\Desktop\Lab-10-PWEB01> docker network connect mi_red mariadb2
PS C:\Users\gatog\Desktop\Lab-10-PWEB01> docker exec -it servidor-web /bin/bash


#COMANDOS USADOS PARA maria db2
docker run -d --name mariadb2 -e MARIADB_ROOT_PASSWORD=tu_contraseña_segura -p 3307:3306 mariadb:latest
docker exec -it mariadb2

#INSTALL MYSQL
which mysql
root@295ca20d8a5e:/# apt-get update
apt-get install mysql-client

#YA DENTRO
mysql> CREATE USER 'cgi_user'@'localhost' IDENTIFIED BY 'tu_password';
Query OK, 0 rows affected (0.02 sec)

mysql> GRANT ALL PRIVILEGES ON prueba.* TO 'cgi_user'@'localhost';
Query OK, 0 rows affected (0.01 sec)

mysql> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.01 sec)

mysql> GRANT ALL PRIVILEGES ON prueba.* TO 'cgi_user'@'%' IDENTIFIED BY 'tu_password';
Query OK, 0 rows affected (0.01 sec)

mysql> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.00 sec)

-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS prueba;
USE prueba;

-- Crear tabla 'actores'
CREATE TABLE IF NOT EXISTS actores (
    actor_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL
);

-- Crear tabla 'peliculas'
CREATE TABLE IF NOT EXISTS peliculas (
    pelicula_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    year INT,
    vote INT,
    score DECIMAL(3, 1)
);

-- Crear tabla 'casting' para relacionar 'actores' y 'peliculas'
CREATE TABLE IF NOT EXISTS casting (
    casting_id INT PRIMARY KEY AUTO_INCREMENT,
    pelicula_id INT,
    actor_id INT,
    papel VARCHAR(100),
    FOREIGN KEY (pelicula_id) REFERENCES peliculas(pelicula_id) ON DELETE CASCADE,
    FOREIGN KEY (actor_id) REFERENCES actores(actor_id) ON DELETE CASCADE
);

-- Insertar datos de ejemplo en 'actores'
INSERT INTO actores (nombre) VALUES 
('Robert Downey Jr.'),
('Scarlett Johansson'),
('Chris Hemsworth');

-- Insertar datos de ejemplo en 'peliculas'
INSERT INTO peliculas (nombre, año, vote, score) VALUES 
('Avengers: Endgame', 2019, 8500, 8.4),
('Iron Man', 2008, 8000, 7.9),
('Thor', 2011, 3200, 7.0);

-- Insertar datos de ejemplo en 'casting'
INSERT INTO casting (pelicula_id, actor_id, papel) VALUES 
(1, 1, 'Iron Man'),
(1, 2, 'Black Widow'),
(1, 3, 'Thor'),
(2, 1, 'Iron Man'),
(3, 3, 'Thor');

-- Consultar los datos para verificar
SELECT * FROM actores;
SELECT * FROM peliculas;
SELECT * FROM casting

