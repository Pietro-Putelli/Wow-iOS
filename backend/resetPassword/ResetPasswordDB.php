    <?php
    
    class ResetPasswordDB {
    
        protected $conn;
    
        function __construct($user_id,$email) {
    
            $this->user_id = $user_id;
            $servername = "localhost";
            $username = "tb2w536j_finixDB";
            $password = "c784Vg5MK";
            $dbname = "tb2w536j_showtime";
            $this->token = '';
            $this->email = $email;
    
            try
            {
                $this->conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
                // set the PDO error mode to exception
                $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            }
            catch(PDOException $e) {
                echo "Connection failed: " . $e->getMessage();
            }
        }
    
        function __destruct() {
            $this->conn = null;
        }
    
        function createNewToken() {
    
            $this->token = md5(uniqid(rand(), true));
            $query = "INSERT INTO resetpassword (user_id,token) VALUES ('$this->user_id','$this->token')";
            $sth = $this->conn->prepare($query);
    
        echo "OK";
            if ($sth->execute()) {
                $this->sendEmail();
            }
        }
    
        function sendEmail() {
    
            $to  = $this->email;
            $subject = 'Reset WoW password';
            $message = '<html>
       <head>
          <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.2/css/bootstrap.min.css" integrity="sha384-Smlep5jCw/wG7hdkwQ/Z5nLIefveQRIY9nfy6xoR1uRYBtpZgI6339F5dgvm/e9B" crossorigin="anonymous">
          <style>
          @font-face {
            font-family: "accuratist";
            src: url("https://finixinc.com/website/font/accuratist.ttf");
          }
             h2.title {
             margin-top: 20px;
             font-size: 40px;
             }
             h3.finix {
             text-align: center;
             vertical-align: middle;
             font-size: 30px;
             }

             body {
               font-family: accuratist;
             }
          </style>
       </head>
       <body>
          <div class="text-center">
             <h2 class="title">Reset password</h2>
          </div>
          <div class="mb-3 text-center">
             <h4>To reset your password click on the following link.</h4>
          </div>
          <div style="text-align: center">
              <img src="https://finixinc.com/website/images/FinixIcon.png" align="center" width="10%" height="auto">
          </div>
          <h3 class="finix"> Finix </h3>
          <div class="text-center">
             <a id="button" href="https://finixinc.com/php/USER_RESET_PASSWORD_INSERT.php/?token= '.$this->token.'&email='.$this->email.'&user_id='.$this->user_id.'" class="btn btn-danger" role="button" aria-pressed="true">Reset Password</a>
          </div>
          <div class="mt-4 text-center">
             If you have any questions, contact us: <a href="mailto:finix@finixinc.com">finix@finixinc.com</a>
          </div>
          <p class="mt-2 mb-1 text-muted text-center">&copy 2018 Gianfranco Putelli</p>
       </body>
    </html>


    ';
    
            $headers  = 'MIME-Version: 1.0' . "\r\n";
            $headers .= 'Content-type: text/html; charset=UTF-8' . "\r\n";
            $headers .= 'From: Finix <finix@finixinc.com>' . "\r\n";
    
            mail($to, $subject, $message, $headers);
        }
        
        function checkTokenActivation($user_token) {
            $token = str_replace(' ','', $user_token);
            $query = "SELECT active FROM resetpassword WHERE token = '$token'";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $row = $sth->fetchAll(PDO::FETCH_ASSOC);
                
                if (empty($row)) {
                    return 1;
                } else {
                    return $row[0]['active'];
                }
            }
        }
        
        function resetPassword($user_token) {
            
            $query = "SELECT token FROM resetpassword WHERE user_id = '$this->user_id' AND active = 0";
            $sth = $this->conn->prepare($query);
            $i = 0;
    
            if ($sth->execute()) {
                $row = $sth->fetchAll(PDO::FETCH_ASSOC);
                
                while ($i < sizeof($row)) {
                    $token = str_replace(' ','', $row[$i]['token']);
                    $user_token = str_replace(' ','', $user_token);
                    
                    if ($user_token == $token) {
                        $query = "UPDATE resetpassword SET active = 1 WHERE token = '$user_token'";
                        $sth = $this->conn->prepare($query);
                        $sth->execute();
                    }
                    $i++;
                }
            }
        }
    }
    
    
    
    
    
