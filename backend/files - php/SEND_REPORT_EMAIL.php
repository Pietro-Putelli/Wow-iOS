<?php

    // LOCAL: 0, EVENT: 1, REVIEW: 2, DISCUSSION: 3, REPLY: 4, PROFILE: 5
    
    $id = $_POST['id'];
    $type = $_POST['type'];
        
    $to  = "finixreport@gmail.com";
    $subject = $type ."-". $id;
    $message = $type ."-". $id;
    
    $headers  = 'MIME-Version: 1.0' . "\r\n";
    $headers .= 'Content-type: text/html; charset=UTF-8' . "\r\n";
    $headers .= 'From: Finix <finix@finixinc.com>' . "\r\n";
    
    mail($to, $subject, $message, $headers);