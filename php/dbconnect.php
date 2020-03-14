<?php
$servername = "localhost";
$username   = "id12922273_cutnpayadmin";
$password   = "1234554321";
$dbname     = "id12922273_chopchop_cutnpay";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 
?> 