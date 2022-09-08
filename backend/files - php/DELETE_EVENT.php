<?php

    require_once 'EventDB.php';

    $id = $_POST['id'];
    
    $delete = new EventDB();
    $delete->deleteEvent($id);