#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;

# Configuración de conexión
my $database = "prueba";
my $hostname = "mariadb2";              
my $port     = 3306;            #3306 o 3307???   
my $username = "cgi_user";        # Nombre de usuario actualizado
my $password = "tu_password";     # Contraseña actualizada

# DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $username, $password, {
    RaiseError       => 1,
    PrintError       => 0,
    mysql_enable_utf8 => 1,
});

# Validar conexión
if ($dbh) {
    print "Content-type: text/plain\n\n";
    print "Conexión exitosa a la base de datos '$database'.\n";
} else {
    die "Content-type: text/plain\n\nError al conectar a la base de datos: $DBI::errstr\n";
}

# Consulta de prueba
my $query = "SELECT * FROM peliculas";
my $sth = $dbh->prepare($query);
$sth->execute();

# Imprimir resultados de la consulta
print "Resultados de la tabla 'peliculas':\n";
while (my @row = $sth->fetchrow_array) {
    print join(", ", @row), "\n";
}

# Insertar un registro en la tabla 'actores'
$sth = $dbh->prepare("INSERT INTO actores (nombre) VALUES (?)");
$sth->execute("Johnny Depp");

# Cerrar la conexión
$sth->finish();
$dbh->disconnect();
