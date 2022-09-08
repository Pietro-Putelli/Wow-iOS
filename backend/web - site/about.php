<?php 
session_start();
    if (isset($_SESSION['email'])){
        $isLogged = 1;
    } else {
        $isLogged = 0;
    }
?>

<!doctype html>
<html lang="en">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.2/css/bootstrap.min.css" integrity="sha384-Smlep5jCw/wG7hdkwQ/Z5nLIefveQRIY9nfy6xoR1uRYBtpZgI6339F5dgvm/e9B" crossorigin="anonymous">

    <link rel="shortcut icon" href="images/FinixIcon.png">
    <link rel="stylesheet" href="css/style.css">

    <title>About</title>
</head>

<body>
    <nav class="navbar navbar-expand-sm navbar-light bg-light">
        <a class="navbar-brand" href="index.php">
            <img src="images/FinixIcon.png" width="25" height="30" class="d-inline-block align-top" alt="">
            Finix
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Our Apps</a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <a class="dropdown-item" href="wow.php">WoW</a>
                    </div>
                </li>
                <li class="nav-item active">
                    <a class="nav-link" href="#">About</a>
                </li>
            </ul>
            <?php
                if ($isLogged == 0) {
                    echo '<a href="account/login.php" class="btn btn-outline-success mx-sm-2" role="button" aria-pressed="true">Login</a>';
                        
                    echo '<a href="account/register.php" class="btn btn-outline-danger registerButton" role="button" aria-pressed="true">Register</a>';
                }
            ?>
        </div>
        
        
         <?php
            if ($isLogged == 1) {
                echo '<div class="nav-item" id="accountManagementDropdown">';
                echo '<a class="nav-link" data-toggle="collapse" id="accountDropdown" href="#accountManagement" role="button" aria-expanded="false" aria-controls="accountManagement">';
                echo '<img class="rounded mx-auto d-block" id="accountImage" src="../usersAccountData/';
                echo $_SESSION['email'];
                echo '/profilePicture.jpg">';
                echo '</a>';
                echo '</div>';

            }
        ?>
    </nav>
    <?php
        if ($isLogged == 1) {
            echo '<div class="position-absolute collapse" id="accountManagement">';
            echo '<div class="card card-body">';
            
            echo '<a href="account/account_changes.php">';
            
            echo '<div id="profileImageContainer">';
            echo '<img class="rounded mx-auto d-block" id="profileImage" src="../usersAccountData/';
            echo $_SESSION['email'];
            echo'/profilePicture.jpg">';
            echo '</div>';
            
            echo '<div>';
            echo '<p id=userNameHeight>';
            echo $_SESSION['username'];
            echo '</p>';
            echo $_SESSION['email'];
            echo '</div>';
                
            echo '</a>';
                
            echo '<hr>';
    
            echo '<a data-toggle="collapse" href="#localDropdown" role="button" aria-expanded="false" aria-controls="localDropdown">My Local</a>';
            echo '<div class="collapse" id="localDropdown">';
            echo 'ciao';
            echo '</div>';
    
            echo '<a data-toggle="collapse" href="#eventDropdown" role="button" aria-expanded="false" aria-controls="eventDropdown">My Event</a>';
            echo '<div class="collapse" id="eventDropdown">';
            echo 'hey';
            echo '</div>';
            
            echo '<a href="index.php?logout=1">Log out</a>';
                
            echo '<hr>';
                
            echo '<a>Languages: </a>';
    
            echo '</div>';
            echo '</div>';
        }
    ?>
    
    
    
    
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <h1 class="display-4 text-center">Our Story</h1>
                <div class="col-md-4 float-left text-center">
                    <img src="images/Finix.png" class="img-fluid finix-logo" alt="Finix Marchio" width="100%">
                </div>
                <div class="col-md-8 float-right align-middle" id="storyText">
                    Finix is managed by a small team of developers. We’re looking to grow this team.<br> Finix was founded in 2018 with the intention of creating a new application to facilitate the search of locals and events close to its position.
                </div>
            </div>
        </div>
    </div>
    <div class="container">
        <div class="row">
            <div class="col-md-8">
                <form id="contact-form" method="post" action="" role="form">
                    <div class="messages"></div>
                    <div class="controls">
                        <h1 class="text-center">Contact us</h1>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="form_name">Firstname</label>
                                    <input id="form_name" type="text" name="name" class="form-control" placeholder="Please enter your firstname" required="required" data-error="Firstname is required.">
                                    <div class="help-block with-errors"></div>
                                </div>
                            </div>
                            <div class="col-md-6 margin">
                                <div class="form-group">
                                    <label for="form_lastname">Lastname</label>
                                    <input id="form_lastname" type="text" name="surname" class="form-control" placeholder="Please enter your lastname" required="required" data-error="Lastname is required.">
                                    <div class="help-block with-errors"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="form_email">Email</label>
                                    <input id="form_email" type="email" name="email" class="form-control" placeholder="Please enter your email" required="required" data-error="Valid email is required.">
                                    <div class="help-block with-errors"></div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="form_Object">Object</label>
                                    <input id="form_object" type="text" name="object" class="form-control" placeholder="Please enter your object">
                                    <div class="help-block with-errors"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="form_message">Message</label>
                                    <textarea id="form_message" name="message" class="form-control" placeholder="Message" rows="4" required="required" data-error="Please,leave us a message."></textarea>
                                    <div class="help-block with-errors"></div>
                                </div>
                            </div>
                            <div class="col-md-12">
                                <div class="form-group form-check">
                                    <input type="checkbox" class="form-check-input" required="required" id="exampleCheck1">
                                    <label class="form-check-label" for="exampleCheck1">Inviando il messaggio l'utente autorizza al trattamento dei dati come da <a href="#">Privacy Policy</a></label>
                                </div>
                            </div>
                            <div class="col-md-12">
                                <input type="submit" class="btn btn-outline-primary btn-send" value="Send message">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="col-md-4">
                <h1 class="text-center">Why contact us ?</h1>
                <div id="whiContactUsText">
                    - For problems with the web site or with the apps<br> - For commercial info (advertising)<br> - For information<br>
                </div>
                <div id="followUsImages">
                    <a href="https://www.facebook.com/Finix-822578794599372" target="_blank" class="decoration">
                        <div id="facebookHover">
                            <img src="images/facebookBlack.png" class="followImage img-fluid" id="facebook">
                            <img src="images/facebook.png" class="followImage img-fluid" id="facebook2">
                        </div>
                    </a>
                    <a href="https://www.instagram.com/_finixofficial_" target="_blank" class="decoration">
                        <div id="intagramHover">
                            <img src="images/instagramIcon.png" class="followImage img-fluid" id="instagram">
                            <img src="images/app-icon2.png" class="followImage img-fluid" id="instagram2">
                        </div>
                    </a>
                    <a href="https://twitter.com/Finix38754132" target="_blank" class="decoration">
                        <div id="twitterHover">
                            <img src="images/twitterBlack.png" class="followImage img-fluid" id="twitter">
                            <img src="images/twitter_accounts-a.png" class="followImage img-fluid" id="twitter2">
                        </div>
                    </a>
                    <a href="mailto:finixincofficial" class="decoration">
                        <div id="mailHover">
                            <img src="images/emailBlack.png" class="followImage img-fluid" id="mail">
                            <img src="images/emailIcon.png" class="followImage img-fluid" id="mail2">
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.2/js/bootstrap.min.js" integrity="sha384-o+RDsa0aLu++PJvFqy8fFScvbHFLtbvScb8AjopnFD+iEQ7wo/CG0xlczd+2O/em" crossorigin="anonymous"></script>
</body>

</html>
