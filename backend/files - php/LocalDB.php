<?php

    require_once 'GetAreaDB.php';

class LocalDB {

    protected $conn;

    function __construct() {

      $servername = "localhost";
      $username = "tb2w536j_finixDB";
      $password = "c784Vg5MK";
      $dbName="tb2w536j_showtime";

      try {
      $this->conn = new PDO("mysql:host=$servername;dbname=$dbName", $username, $password);
      $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
      }
      catch(PDOException $e) {
        echo "Connection failed: " . $e->getMessage();
        }
      }

      function __destruct() {
          $this->conn = NULL;
      }


      function createLocal($latitude,$longitude,$owner,$json) {
          
        $query = "INSERT INTO locals (owner,latitude, longitude, json_local,active) VALUES ('$owner','$latitude','$longitude','$json',1)";
        $sth = $this->conn->prepare($query);
        $sth->execute();
        
        $last_id = $this->conn->lastInsertId();
        
        $query = "INSERT INTO localsrating (local_id,number_reviews,sum_reviews,rating) VALUES ('$last_id',0,0,0)";
        $sth = $this->conn->prepare($query);
        $sth->execute();
        
        return $last_id;
      }
      
    function updateLocal($id,$owner,$latitude,$longitude,$json) {
          try {

        $sql = "UPDATE locals SET owner = '$owner', latitude = '$latitude', longitude = '$longitude', json_local = '$json' WHERE id = $id";

        $this->conn->exec($sql);
      }
      catch(PDOException $e) {
        echo $sql . "<br>" . $e->getMessage();
      }
       $this->conn = null;
    }
    
    function setLocalReview($username,$useremail,$local_id,$rating,$date,$jsonData) {

        $query = "INSERT INTO localreviews (user_name,user_email,local_id,rating,date,review_json) VALUES ('$username','$useremail','$local_id','$rating',CAST('$date' as DATE),'$jsonData')";
        $sth = $this->conn->prepare($query);
        $sth->execute();
    }
    
    function getLocalReviews($id) {

        $reviews = array();

        $query = "SELECT id,user_name, user_email, rating, date, review_json FROM localreviews WHERE local_id = '$id' ORDER BY date DESC";
        $sth = $this->conn->prepare($query);

        if ($sth->execute()) {

            while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                $review = new Review($row['id'],$row['user_name'],$row['user_email'],$row['rating'],$row['date'],$row['review_json']);
                array_push($reviews, $review);
            }
        }
        return $reviews;
    }
    
    function getLocalReview($id) {

        $reviews = array();

        $query = "SELECT id,user_name, user_email, rating, review_json FROM localreviews WHERE id = '$id'";
        $sth = $this->conn->prepare($query);

        if ($sth->execute()) {
            $row = $sth->fetch(PDO::FETCH_ASSOC);
            $review = new Review($row['id'],$row['user_name'],$row['user_email'],$row['rating'],$row['review_json']);
        }
        return $review;
    }
    
    function getNumberOfLocalReviews($local_id) {
        $numberOfReviews = 0;
        
        $query = "SELECT local_id FROM localreviews WHERE local_id = '$local_id'";
        $sth = $this->conn->prepare($query);
        
        if ($sth->execute()) {
            while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                $numberOfReviews++;
            }
        }
        return $numberOfReviews;
    }
    
    function checkReviewExistence($email,$local_id) {
        
        $query = "SELECT user_email, local_id FROM localreviews WHERE user_email = '$email' AND local_id = '$local_id'";
        $sth = $this->conn->prepare($query);
        
        if ($sth->execute()) {
            
            $row = $sth->fetch(PDO::FETCH_ASSOC);
            
            if (empty($row)) {
                $response = false;
            } else {
                $response = true;
            }
        }
        
        $query1 = "SELECT latitude FROM locals WHERE owner !='$email' AND id ='$local_id'";
        $sth1 = $this->conn->prepare($query1);
        
        if ($sth1->execute()) {
            
            $row1 = $sth1->fetch(PDO::FETCH_ASSOC);
            
            if (empty($row1)) {
                $response1 = true;
            } else {
                $response1 = false;
            }
        }
        
        return $response XOR $response1;
    }
    
    function deleteReview($email,$localID) {
        
        $query = "DELETE FROM localreviews WHERE user_email = '$email' AND local_id = '$localID'";
        $sth = $this->conn->prepare($query);
        
        if ($sth->execute()) {}
    }
    
    function uploadImage($email,$path,$imageID,$id) {
        
        $target_dir = "../usersAccountData/".$email."/".$path;
        
        if(!file_exists($target_dir)) {
        mkdir($target_dir, 0755, true);
        }
        
        $target_dir = $target_dir . "/" . basename($_FILES["file"]["name"]);
        
        if (move_uploaded_file($_FILES["file"]["tmp_name"], $target_dir)) {
        echo json_encode(["uploaded"=>1]);
        
        } else {
        echo json_encode(["uploaded"=>0]);
        }
        
        $query = "SELECT images FROM locals WHERE id = '$id'";
        $sth = $this->conn->prepare($query);
        
        if ($sth->execute()) {
            $row = $sth->fetch(PDO::FETCH_ASSOC);
            $arraySerialized = $row['images'];
            
            if ($arraySerialized != "") {
    	        $arrayUnserialized = unserialize($arraySerialized);
    	    } else {
    	        $arrayUnserialized = array();
    	    }
    	    array_push($arrayUnserialized,$imageID);
    	    $arraySerialized = serialize($arrayUnserialized);
        }
        
        $query = "UPDATE locals SET images = '$arraySerialized' WHERE id = '$id'";
        $sth = $this->conn->prepare($query);
        $sth->execute();
    }
    
    function getImageIDs($id) {
        $query = "SELECT images FROM locals WHERE id = '$id'";
        $sth = $this->conn->prepare($query);
        
        if ($sth->execute()) {
            $row = $sth->fetch(PDO::FETCH_ASSOC);
            return $row['images'];
        }
    }
    
    function deleteImage($email,$id,$index) {
        $query = "SELECT images FROM locals WHERE id = '$id'";
        $sth = $this->conn->prepare($query);
        $images = array();
        $imgID = "";
        
        if ($sth->execute()) {
            $row = $sth->fetch(PDO::FETCH_ASSOC);
            $images = unserialize($row['images']);
            $imgID = $images[$index];
            
            file_put_contents('../imageName.txt',$imgID, FILE_APPEND);
            
            unset($images[$index]);
            $images = serialize($images);
        }
        $query = "UPDATE locals SET images = '$images' WHERE id = '$id'";
        $sth = $this->conn->prepare($query);
        $sth->execute();
        
        $target_dir = "../usersAccountData/".$email."/userLocals/".$email.$id."/".$imgID.".jpg";
        unlink($target_dir);
    }
    
    function getLocalEvents($id) {
        $query = "SELECT id, owner, going, likes, local_id, json_event FROM events WHERE local_id = '$id'";
        $sth = $this->conn->prepare($query);
        
         if ($sth->execute()) {
            $events = array();
            
            while($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                $event = new Event($row['id'],$row['going'],$row['likes'],$row['local_id'],$row['owner'],$row['json_event']);
                array_push($events,$event);
            }
            return $events;
        }
    }
    
    function getLocalByID($local_id) {
        $query = "SELECT id,json_local,rating,owner,likes FROM locals WHERE id = '$local_id'";
        $sth = $this->conn->prepare($query);
        
        if ($sth->execute()) {
            $row = $sth->fetch(PDO::FETCH_ASSOC);
            $local = new Local($row['id'],$row['json_local'],$row['rating'], $row['owner'],$row['likes']);
            return $local;
        }
    }
    
    function addLike($id) {
    
        $query = "UPDATE locals SET likes = (likes + 1) WHERE id = '$id'";
        $sth = $this->conn->prepare($query);
        $sth->execute();
    }
    
    function removeLike($id) {
        $query = "UPDATE locals SET likes = (likes - 1) WHERE id = '$id'";
        $sth = $this->conn->prepare($query);
        $sth->execute();
    }
    
    function deleteLocal($id) {
        $query = "DELETE FROM locals WHERE id ='$id'";
        $sth = $this->conn->prepare($query);
        $sth->execute();
        
        $query = "DELETE FROM localsrating WHERE local_id = '$id'";
        $sth = $this->conn->prepare($query);
        $sth->execute();
        
        $path = '../usersAccountData/' . $owner . '/userLocals/' . $owner . $id;
        if (!file_exists($path)) {
            rmdir($path, 0755, true);
        }
    }
    
    function getLocalRating($id) {
        
        $query = "SELECT rating FROM localreviews WHERE local_id ='$id'";
        $sth = $this->conn->prepare($query);
        
        $sumOfRatings = 0;
        $numberOfRatings = 0;

        if ($sth->execute()) {
            while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                
                $sumOfRatings += $row['rating'];
                $numberOfRatings++;
            }
        }
        if ($sumOfRatings != 0) {
            return $sumOfRatings / $numberOfRatings;
        } else {
            return 0;
        }
    }
    
    function getLikes($local_id) {
        $query = "SELECT likes FROM locals WHERE id = '$local_id'";
        $sth = $this->conn->prepare($query);
        
        if ($sth->execute()) {
            $row = $sth->fetch(PDO::FETCH_ASSOC);
            return $row['likes'];
        }
    }
}

    class Review {

        protected $id;
        protected $username;
        protected $useremail;
        protected $rating;
        protected $date1;
        protected $reviewJSON;

        function __construct($id,$username,$useremail,$rating,$date1,$reviewJSON) {
            $this->id = $id;
            $this->username = $username;
            $this->useremail = $useremail;
            $this->rating = $rating;
            $this->date1 = $date1;
            $this->reviewJSON = $reviewJSON;
        }
        
        function getID() {
            return $this->id;
        }

        function getUsername() {
            return $this->username;
        }

        function getUseremail() {
            return $this->useremail;
        }
        
        function getUserRating() {
            return $this->rating;
        }
        
        function getDate() {
            return $this->date1;
        }

        function getReviewJSON() {
            return $this->reviewJSON;
        }
    }


