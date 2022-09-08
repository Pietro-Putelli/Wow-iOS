<?php

    require_once 'EventDB.php';

    $latitude = $_POST['latitude'];
    $longitude = $_POST['longitude'];
    $owner = $_POST['owner'];
    $json = $_POST['json'];
    $local_id = $_POST['local_id'];
    $id = $_POST['id'];
    $to_date = $_POST['to_date'];

    $edit = new EventDB();
    $edit->updateEvent($id,$owner,$latitude,$longitude,$local_id,$to_date,$json);