<?php
error_reporting(0);
include_once ("dbconnect.php");
$target_dir = "../images/";
$id = $_POST['id'];
$locname =$_POST['locname'];
$price =$_POST['price'];
$type =$_POST['type'];
$contact =$_POST['contact'];
$address =$_POST['address'];
$lat =$_POST['lat'];
$lon =$_POST['lon'];
$filename = $_POST['filename'];
$owneremail = $_POST['owneremail'];
$image = $_POST['image'];
$approved = $_POST['approved'];
$realImage = base64_decode($image);


$sqlinsert = "INSERT INTO `SHOPS`(`id`, `loc_name`, `price`, `type`, `contact`, `address`, `lat`, `lon`, `imagename`, `owneremail`, `approved`) VALUES ('$id','$locname',$price,'$type','$contact','$address',$lat,$lon,'$filename','$owneremail','$approved')"; 

if ($conn->query($sqlinsert) === true){
    file_put_contents("../images/$filename", $realImage);
    echo "success";
}
else {
    echo "failed";
}   

?>