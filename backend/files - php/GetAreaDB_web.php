<?php
  class Local {

        protected $id;
        protected $json_local;
        protected $lat;
        protected $lng;



         function __construct($id,$json_local,$lat,$lng) {
            
            $this->id = $id;
            $this->json_local = $json_local;
            $this->lat = $lat;
            $this->lng = $lng;
        }
    
         
        function __destruct() {
        $this->conn = NULL;
        }
        
         function getID() {
            return $this->id;
        } 
        
        function getJSON() {
            return $this->json_local;
        }
        
        function getLat() {
            return $this->lat;
        }
        function getLng() {
            return $this->lng;
        }
    }
    class Event {

        protected $id;
        protected $json_event;

        function __construct($id,$json_event) {
            $this->id = $id;
            $this->json_event = $json_event;
        }

        function getID() { return $this->id; }
        function getJSON() { return $this->json_event; }
    }

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

         function getlocalArea($latitudeFrom,$longitudeFrom,$maxDistance) {

            $query = "SELECT id,latitude,longitude,json_local, (6371 * acos (cos (radians($latitudeFrom))* cos(radians(latitude))* cos( radians($longitudeFrom) - radians(longitude) )+ sin (radians($latitudeFrom))* sin(radians(latitude)))) AS distance FROM locals HAVING distance <= $maxDistance ORDER BY distance ASC";

            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
            
           
            $locals = array();
            foreach ($sth as $row) {
                
            
              //$id = $row['id'];
              //echo $row['latitude'];
              //echo $row['longitude'];
              
              
               array_push($locals,$row);
            }
            
            echo json_encode($locals);
            
                
            
            } else {echo "ERROR";}

            return NULL;
        }
        
        function geteventArea($latitudeFrom,$longitudeFrom,$maxDistance) {

        $query = "SELECT id,json_event, (6371 * acos (cos (radians($latitudeFrom))* cos(radians(latitude))* cos( radians($longitudeFrom) - radians(longitude) )+ sin (radians($latitudeFrom))* sin(radians(latitude)))) AS distance FROM events HAVING distance <= $maxDistance ORDER BY distance ASC";
    
        $sth = $this->conn->prepare($query);
    
        if ($sth->execute()) {
    
            $events = array();

            while($row = $sth->fetch(PDO::FETCH_ASSOC)) {
    
                $event = new Event($row['id'],$row['json_event']);
                array_push($events,$event);
            }
    
            return $events;
    
    
        } else {echo "ERROR";}
    
        return NULL;
        }
    }