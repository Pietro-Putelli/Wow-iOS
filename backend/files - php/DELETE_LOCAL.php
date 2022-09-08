<?php

    require_once 'LocalDB.php';

    $id = $_POST['id'];
    
    $delete = new LocalDB();
    $delete->deleteLocal($id);