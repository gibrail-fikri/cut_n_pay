<?php
error_reporting(0);
include_once ("dbconnect.php");
$id =$_POST['id'];

$sqlinsert = "UPDATE SHOPS SET approved = '1' WHERE id='$id'"; 
if ($conn->query($sqlinsert) === true){
    echo "success";
}
else {
    echo "failed";
}   

?>