<?php
$servername = "remotemysql.com";
$username   = "kl8taSpuVu";
$password   = "xAean72eto";
$dbname     = "kl8taSpuVu";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
else{
}
?> 