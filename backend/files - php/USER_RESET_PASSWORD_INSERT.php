<?php
    
    require_once 'UsersAccountDB.php';
    require_once 'reset_password/ResetPasswordDB.php';

    $email = $_GET['email'];
    $user_id = $_GET['user_id'];
    $token = $_GET['token'];

    $rp = new ResetPasswordDB($user_id,$email);
    $response = $rp->checkTokenActivation($token);
     
    if ($response == 0) {
        ?>
        <!doctype html>
<html lang="en">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.2/css/bootstrap.min.css" integrity="sha384-Smlep5jCw/wG7hdkwQ/Z5nLIefveQRIY9nfy6xoR1uRYBtpZgI6339F5dgvm/e9B" crossorigin="anonymous">
    <link rel="shortcut icon" href="https://finixinc.com/website/images/FinixIcon.png">

    <style>
    
        @font-face {
            font-family: 'myFont';
            src: url('https://finixinc.com/website/font/accuratist.ttf');
        }

        html,
        body {
            height: 100%;
        }

        body {
            font-family: myfont;
            display: -ms-flexbox;
            display: -webkit-box;
            display: flex;
            -ms-flex-align: center;
            -ms-flex-pack: center;
            -webkit-box-align: center;
            align-items: center;
            -webkit-box-pack: center;
            justify-content: center;
            padding-top: 40px;
            padding-bottom: 40px;
            background-color: #f5f5f5;
        }

        .form-signin {
            width: 100%;
            max-width: 330px;
            padding: 15px;
            margin: 0 auto;
        }

        .form-signin .checkbox {
            font-weight: 400;
        }

        .form-signin .form-control {
            position: relative;
            box-sizing: border-box;
            height: auto;
            padding: 10px;
            font-size: 16px;
        }

        .form-signin .form-control:focus {
            z-index: 2;
        }

        .form-signin #newPassword {
            margin-bottom: -1px;
            border-bottom-right-radius: 0;
            border-bottom-left-radius: 0;
        }

        .form-signin #confirmPassword {
            margin-bottom: 5px;
            border-top-left-radius: 0;
            border-top-right-radius: 0;
        }

        .text-center div a {
            text-decoration: none;
        }

        .match {
            color: red;
        }
        
        .image {
            content: url("https://finixinc.com/website/images/FinixIcon.png");
            padding-top: 10px;
            width: 15%;
            height: auto;
        }

    </style>

    <title>Finix - Reset Password</title>
</head>

<body class="text-center">

    <form class="form-signin" action="../RESET_PASSWORD.php" method="post">
        <h1 class="h3 mb-3 font-weight-normal">Reset Password</h1>
        <input type="password" id="newPassword" name="newPassword" class="form-control nPassword" placeholder="New Password" required>
        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control nPassword" placeholder="Confirm Password" required>
        <input type="hidden" name="email" value="<?php echo $email ?>">
        <input type="hidden" name="token" value="<?php echo $token ?>">
        <label class="match"></label>
        
        <button class="btn btn-lg btn-danger btn-block" id="disabledButton" value="Submit" type="submit" disabled>Reset Password</button>
        <div> <img class="image"> </div>
        <p> FINIX <p>
        <p class="mt-4 mb-3 text-muted text-center">&copy; 2018 Gianfranco Putelli</p>
    </form>

    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.2/js/bootstrap.min.js" integrity="sha384-o+RDsa0aLu++PJvFqy8fFScvbHFLtbvScb8AjopnFD+iEQ7wo/CG0xlczd+2O/em" crossorigin="anonymous"></script>

    <script>
        var checkPass1 = document.getElementById("newPassword");
        checkPass1.onkeyup = function() {

            var pswd1 = $('#newPassword').val().replace(/\s+/g, '');
            var pswd2 = $('#confirmPassword').val().replace(/\s+/g, '');
            if (pswd1.length >= 8 && pswd2.length >= 8 && pswd1 == pswd2) {
                $("#disabledButton").removeAttr("disabled");
                $(".match").text("");
            } else {
                $("#disabledButton").attr("disabled", true);
            }
            if (pswd1.length >= 8 && pswd2.length >= 8 && pswd1 != pswd2) {
                $(".match").text("Passwords don't match");
            }
            if (pswd1.length < 8 || pswd2.length < 8) {
                $(".match").text("");
            }
        }
        var checkPass2 = document.getElementById("confirmPassword");
        checkPass2.onkeyup = function() {

            var pswd1 = $('#newPassword').val().replace(/\s+/g, '');
            var pswd2 = $('#confirmPassword').val().replace(/\s+/g, '');
            if (pswd1.length >= 8 && pswd2.length >= 8 && pswd1 == pswd2) {
                $("#disabledButton").removeAttr("disabled");
                $(".match").text("");
            } else {
                $("#disabledButton").attr("disabled", true);
            }
            if (pswd1.length >= 8 && pswd2.length >= 8 && pswd1 != pswd2) {
                $(".match").text("Passwords don't match");
            }
            if (pswd1.length < 8 || pswd2.length < 8) {
                $(".match").text("");
            }
        }
        
        window.addEventListener( "pageshow", function ( event ) {
            var historyTraversal = event.persisted || ( typeof window.performance != "undefined" && window.performance.navigation.type === 2 );
              if ( historyTraversal ) {
                window.location.reload();
              }
            });

    </script>

</body>

</html>
<?php
    } else {

    ?>
    
    <!doctype html>
<html lang="en">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.2/css/bootstrap.min.css" integrity="sha384-Smlep5jCw/wG7hdkwQ/Z5nLIefveQRIY9nfy6xoR1uRYBtpZgI6339F5dgvm/e9B" crossorigin="anonymous">

    <link rel="shortcut icon" href="https://finixinc.com/website/images/FinixIcon.png">
    <style>
        @font-face {
            font-family: 'myFont';
            src: url('https://finixinc.com/website/font/accuratist.ttf');
        }

        html,
        body {
            height: 100%;
        }

        body {
            font-family: myfont;
            display: -ms-flexbox;
            display: -webkit-box;
            display: flex;
            -ms-flex-align: center;
            -ms-flex-pack: center;
            -webkit-box-align: center;
            align-items: center;
            -webkit-box-pack: center;
            justify-content: center;
            padding-top: 40px;
            padding-bottom: 40px;
            background-color: #f5f5f5;
        }
        
        .image {
            content: url("https://finixinc.com/website/images/FinixIcon.png");
            padding-top: 10px;
            width: 15%;
            height: auto;
        }

    </style>

    <title>Finix - Link has expired</title>
</head>

<body class="text-center">
    <div>
        <div class="alert alert-danger" role="alert">
            <h1 class="alert-heading">Link has expired </h1>
        </div>
            <div>
                
                <form class="form-signin" action="../USER_RESET_PASSWORD.php" method="POST">
                <input type="hidden" name="email" value="<?php echo $email; ?>">
                <button class="btn btn-lg btn-danger btn-block" id="disabledButton" value="Submit" type="submit">Resend email</button>
                <div> <img class="image"> </div>
                <p> FINIX <p>
                <p class="mt-4 mb-3 text-muted text-center">&copy; 2018 Gianfranco Putelli</p>
    </form>
            </div>
    </div>
    
    <!-- <a id="button" href="https://finixinc.com/php/USER_RESET_PASSWORD_INSERT.php/?token= '.$this->token.'&email='.$this->email.'&user_id='.$this->user_id.'" class="btn btn-danger" role="button" aria-pressed="true">Reset Password</a> 
    
                    <a id="button" href="../USER_RESET_PASSWORD.php/?email= <?php echo 'email' ?>" class="btn btn-danger" role="button" aria-pressed="true">Resend email</a>
                <p class="mt-4 mb-3 text-muted text-center">&copy; 2018 Gianfranco Putelli</p>
        
    -->

    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.2/js/bootstrap.min.js" integrity="sha384-o+RDsa0aLu++PJvFqy8fFScvbHFLtbvScb8AjopnFD+iEQ7wo/CG0xlczd+2O/em" crossorigin="anonymous"></script>

    <script src=""></script>

</body>

</html>
    
    <?php 
    }
    ?>
      
    
    
    
    
    
    
    
    
    
    
   