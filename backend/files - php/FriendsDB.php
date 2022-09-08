<?php

class FriendsDB {

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
    
    function addFriend($user_id,$friend_id) {
        $query = "INSERT INTO `userfriends` (`user_id`,`friend_id`) VALUES ('$user_id','$friend_id')";
        $sth = $this->conn->prepare($query);
        $sth->execute();
    }
    
    function removeFriend($user_id,$friend_id) {
        $query = "DELETE FROM userfriends WHERE user_id = '$user_id' AND friend_id = '$friend_id'";
        $sth = $this->conn->prepare($query);
        $sth->execute();
    }
    
    function checkFollowing($user_id,$friend_id) {
        $query = "SELECT id FROM userfriends WHERE user_id = '$user_id' AND friend_id = '$friend_id'";
        $sth = $this->conn->prepare($query);
        
        if ($sth->execute()) {
            if ($sth->fetch(PDO::FETCH_ASSOC) != NULL) {
                return true;
            } else {
                return false;
            }
        }
    }
    
    function getFriends($user_id) {
        $query = "SELECT friend_id FROM userfriends WHERE user_id = '$user_id'";
        $sth = $this->conn->prepare($query);
        
        if ($sth->execute()) {
            $friends = array();
            while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                $friend_id = $row["friend_id"]; 
                $query1 = "SELECT id,email,username,followers,following,status,phone,businessEmail,webSite FROM usersaccount WHERE id = '$friend_id'";
                $sth1 = $this->conn->prepare($query1);
                
                if ($sth1->execute()) {
                    $row1 = $sth1->fetch(PDO::FETCH_ASSOC);
                    $friend = new Friend($row1['id'],$row1['email'],$row1['username'],$row1['followers'],$row1['following'],$row1['status'],$row1['phone'],$row1['businessEmail'],$row1['webSite']);
                    array_push($friends,$friend);
                }
            }
        }
        return $friends;
    }
    
    function getFollowers($friend_id) {
        $query = "SELECT user_id FROM userfriends WHERE friend_id = '$friend_id'";
        $sth = $this->conn->prepare($query);
        
        if ($sth->execute()) {
            $friends = array();
            while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                $user_id = $row["user_id"]; 
                $query1 = "SELECT id,email,username,followers,following,status,phone,businessEmail,webSite FROM usersaccount WHERE email = '$user_id'";
                $sth1 = $this->conn->prepare($query1);
                
                if ($sth1->execute()) {
                    $row1 = $sth1->fetch(PDO::FETCH_ASSOC);
                    $friend = new Friend($row1['id'],$row1['email'],$row1['username'],$row1['followers'],$row1['following'],$row1['status'],$row1['phone'],$row1['businessEmail'],$row1['webSite']);
                    array_push($friends,$friend);
                }
            }
        }
        return $friends;
    }
    
    function searchUsers($username,$user_email) {

        $friends = array();

        $query = "SELECT id,email,username,followers,following,status,phone,businessEmail,webSite FROM usersaccount WHERE username LIKE '$username%' AND email != '$user_email'";
        $sth = $this->conn->prepare($query);

        if ($sth->execute()) {
            while($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                $friend = new Friend($row['id'],$row['email'],$row['username'],$row['followers'],$row['following'],$row['status'],$row['phone'],$row['businessEmail'],$row['webSite']);
                array_push($friends,$friend);
            }
        }
        return $friends;
    }
    
    function getEventFriendTokens($friend_id) {
        $tokens = array();
        
        $query = "SELECT user_id FROM userfriends WHERE friend_id = '$friend_id'";
        $sth = $this->conn->prepare($query);
        
        if ($sth->execute()) {
            while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                $friend_id = $row['user_id'];
                $query1 = "SELECT deviceToken, event_friend FROM usersaccount WHERE email = '$friend_id'";
                $sth1 = $this->conn->prepare($query1);
                if ($sth1->execute()) {
                    $row1 = $sth1->fetch(PDO::FETCH_ASSOC);
                    $tokenNotification = new NotificationToken($row1['deviceToken'],$row1['event_friend']);
                    array_push($tokens,$tokenNotification);
                }
            }
        }
        return $tokens;
    }
    
    function getFriendByEmail($friend_email) {
        $query = "SELECT id, username, followers, following, status, phone, businessEmail, webSite FROM usersaccount WHERE email = '$friend_email'";
        $sth = $this->conn->prepare($query);
        
        if ($sth->execute()) {
            $row = $sth->fetch(PDO::FETCH_ASSOC);
            $friend = new Friend($row['id'],$friend_email,$row['username'],$row['followers'],$row['following'],$row['status'],$row['phone'],$row['businessEmail'],$row['webSite']);
            return $friend;
        }
    }
}

class NotificationToken {
    
    protected $token;
    protected $notificationActive;
    
    function __construct($token,$notificationActive) {
        $this->token = $token;
        $this->notificationActive = $notificationActive;
    }
    
    function getToken() {
        return $this->token;
    }
    
    function getNotificationActive() {
        return $this->notificationActive;
    }
}

class Friend {

    protected $id;
    protected $email;
    protected $username;
    protected $followers;
    protected $following;
    protected $status;

    protected $businessEmail;
    protected $phone;
    protected $webSite;

    function __construct($id,$email,$username,$followers,$following,$status,$phone,$businessEmail,$webSite) {
        $this->id = $id;
        $this->email = $email;
        $this->username = $username;
        $this->followers = $followers;
        $this->following = $following;
        $this->status = $status;
        $this->phone = $phone;
        $this->businessEmail = $businessEmail;
        $this->webSite = $webSite;
    }
    
    function getID() {
        return $this->id;
    }
    function getEmail() {
        return $this->email;
    }
    function getUsername() {
        return $this->username;
    }
    function getFollowers() {
        return $this->followers;
    }
    function getFollowing() {
        return $this->following;
    }
    function getStatus() {
        return $this->status;
    }
    function getPhone() {
        return $this->phone;
    }
    function getBE() {
        return $this->businessEmail;
    }
    function getWB() {
        return $this->webSite;
    }
}