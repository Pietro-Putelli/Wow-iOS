<?php

    require_once 'LocalDB.php';

    $latitude = $_POST['latitude'];
    $longitude = $_POST['longitude'];
    $owner = $_POST['owner'];
    $json = $_POST['json'];
    $id = $_POST['id'];
    
    $edit = new LocalDB();
    $edit->updateLocal($id,$owner,$latitude,$longitude,$json);
    