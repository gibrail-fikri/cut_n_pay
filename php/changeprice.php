<?php
error_reporting(0);
include_once ("dbconnect.php");
$id =$_POST['id'];
$newprice = $_POST['newprice'];

$sqlinsert = "UPDATE SHOPS SET price='$newprice'WHERE id='$id'"; 
if ($conn->query($sqlinsert) === true){
    echo "success";
}
else {
    echo "failed";
}   

?>