    <?php

    require_once 'confirmMail/activationsTable.php';
    require_once 'GetAreaDB.php';

    class User {

        protected $id;
        protected $username;
        protected $email;
        protected $password;
        protected $status;
        protected $business_email;
        protected $phone;
        protected $web_site;

        function __construct($id,$username,$email,$password,$status,$business_email,$phone,$web_site) {

            $this->id = $id;
            $this->username = $username;
            $this->email = $email;
            $this->password = $password;
            $this->status = $status;
            $this->business_email = $business_email;
            $this->phone = $phone;
            $this->web_site = $web_site;
        }

        // Sii piu saggio degli altri, se puoi, ma non glielo dire.

        function getUserID() {return $this->id;}

        function getUsername() {return $this->username;}

        function getUserEmail() {return $this->email;}

        function getUserPassword() {return $this->password;}

        function getUserStatus() {return $this->status;}
        
        function getBusinessEmail() { return $this->business_email; }
        
        function getPhone() { return $this->phone; }
        
        function getWebSite() { return $this->web_site; }
    }

    class UsersAccountDB {

        protected $conn;

        function __construct() {

            $servername = "localhost";
            $username = "tb2w536j_finixDB";
            $password = "c784Vg5MK";
            $databaseName = "tb2w536j_showtime";

            try {

                $this->conn = new PDO("mysql:host=$servername;dbname=$databaseName", $username, $password);
                $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

            } catch(PDOException $e) {echo "Connection failed: " . $e->getMessage();}
        }

        function __destruct() {
            $this->conn = NULL;
        }


        function createAccount($username,$email,$password) {

            $sql = "INSERT INTO `usersaccount` (`username`,`email`,`password`) VALUES ('$username','$email','$password')";
            $statement = $this->conn->prepare($sql);

            if ($statement->execute()) {

                $last_id = $this->conn->lastInsertId();
                return $last_id;
            }

            else {
                echo "Error: " . $sql . "<br>" . $this->conn->error;
            }
        }
        
        function getFollowersNumber($friend_id) {
            $query = "SELECT COUNT(user_id) AS followers FROM userfriends WHERE friend_id = '$friend_id'";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                return $row['followers'];
            }
        }
        
        function getFollowingNumber($user_id) {
            $query = "SELECT COUNT(user_id) AS following FROM userfriends WHERE user_id = '$user_id'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                return $row['following'];
            }
        }

        function uploadBusinessInfo($user_id,$email,$web_site,$phone_number) {
            $query = "UPDATE usersaccount SET businessEmail = '$email', webSite = '$web_site', phone = '$phone_number' WHERE email = '$user_id'";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }

        function setPasswordByEmail($email,$password) {

            $query = "UPDATE usersaccount SET password = '$password' WHERE email = '$email'";

            $sth = $this->conn->prepare($query);
            $sth->execute();
        }

        function setStatusByEmail($email,$status) {

            $query = "UPDATE usersaccount SET status =:status WHERE email =:email";

            $sth = $this->conn->prepare($query);

            $sth->bindParam(':email', $email);
            $sth->bindParam(':status', $status);

            if ($sth->execute()) {echo $email;}
        }

        function setUsernameByEmail($email, $username) {

            $query = "UPDATE usersaccount SET username =:username WHERE email =:email";

            $sth = $this->conn->prepare($query);

            $sth->bindParam(':email', $email);
            $sth->bindParam(':username', $username);

            if ($sth->execute()) {}
        }

        function checkUsersExistence($email, $password) {

            $query = "SELECT id, username, email, password, status, businessEmail, webSite, phone FROM usersaccount WHERE email = '$email' AND password = '$password'";

            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {

                $row = $sth->fetch(PDO::FETCH_ASSOC);

                if (!empty($row)) {

                    $user = new User($row['id'],$row['username'],$row['email'],$row['password'],$row['status'],$row['businessEmail'],$row['phone'],$row['webSite']);
                    return $user;
                } else {
                    return NULL;
                }
            }
            else {
                echo "error"."<br>";
                echo $sth->errorInfo()[0];
            }
        }
        
        function checkUsersExistence1($email) {

            $query = "SELECT id, username, email, password, status, businessEmail, webSite, phone FROM usersaccount WHERE email = '$email'";

            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {

                $row = $sth->fetch(PDO::FETCH_ASSOC);

                if (!empty($row)) {

                    $user = new User($row['id'],$row['username'],$row['email'],$row['password'],$row['status'],$row['businessEmail'],$row['phone'],$row['webSite']);
                    return $user;
                } else {
                    return NULL;
                }
            }
            else {
                echo "error"."<br>";
                echo $sth->errorInfo()[0];
            }
        }

        function checkEmailForRegistration($email) {

            $query = "SELECT email FROM usersaccount WHERE email = '$email'";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {

                $row = $sth->fetch(PDO::FETCH_ASSOC);

                if (empty($row)) {
                    return false;
                } else {
                    return true;
                }
            }
        }

        function getUserData($email) {

            $query = "SELECT id, username, email, status, phone, webSite, businessEmail FROM usersaccount WHERE email = '$email'";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {

                $row = $sth->fetch(PDO::FETCH_ASSOC);

                if (!empty($row)) {

                    $user = new User($row['id'],$row['username'],$row['email'],$row['password'],$row['status'],$row['businessEmail'],$row['phone'],$row['web_site']);
                    return $user;
                } else {
                    return NULL;
                }
            }
            else {
                echo "error"."<br>";
                echo $sth->errorInfo()[0];
            }
        }
        
        function getUserDataByID_JSON($id) {
            
            $query = "SELECT email,id, username, email, status, phone, webSite, businessEmail FROM usersaccount WHERE id = '$id'";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {

                $row = $sth->fetch(PDO::FETCH_ASSOC);

                $jsonArray = array(
                    "id" => $row['id'],
                    "username" => $row['username'],
                    "email" => $row['email'],
                    "status" => $row['status'],
                    "businessEmail" => $row['businessEmail'],
                    "phone" => $row['phone'],
                    "web_site" => $row['web_site']
                    );
                    return $jsonArray;
            }
            else {
                echo "error"."<br>";
                echo $sth->errorInfo()[0];
            }
        }

        function getUserIDByEmail($email) {

            $query = "SELECT id FROM usersaccount WHERE email = '$email'";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {

                $row = $sth->fetch(PDO::FETCH_ASSOC);

                if (!empty($row)) {

                    return $row['id'];
                } else {
                    return NULL;
                }
            }
            else {
                echo "error"."<br>";
                echo $sth->errorInfo()[0];
            }
        }
        
        function getUserEmailByID($user_id) {
            $query = "SELECT email FROM usersaccount WHERE id = '$user_id'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                return $row['email'];
            }
        }

        function setDeviceToken($email,$deviceToken) {

            $query = "UPDATE usersaccount SET deviceToken = '$deviceToken' WHERE email = '$email'";
            $sth = $this->conn->prepare($query);
            if ($sth->execute()) {}
        }

        function setFavLocalsArray($email,$arraySerialized) {

            $query = "UPDATE usersaccount SET favouriteLocals = '$arraySerialized' WHERE email = '$email'";
            $sth = $this->conn->prepare($query);
            if ($sth->execute()) {}
        }

        function getFavLocalIDs($email) {

            $query = "SELECT favouriteLocals FROM usersaccount WHERE email = '$email'";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {

                $row = $sth->fetch(PDO::FETCH_ASSOC);
                return $row['favouriteLocals'];
            }
        }

        function getFavLocalsJSON($email) {

            $favLocalIDs = unserialize($this->getFavLocalIDs($email));
            $locals = array();

            foreach ($favLocalIDs as $favLocals) {

                $query1 = "SELECT id,rating,owner,likes,json_local FROM locals WHERE id = '$favLocals'";
                $sth1 = $this->conn->prepare($query1);

                if ($sth1->execute()) {

                    $row = $sth1->fetch(PDO::FETCH_ASSOC);
                    $local = new Local($row['id'],$row['json_local'],$row["rating"],$row["owner"],$row["likes"]);
                    array_push($locals,$local);
                }
            }
            return $locals;
        }

        function getLikedEventArray($email) {

            $query = "SELECT likedEvents FROM usersaccount WHERE email = '$email'";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                return $row['likedEvents'];
            }
        }
        
        function setLikedEventArray($email,$arraySerialized) {
            $query = "UPDATE usersaccount SET likedEvents = '$arraySerialized' WHERE email = '$email'";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function getGoingEventArray($email) {
            $query = "SELECT goingEvents FROM usersaccount WHERE email = '$email'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                return $row['goingEvents'];
            }
        }
        
        function setGoingEventArray($email,$arraySerialized) {
            $query = "UPDATE usersaccount SET goingEvents = '$arraySerialized' WHERE email = '$email'";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }

        function setLikedEventsArray($email,$arraySerialized) {

            $query = "UPDATE usersaccount SET likedEvents = '$arraySerialized' WHERE email = '$email'";
            $sth = $this->conn->prepare($query);
            if ($sth->execute()) {}
        }
        
        function getEventLikesArray($email) {
            $query = "SELECT likedEvents FROM usersaccount WHERE email = '$email'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                return $row['likedEvents'];
            }
        }
        
        function getEventGoingArray($email) {
            $query = "SELECT goingEvents FROM usersaccount WHERE email = '$email'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                return $row['goingEvents'];
            }
        }

        function setFriendArray($email,$arraySerialized) {

            $query = "UPDATE usersaccount SET friends = '$arraySerialized' WHERE email = '$email'";
            $sth = $this->conn->prepare($query);
            if ($sth->execute()) {}
        }

        function getFriendIDs($email) {

            $query = "SELECT friends FROM usersaccount WHERE email = '$email'";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {

                $row = $sth->fetch(PDO::FETCH_ASSOC);
                return $row['friends'];
            }
        }

        function getFriendsToken($email) {

            $query = "SELECT friendsToken FROM usersaccount WHERE email = '$email'";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {

                $row = $sth->fetch(PDO::FETCH_ASSOC);
                return $row['friendsToken'];
            }
        }

        function selectTokenByEmail($email) {

            $query = "SELECT deviceToken FROM usersaccount WHERE email = '$email'";
            $sth = $this->conn->prepare($query);

            if($sth->execute()) {

                $row = $sth->fetch(PDO::FETCH_ASSOC);
                return $row['deviceToken'];
            }
        }

        function getFriendsJSON() {

            $fiendIDs = unserialize($this->getFriendIDs($email));
            $friendsJSONArray = array();

            foreach ($fiendIDs as $friend) {

                $query1 = "SELECT friend_json FROM locals WHERE id = '$friend'";
                $sth1 = $this->conn->prepare($query1);

                if ($sth1->execute()) {

                    $row = $sth1->fetch(PDO::FETCH_ASSOC);

                    array_push($favLocalsJSONArray,$row['json_friend']);
                }
            }
            return $friendsJSONArray;
        }

        function uploadUserImage($email,$path) {

            $target_dir = "../usersAccountData/".$email.$path;

            if(!file_exists($target_dir)) {
                mkdir($target_dir, 0755, true);
            }

            $target_dir = $target_dir . "/" . basename($_FILES["file"]["name"]);

            if (move_uploaded_file($_FILES["file"]["tmp_name"], $target_dir)) {
                echo json_encode([
                    "Message" => "The file ". basename( $_FILES["file"]["name"]). " has been uploaded.",
                    "Status" => "OK",
                    "userId" => $_REQUEST["userId"],
                    "OK" => $target_dir
                ]);

            } else {

                echo json_encode([
                    "Message" => "Sorry, there was an error uploading your file.",
                    "Status" => "Error",
                    "userId" => $_REQUEST["userId"]
                ]);
            }
        }
        
        function checkSetPassword($user_email,$user_password,$new_password) {
            $query = "SELECT password FROM usersaccount WHERE email = '$user_email'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                
                if ($row['password'] == md5($user_password)) {
                    
                    $new_pass = md5($new_password);
                    $query1 = "UPDATE usersaccount SET password = '$new_pass' WHERE email = '$user_email'";
                    $sth1 = $this->conn->prepare($query1);
                    $sth1->execute();
                    return true;
                } else {
                    return false;
                }
            }
        }
        
        function getNotificationsSettings($user_email) {
            $query = "SELECT event_set, event_friend, follow, answer FROM usersaccount WHERE email = '$user_email'";
            $sth = $this->conn->prepare($query);
            
            $responses = array();
            
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                $responses = array(
                    
                    0 => (int)$row['event_set'],
                    1 => (int)$row['event_friend'],
                    2 => (int)$row['follow'],
                    3 => (int)$row['answer']
                    );
                return $responses;
            }
        }
        
        function setNotificationsSettings($user_email,$event_set,$event_friend,$follow,$answer) {
            $query = "UPDATE usersaccount SET event_set = '$event_set', event_friend = '$event_friend', follow = '$follow', answer = '$answer' WHERE email = '$user_email'";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function getToken($user_id) {
            $query = "SELECT deviceToken FROM usersaccount WHERE id = '$user_id'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                return $row['deviceToken'];
            }
        }
        
        function getTokenByEmail($user_email) {
            $query = "SELECT deviceToken FROM usersaccount WHERE email = '$user_email'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                return $row['deviceToken'];
            }
        }
        
        function setLogged($email,$logged) {
            $query = "UPDATE usersaccount SET logged = '$logged' WHERE email = '$email'";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function getLogged($id) {
            $query = "SELECT logged FROM usersaccount WHERE id = '$id'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                $logged = (bool) $row['logged'];
                return $logged;
            }
        }
        
        function getLoggedByEmail($email) {
            $query = "SELECT logged FROM usersaccount WHERE email = '$email'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                $logged = (bool) $row['logged'];
                return $logged;
            }
        }
        
        function getFollow($user_id) {
            $query = "SELECT follow FROM usersaccount WHERE id = '$user_id'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                $follow = (bool) $row['follow'];
                return $follow;
            }
        }
        
        function getAnswer($user_id) {
            $query = "SELECT answer FROM usersaccount WHERE id = '$user_id'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                $answer = (bool) $row['answer'];
                return $answer;
            }
        }
        
        function getEventSetByEmail($user_email) {
            $query = "SELECT event_set FROM usersaccount WHERE email = '$user_email'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                $event_set = (bool) $row['event_set'];
                return $event_set;
            }
        }
        
        function checkUserExistence($user_email) {
            $query = "SELECT email FROM usersaccount WHERE email = '$user_email'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                
                if (empty($row)) {
                    return false;
                } else {
                    return true;
                }
            }
        }
        
        function checkUsernameUnique($user_name) {
            $query = "SELECT id FROM usersaccount WHERE username = '$user_name'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                if (empty($row)) {
                    return false;
                } else {
                    return true;
                }
            }
        }
    }














