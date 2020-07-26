<?php

sendEmail('gibrailfikri@gmail.com');
function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for CutNPay'; 
    $message = 'http://cutnpay.000webhostapp.com/cutnpay/php/verify.php?email='.$useremail; 
    $headers = 'From: noreply@cutnpay.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}
?>