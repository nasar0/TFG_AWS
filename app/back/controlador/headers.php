<?php
error_reporting(0); // No mostrar errores visuales
ini_set('display_errors', 0); // No imprimir errores en el output
// Detectamos quién llama (React)
$origin = $_SERVER['HTTP_ORIGIN'] ?? '';

// OJO: Pon aquí la IP de tu AWS o tu localhost de desarrollo
$allowed_origins = [
    'http://15.236.154.129',
    'http://localhost:5173'
];

if (in_array($origin, $allowed_origins)) {
    header("Access-Control-Allow-Origin: " . $origin);
}

// ESTO ES LO QUE LE FALTA A REACT
header("Access-Control-Allow-Credentials: true"); 
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit;
}

ini_set('session.use_only_cookies', '1');
ini_set('session.use_strict_mode', '1');
ini_set('session.cookie_samesite', 'Lax');
ini_set('session.cookie_secure', '0'); // Importante: 0 para HTTP

// CONFIGURACIÓN DE SESIÓN REFORZADA
ini_set('session.use_only_cookies', 1);
ini_set('session.use_strict_mode', 1);

// Estas 4 líneas son el "pegamento" para que Chrome no borre la cookie
session_set_cookie_params([
    'lifetime' => 0,            // Hasta que se cierre el navegador
    'path' => '/',              // Disponible en toda la web
    'domain' => '',            // Vacío para que detecte la IP de AWS automáticamente
    'secure' => false,          // false porque no tienes HTTPS (SSL)
    'httponly' => true,         // Seguridad
    'samesite' => 'Lax'         // Permite el envío entre localhost e IP
]);


session_start();