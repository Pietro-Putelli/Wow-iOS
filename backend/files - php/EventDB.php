<?php
    
    require_once 'GetAreaDB.php';
    
    class EventDB {
        
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
        
        
        function createEvent($local_id,$setupby,$latitude,$longitude,$to_date,$json) {
              
              $query = "INSERT INTO events (local_id,owner, latitude, longitude, to_date, json_event,active) VALUES ('$local_id','$setupby','$latitude','$longitude',CAST('$to_date' as DATE),'$json',1)";
              $sth = $this->conn->prepare($query);
              $sth->execute();
              
              $last_id = $this->conn->lastInsertId();
              return $last_id;
          }
          
        function updateEvent($id,$owner,$latitude,$longitude,$localID,$to_date,$json) {
              try {
    
            $sql = "UPDATE events SET owner = '$owner', latitude = '$latitude', longitude = '$longitude',local_id = '$localID', json_event = '$json', to_date = CAST('$to_date' as DATE) WHERE id = $id";
    
            $this->conn->exec($sql);
          }
          catch(PDOException $e) {
            echo $sql . "<br>" . $e->getMessage();
          }
           $this->conn = null;
        }
        
        function getEventByID($event_id) {
            $query = "SELECT id, going, likes, local_id, owner, json_event FROM events WHERE id = '$event_id'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {

                $row = $sth->fetch(PDO::FETCH_ASSOC);
                $event = new Event($row['id'],$row['going'],$row['likes'],$row['local_id'],$row['owner'],$row['json_event']);
            }
            return $event;
        }
        
        function deleteEvent($id) {
            $query = "DELETE FROM events WHERE id ='$id'";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function addLike($id) {
        
            $query = "UPDATE events SET likes = (likes + 1) WHERE id = '$id'";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function removeLike($id) {
            $query = "UPDATE events SET likes = (likes - 1) WHERE id = '$id'";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function addGoing($id) {
        
            $query = "UPDATE events SET going = (going + 1) WHERE id = '$id'";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function removeGoing($id) {
            $query = "UPDATE events SET going = (going - 1) WHERE id = '$id'";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function setEventDiscussion($user_name,$user_email,$event_id,$date,$discussion_json) {
            $query = "INSERT INTO eventdiscussions (user_name,user_email,event_id,date,discussion_json) VALUES ('$user_name','$user_email','$event_id',CAST('$date' AS DATE),'$discussion_json')";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function setEventDiscussionAnswer($user_name,$user_email,$discussion_id,$date,$answer_json) {
            $query = "INSERT INTO eventanswers (user_name, user_email, discussion_id, date, answer_json) VALUES ('$user_name','$user_email','$discussion_id',CAST('$date' AS DATE),'$answer_json')";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function getEventDiscussion($event_id) {
            $query = "SELECT id,user_name,user_email,date,discussion_json FROM eventdiscussions WHERE event_id = '$event_id' ORDER BY date DESC";
            $sth = $this->conn->prepare($query);
            $discussions = array();
            
            if ($sth->execute()) {
                while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                    $discussion = new Discussion($row['id'],$row['user_name'],$row['user_email'],$row['date'],$row['discussion_json']);
                    array_push($discussions,$discussion);
                }
            }
            return $discussions;
        }
        
        function getEventDiscussionByID($discussion_id) {
            $query = "SELECT event_id,user_name,user_email,date,discussion_json FROM eventdiscussions WHERE id = '$discussion_id'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                $discussion = new Discussion($row['id'],$row['user_name'],$row['user_email'],$row['date'],$row['discussion_json']);
            }
            return $discussion;
        }
        
        function getLikesGoing($event_id) {
            $query = "SELECT going, likes FROM events WHERE id = '$event_id'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                $array = array(
                    "going" => $row['going'],
                    "likes" => $row['likes']
                    );
            }
            return $array;
        }
        
        function checkDiscussionExistence($user_email,$event_id) {
            
            $query = "SELECT user_email, event_id FROM eventdiscussions WHERE user_email = '$user_email' AND event_id = '$event_id'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                            
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                
                if (empty($row)) {
                    $response = false;
                } else {
                    $response = true;
                }   
            }
            
            $query1 = "SELECT latitude FROM events WHERE owner != '$user_email' AND id = '$event_id'";
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
        
        function deleteDiscussion($discussion_id) {
            $query = "DELETE FROM eventdiscussions WHERE id = '$discussion_id'";
            $sth = $this->conn->prepare($query);
            $sth->execute();
            
            $query = "DELETE FROM eventanswers WHERE discussion_id = '$discussion_id'";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function setDiscussionAnswer($discussion_id,$user_name,$user_email,$event_id,$reply_json) {
            $query = "INSERT INTO eventanswers (discussion_id, user_name, user_email, answer_json) VALUES ('$discussion_id','$user_name','$user_email','$reply_json')";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function deleteDiscussionAnswer($user_email,$discussion_id,$answer_id) {
            $query = "DELETE FROM eventanswers WHERE discussion_id = '$discussion_id' AND user_email = '$user_email' AND id = '$answer_id'";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function getDiscussionAnswers($discussion_id) {
            $query = "SELECT id, user_name,user_email,date,answer_json FROM eventanswers WHERE discussion_id = '$discussion_id' ORDER BY date DESC";
            $sth = $this->conn->prepare($query);
            $answers = array();
            
            if ($sth->execute()) {
                while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                    $answer = new Discussion($row['id'],$row['user_name'],$row['user_email'],$row['date'],$row['answer_json']);
                    array_push($answers,$answer);
                }
            }
            return $answers;
        }
        
        function getDiscussionAnswer($answer_id) {
            $query = "SELECT id, user_name,user_email,date,answer_json FROM eventanswers WHERE id = '$answer_id'";
            $sth = $this->conn->prepare($query);
            $answers = array();
            
            if ($sth->execute()) {
                while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                    $answer = new Discussion($row['id'],$row['user_name'],$row['user_email'],$row['date'],$row['answer_json']);
                    return $answer;
                }
            }
            return $answers;
        }
    }
    
    class Discussion {
        
        protected $id;
        protected $user_name;
        protected $user_email;
        protected $date1;
        protected $discussion_json;
        
        function __construct($id,$user_name,$user_email,$date1,$discussion_json) {
            $this->id = $id;
            $this->user_name = $user_name;
            $this->user_email = $user_email;
            $this->date1 = $date1;
            $this->discussion_json = $discussion_json;
        }
        
        function getDiscussionID() {
            return $this->id;
        }
        
        function getUsername() {
            return $this->user_name;
        }
        
        function getUseremail() {
            return $this->user_email;
        }
        
        function getDate() {
            return $this->date1;
        }
        
        function getDiscussionJSON() {
            return $this->discussion_json;
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ?>
