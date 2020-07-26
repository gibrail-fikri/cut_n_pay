<?php
error_reporting(0);
include_once ("dbconnect.php");
$id =$_POST['id'];
$imagename=$_POST['imagename'];
$sqlinsert = "DELETE FROM `SHOPS` WHERE id='$id'"; 
if ($conn->query($sqlinsert) === true){
    unlink("../images/$imagename");
    echo "success";
}
else {
    echo "failed";
}   

?>