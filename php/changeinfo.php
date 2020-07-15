<?php
error_reporting(0);
include_once ("dbconnect.php");
$email =$_POST['email'];
$name = $_POST['name'];
$phone = $_POST['phone'];

$sqlinsert = "UPDATE USER SET NAME='$name', PHONE='$phone' WHERE EMAIL='$email'"; 
if ($conn->query($sqlinsert) === true){
    echo "success";
}
else {
    echo "failed";
}   

?>