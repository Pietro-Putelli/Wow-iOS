<?php

    class RatingDB {

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
      
      function addRating($local_id,$rating) {
          $query = "UPDATE localsrating SET number_reviews = (number_reviews + 1), sum_reviews = (sum_reviews + '$rating'), rating = (sum_reviews / number_reviews) WHERE local_id = '$local_id'";
          $sth = $this->conn->prepare($query);
          $sth->execute();
          
          echo $local_id;
          
          $query = "UPDATE locals SET rating = (SELECT rating FROM localsrating WHERE local_id = '$local_id') WHERE id = '$local_id'";
          $sth = $this->conn->prepare($query);
          $sth->execute();
      }
      
      function removeRating($local_id,$rating) {
          $query = "UPDATE localsrating SET number_reviews = (number_reviews - 1), sum_reviews = (sum_reviews - '$rating'), rating = (sum_reviews / number_reviews) WHERE local_id = '$local_id'";
          $sth = $this->conn->prepare($query);
          $sth->execute();
          
          $query = "UPDATE locals SET rating = (SELECT rating FROM localsrating WHERE local_id = '$local_id') WHERE id = '$local_id'";
          $sth = $this->conn->prepare($query);
          $sth->execute();
      }
}