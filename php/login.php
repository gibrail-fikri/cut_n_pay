<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);

$sqlquantity = "SELECT * FROM CART WHERE EMAIL = '$email'";

$resultq = $conn->query($sqlquantity);

$sql = "SELECT * FROM USER WHERE EMAIL = '$email' AND PASSWORD = '$password'";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        echo $data = "success,".$row["NAME"].",".$row["EMAIL"].",".$row["PHONE"].",".$row["DATEREG"].",".$quantity;
    }
}else{
    echo "failed";
}