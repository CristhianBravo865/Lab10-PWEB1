# Lab10-PWEB1
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
