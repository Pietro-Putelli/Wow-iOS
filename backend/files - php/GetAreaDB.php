<?php

    class GetAreaDB {

    protected $conn;

	static $latitudeFrom;
	static $longitudeFrom;
	static $maxDistance;

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

        function __destruct() {$this->conn = NULL;}

        function getLocalArea($latitudeFrom,$longitudeFrom,$maxDistance,$const) {

            $query = "SELECT id,json_local,rating, owner, likes,active, ('$const' * acos (cos (radians($latitudeFrom))* cos(radians(latitude))* cos( radians($longitudeFrom) - radians(longitude) )+ sin (radians($latitudeFrom))* sin(radians(latitude)))) AS distance FROM locals HAVING distance <= $maxDistance ORDER BY distance ASC";

            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
            
            $locals = array();
            
            while($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                if ($row['active']) {
                    $local = new Local($row['id'],$row['json_local'],$row['rating'], $row['owner'],$row['likes']);
                    array_push($locals,$local);
                }
            }
            
            return $locals;
                
            
            } else {echo "ERROR";}

            return NULL;
        }
	
	    function getEventArea($latitudeFrom,$longitudeFrom,$maxDistance,$const) {

        $query = "SELECT id, going, likes, local_id, owner, json_event, active, ('$const' * acos (cos (radians($latitudeFrom))* cos(radians(latitude))* cos( radians($longitudeFrom) - radians(longitude) )+ sin (radians($latitudeFrom))* sin(radians(latitude)))) AS distance FROM events HAVING distance <= $maxDistance ORDER BY distance ASC";
    
        $sth = $this->conn->prepare($query);
    
        if ($sth->execute()) {
    
            $events = array();

            while($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                if ($row['active']) {
                    $event = new Event($row['id'],$row['going'],$row['likes'],$row['local_id'],$row['owner'],$row['json_event']);
                    array_push($events,$event);
                }
            }
    
            return $events;
    
    
        } else {echo "ERROR";}
    
        return NULL;
    }
    
    function getTopLocalArea($latitudeFrom,$longitudeFrom,$const) {
                
            $query = "SELECT id,json_local,rating, owner, likes, active, ('$const' * acos (cos (radians($latitudeFrom))* cos(radians(latitude))* cos( radians($longitudeFrom) - radians(longitude) )+ sin (radians($latitudeFrom))* sin(radians(latitude)))) AS distance FROM locals HAVING distance <= 200 ORDER BY rating DESC LIMIT 10";

            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
            
            $locals = array();
            
            while($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                if ($row['active']) {
                    $local = new Local($row['id'],$row['json_local'],$row['rating'],$row['owner'],$row['likes']);
                    array_push($locals,$local);
                }
            }
            
            return $locals;
                
            
            } else {echo "ERROR";}

            return NULL;
    }
    
    function getTopEventArea($latitudeFrom,$longitudeFrom,$const) {
        
        $query = "SELECT id,going,likes,local_id,owner,json_event, active, ('$const' * acos (cos (radians($latitudeFrom))* cos(radians(latitude))* cos( radians($longitudeFrom) - radians(longitude) )+ sin (radians($latitudeFrom))* sin(radians(latitude)))) AS distance FROM events HAVING distance <= 200 ORDER BY going ASC LIMIT 10";
    
        $sth = $this->conn->prepare($query);
    
        if ($sth->execute()) {
    
            $events = array();

            while($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                if ($row['active']) {
                    $event = new Event($row['id'],$row['going'],$row['likes'],$row['local_id'],$row['owner'],$row['json_event']);
                    array_push($events,$event);
                } 
            }
    
            return $events;
    
    
        } else {echo "ERROR";}
    
        return NULL;
    }
    
    function getLocalsByEmail($email) {
        
        $query = "SELECT id,json_local,rating, owner, likes FROM locals WHERE owner = '$email'";
    
        $sth = $this->conn->prepare($query);
    
        if ($sth->execute()) {
    
            $locals = array();

            while($row = $sth->fetch(PDO::FETCH_ASSOC)) {
    
                $local = new Local($row['id'],$row['json_local'],$row['rating'],$row['owner'],$row['likes']);
                array_push($locals,$local);
            }
    
            return $locals;
    
    
        } else {echo "ERROR";}
    
        return NULL;
    }
    
    function getLocalByID($id) {
        
        $query = "SELECT json_local,rating,owner, likes FROM locals WHERE id = '$id'";
        $sth = $this->conn->prepare($query);
    
        if ($sth->execute()) {

            $row = $sth->fetch(PDO::FETCH_ASSOC);
            $local = new Local($id,$row['json_local'],$row['rating'],$row['owner'],$row['likes']);
            return $local;
    
        } else {echo "ERROR";}
    }
    
    function getEvents($owner) {
        
        $query = "SELECT id, owner, local_id, going, likes, json_event FROM events WHERE owner = '$owner'";
              
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
}
    
   class Local {

        protected $id;
        protected $json_local;
        protected $rating;
        protected $owner;
        protected $likes;

         function __construct($id,$json_local,$rating,$owner,$likes) {
            
            $this->id = $id;
            $this->json_local = $json_local;
            $this->rating = $rating;
            $this->owner = $owner;
            $this->likes = $likes;
        }
        
        function getID() {
            return $this->id;
        } 
        
        function getJSON() {
            return $this->json_local;
        }
        
        function getRating() {
            return $this->rating;
        }
        
        function getOwner() {
            return $this->owner;
        }
        
        function getLikes() {
            return $this->likes;
        }
    }
    
    class Event {

        protected $id;
        protected $going;
        protected $likes;
        protected $local_id;
        protected $owner;
        protected $json_event;

        function __construct($id,$going,$likes,$local_id,$owner,$json_event) {
            $this->id = $id;
            $this->going = $going;
            $this->likes = $likes;
            $this->local_id = $local_id;
            $this->owner = $owner;
            $this->json_event = $json_event;
        }

        function getID() { 
            return $this->id; 
        }
        
        function getGoing() { 
            return $this->going; 
        }
        
        function getLikes() { 
            return $this->likes; 
        }
        
        function getLocalID() { 
            return $this->local_id; 
        }
        
        function getOwner() {
            return $this->owner;
        }
        
        function getJSON() { 
            return $this->json_event; 
        }
    }


