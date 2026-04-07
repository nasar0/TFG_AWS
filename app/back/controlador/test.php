<?php
$host = 'db'; // Nombre del servicio en tu docker-compose
$user = 'user_tfg';
$pass = 'pass_tfg';
$db   = 'tfg_db';

echo "<h3>Probando conexión a la base de datos...</h3>";

// Intentar conexión
$conn = new mysqli($host, $user, $pass, $db);

// Verificar error
if ($conn->connect_error) {
    die("<b style='color:red'>ERROR de conexión:</b> " . $conn->connect_error . 
        "<br>Verifica que el host sea 'db' y las credenciales coincidan con el docker-compose.");
}

echo "<b style='color:green'>¡OKEY! Conexión exitosa.</b><br>";
echo "Versión del servidor MySQL: " . $conn->server_info;

$conn->close();
?>