<?php

    require_once 'LocalDB.php';
    require_once 'EventDB.php';

    class FavouritesDB {
    
        protected $conn;
    
        function __construct() {
    
            $servername = "localhost";
            $username = "tb2w536j_finixDB";
            $password = "c784Vg5MK";
            $dbName = "tb2w536j_showtime";
    
            try {
    
                $this->conn = new PDO("mysql:host=$servername;dbname=$dbName", $username, $password);
                $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
            } catch (PDOException $e) {
                echo "Connection failed: " . $e->getMessage();
            }
        }
    
        function __destruct() {
            $this->conn = NULL;
        }
        
        function addFavLocal($user_id,$local_id) {
            $query = "INSERT INTO `userlocalfavourites` (`user_id`,`local_id`) VALUES ('$user_id','$local_id')";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function removeFavLocal($user_id,$local_id) {
            $query = "DELETE FROM userlocalfavourites WHERE user_id = '$user_id' AND local_id = '$local_id'";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function addFavEvent($user_id,$event_id) {
            $query = "INSERT INTO `usereventfavourites` (`user_id`,`event_id`) VALUES ('$user_id','$event_id')";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function removeFavEvent($user_id,$event_id) {
            $query = "DELETE FROM usereventfavourites WHERE user_id = '$user_id' AND event_id = '$event_id'";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function addGoingEvent($user_id,$event_id) {
            $query = "INSERT INTO `usereventgoing` (`user_id`,`event_id`) VALUES ('$user_id','$event_id')";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function removeGoingEvent($user_id,$event_id) {
            $query = "DELETE FROM usereventgoing WHERE user_id = '$user_id' AND event_id = '$event_id'";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function getFavLocals($user_id) {
            $query = "SELECT local_id FROM userlocalfavourites WHERE user_id = '$user_id'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $locals = array();
                while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                    $local_id = $row['local_id'];
                    
                    $query1 = "SELECT id,rating,owner,likes,json_local FROM locals WHERE id = '$local_id'";
                    $sth1 = $this->conn->prepare($query1);
    
                    if ($sth1->execute()) {
                        $row1 = $sth1->fetch(PDO::FETCH_ASSOC);
                        $local = new Local($row1['id'],$row1['json_local'],$row1["rating"],$row1["owner"],$row1["likes"]);
                        array_push($locals,$local);
                    }
                }
            }
            return $locals;
        }
        
        function checkFav($user_id,$local_id) {
            $query = "SELECT id FROM userlocalfavourites WHERE user_id = '$user_id' AND local_id = '$local_id'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                if ($sth->fetch(PDO::FETCH_ASSOC) != NULL) {
                    return true;
                } else {
                    return false;
                }
            }
        }
        
        function checkEventFav($user_id,$event_id) {
            $query = "SELECT id FROM usereventfavourites WHERE user_id = '$user_id' AND event_id = '$event_id'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                if ($sth->fetch(PDO::FETCH_ASSOC) != NULL) {
                    return true;
                } else {
                    return false;
                }
            }
        }
        
        function checkEventGoing($user_id,$event_id) {
            $query = "SELECT id FROM usereventgoing WHERE user_id = '$user_id' AND event_id = '$event_id'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                if ($sth->fetch(PDO::FETCH_ASSOC) != NULL) {
                    return true;
                } else {
                    return false;
                }
            }
        }
        
        function getUserIDsByLocalID($local_id) {
            $query = "SELECT user_id FROM userlocalfavourites WHERE local_id = '$local_id'";
            $sth = $this->conn->prepare($query);
            $array = array();
            
            if ($sth->execute()) {
                while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                    array_push($array,$row['user_id']);
                }
            }
            return $array;
        }
    }
    
    
    
    
    
    
    
    