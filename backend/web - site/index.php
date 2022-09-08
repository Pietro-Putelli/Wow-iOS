<?php 
session_start();
    if (isset($_GET['logout'])) {
        session_unset();
        session_destroy();
    }

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

    <title>Finix</title>
</head>

<body>
    <div class="background"></div>

    <nav class="navbar navbar-expand-sm navbar-light bg-light">
        <a class="navbar-brand" href="#">
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
                <li class="nav-item">
                    <a class="nav-link" href="about.php">About</a>
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


    <img src="images/FinixIcon.png" class="rounded mx-auto d-block img-fluid" alt="Finix Logo">
    <div id="writes">
        <div id="inc">
            Finix
        </div>
        <div id="slogan">
            <i>So many ideas, So little time.</i>
        </div>
        <p class="mt-5 mb-3 text-muted text-center">&copy; 2018 Gianfranco Putelli</p>
    </div>

    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.2/js/bootstrap.min.js" integrity="sha384-o+RDsa0aLu++PJvFqy8fFScvbHFLtbvScb8AjopnFD+iEQ7wo/CG0xlczd+2O/em" crossorigin="anonymous"></script>
</body>

</html>
