<?php

//require 'PHPMailerAutoload.php';

	
class Activations{
    
    protected $conn;
    
    function __construct($user_id,$email)
    {
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
           
            //echo "Connected successfully"; 
        }
        catch(PDOException $e)
        {
        echo "Connection failed: " . $e->getMessage();
        } 
    }   
        
    function __destruct()
    {
            $this->conn = null;
    }
    
    function createNewToken()
    {
            
        $today = date("Y-m-d");
        $this->token = md5(uniqid(rand(), true));
       
        $sql = "INSERT INTO `activations` (`user_id`,`token`,`date`) VALUES (:user_id,:token,:date)";
        $statement = $this->conn->prepare($sql);
 
        $statement->bindValue(':user_id', $this->user_id);
        $statement->bindValue(':token', $this->token);
        $statement->bindValue(':date', $today);
        
        
       
       $inserted = $statement->execute();
        

        if ($inserted)
            {
            echo "New record created successfully";
            $this->sendMail();
            }
        else
            {
            echo "Error: " . $sql . "<br>" . $this->conn->error;
            }
            
         
            
    }

    function sendMail() {
        
    $to  = $this->email;
    $subject = 'Welcome to WoW';
    $message = '<html>
    <head>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.2/css/bootstrap.min.css" integrity="sha384-Smlep5jCw/wG7hdkwQ/Z5nLIefveQRIY9nfy6xoR1uRYBtpZgI6339F5dgvm/e9B" crossorigin="anonymous">
        <style>
          #image {
            margin: 0 auto;
            background-image: url("https://www.finixinc.com/php/confirmMail/finix.png");
            background-repeat: no-repeat;
            background-position: center;
            background-size: contain;
            width: 250px;
            height: 200px;
          }
         </style>
    </head>

    <body style="font-family:Verdana">
        <div class="text-center">
            <h2>Welcom to WoW!</h2>
        </div>

        <a href="https://finixinc.com/website"><img src="https://finixinc.com/website/images/FinixIcon.png" width="100" height="100" class="rounded mx-auto d-block img-fluid" alt="Finix Logo"></a>
        <h2 class="text-center">Finix</h2>
        <h5 class="mb-4 text-center"><i>So many ideas, So little time.</i></h5>

        <div class="mb-3 text-center">
            <h4>To confirm your account click on the following link.</h4>
        </div>

        <div class="text-center">
            <a id="button" href="https://finixinc.com/php/CONFIRM_EMAIL.php/?token='.$this->token.'&email='.$this->email.'&id='.$this->user_id.'>" class="btn btn-danger" role="button" aria-pressed="true">Confirm Account</a>
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
    
    function getMail()
    {
        $mail = new PHPMailer;

        $mail->isSMTP();
        // Server SMTP
        $mail->Host = 'authsmtp.lidiaedu.com';
        // Ablitiazione autenticazione SMTP
        $mail->SMTPAuth = true;
        // USERNAME server SMPT
        //$mail->Username = "noreplay@lidiaedu.com";
        //$mail->Username = "info@lidiaedu.com";
        $mail->Username = "smtp@lidiaedu.com";
        // PASSWORD server SMTP
        //$mail->Password = "a3*CR2LN=oK7Lu";
        //$mail->Password = "Cittadina1968.";
        $mail->Password = "tk4_Z-qy.@cp93";
        // Tipo di autenticazione
        //$mail->SMTPSecure = 'tls';
        // Porta su cui il server SMTP è in ascolto
        $mail->Port = 25;

        return $mail;
    }
    
    function activeAccount($userToken)
    {
         $today = date("Y-m-d");
        $token = md5(uniqid(rand(), true));
       
        $sql = "SELECT `token` FROM `activations` WHERE `user_id` = :user_id";
        $statement = $this->conn->prepare($sql);
 

        $statement->bindValue(':user_id', $this->user_id);
        
        if ($statement->execute())
            {
             $row = $statement->fetchAll(PDO::FETCH_ASSOC);
             //echo $row[0]['token'];
                if ($userToken == $row[0]['token'])
                {
                    $sql = "UPDATE `activations` SET `active`= 1 WHERE `user_id` = :user_id";
                    $statement = $this->conn->prepare($sql);
                    $statement->bindValue(':user_id', $this->user_id);
                    $statement->execute();
                    
                }
                else
                {
                    return 0;
                }
            }
        else
            {
            echo "Error: " . $sql . "<br>" . $this->conn->error;
            }
    }
    function isActive()
    {
        $sql = "SELECT `active` FROM `activations` WHERE `user_id` = :user_id";
        $statement = $this->conn->prepare($sql);
        $statement->bindValue(':user_id', $this->user_id);
        
        if ($statement->execute())
            {
            $row = $statement->fetchAll(PDO::FETCH_ASSOC);
            echo $row[0]['active'];//Se da 1 è attivo se da zero non è attivo
            }
    }


}



//$a = new Activations(3);
//$r=$a->activeAccount('5ca6843bcf64b113e1a4b3999f1c7aaa');
//$r=$a->isActive();
//echo $r;





?>
