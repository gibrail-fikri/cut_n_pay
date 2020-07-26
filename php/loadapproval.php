<?php
error_reporting(0);
include_once ("dbconnect.php");

$sql = "SELECT * FROM SHOPS WHERE `approved` = 0 ORDER BY id";
$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["shops"] = array();
    while ($row = $result->fetch_assoc())
    {
        $shops = array();
        $shops["id"] = $row["id"];
        $shops["name"] = $row["loc_name"];
        $shops["price"] = $row["price"];
        $shops["address"] = $row["address"];
        array_push($response["shops"], $shops);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>
