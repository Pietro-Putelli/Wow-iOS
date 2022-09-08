<?

    require_once 'RatingDB.php';
    
    $local_id = $_POST['local_id'];
    $rating = $_POST['rating'];
    
    $setter = new RatingDB();
    $setter->removeRating($local_id,$rating);