#!/usr/bin/perl -w 
use strict;
use warnings;
use DBI;
use CGI;

# Crear el objeto CGI
my $cgi = CGI->new;

# Obtener el año del formulario
my $year = $cgi->param('year') || '';

# Configuración de conexión a la base de datos
my $database = "prueba";
my $hostname = "mariadb2";
my $port     = 3306;
my $username = "Cristhian";  
my $password = "pweb1";   

# DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $username, $password, {
    RaiseError       => 1,
    PrintError       => 0,
    mysql_enable_utf8 => 1,
});

# Validar conexión
if (!$dbh) {
    print $cgi->header(-type => "text/html", -charset => "UTF-8");
    print "<h1>Error al conectar a la base de datos: $DBI::errstr</h1>";
    exit;
}


my $sql = q{
    SELECT p.nombre AS pelicula, p.year AS anio, p.vote AS votos, p.score AS puntuacion
    FROM peliculas p
    WHERE p.year = ?
    ORDER BY p.nombre
};

# Preparar y ejecutar la consulta
my $sth = $dbh->prepare($sql);
$sth->execute($year);

# CREAMOS UNA VARIABLE PARA ALMACENAR EL HTML DE LOS RESULTADOS
my $output = "";

# ITERAMOS SOBRE LOS RESULTADOS OBTENIDOS DE LA BASE DE DATOS
while (my $row = $sth->fetchrow_hashref) {
    $output .= "<tr>";
    $output .= "<td>$row->{pelicula}</td>";
    $output .= "<td>$row->{anio}</td>";  
    $output .= "<td>$row->{votos}</td>";
    $output .= "<td>$row->{puntuacion}</td>";
    $output .= "</tr>\n";
}

# IMPRIMIMOS EL HTML DE LA TABLA SIN EL ESTILO NI LOS ENCABEZADOS EXTRA
print $cgi->header(-type => "text/html", -charset => "UTF-8");
print "<table><tr><th>Película</th><th>Año</th><th>Votos</th><th>Puntuación</th></tr>$output</table>";

# Cerrar la conexión
$sth->finish();
$dbh->disconnect();
