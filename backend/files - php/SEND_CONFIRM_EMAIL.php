<?php

    require_once 'UsersAccountDB.php';

    $email = $_POST['email'];

    $sendEmail = new UsersAccountDB();
    $sendEmail->sendConfirmEmail($email);
    