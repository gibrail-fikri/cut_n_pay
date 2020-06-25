<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_GET['email'];

$sql = "UPDATE USER SET VERIFY=1 WHERE EMAIL='$email'";

if ($conn->query($sql) === true){
    echo "Email is successfully verified!";
}
else {
    echo "failed";
}

?>