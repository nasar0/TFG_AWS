<?php 
    // Traemos los datos del config
    require_once(__DIR__ . '/../config.php'); 

    class con {
        private $con;
        
        public function __construct() {
            // Usamos las constantes del config.php
            $this->con = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);

            if ($this->con->connect_error) {
                die("Error de conexión (Docker): " . $this->con->connect_error);
            }

            $this->con->set_charset("utf8");
        }

        public function getCon() { 
            return $this->con; 
        } 
    }
?>