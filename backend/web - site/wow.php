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

    <title>WoW</title>
</head>

<body>
    <nav class="navbar navbar-expand-sm navbar-light bg-light" id="navIndex">
        <a class="navbar-brand" href="index.php">
            <img src="images/FinixIcon.png" width="25" height="30" class="d-inline-block align-top" alt="Finix Logo">
            Finix
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle active" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Our Apps</a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <a class="dropdown-item" href="#">WoW</a>
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







        <div id="map"></div>
        <div id="start">
            <div id="infinity">
                WoW
            </div>
            <div id="loading">
                Loading Map
            </div>
        </div>


        <div class="wrapper">
            <!-- Sidebar Holder -->
            <nav id="sidebar">
                <div id="overflower" onmouseover="this.style.overflowY='auto'" onmouseout="this.style.overflowY='hidden'">
                    <!-- General Sidebar -->
                    <form class="form-inline my-2 my-lg-0 reverseDisappearance" style="z-index: 5">
                        <input class="form-control mr-sm-2" id="searchbarWow" type="search" placeholder="Search" aria-label="Search">
                        <button class="btn btn-outline-primary my-2 my-sm-0" id="buttonsearchbarWow" type="submit">Search</button>
                    </form>
                    <div id="searcher" class="reverseDisappearance">
                        <div id="searcherTitle">Filter for</div>
                        <div class="col-md-12">
                            <a href="" class="col-md-3 col-sm-3 locals">
                        <img src="images/restaurant.png"  alt="restaurants" class="filters w-100">
                        Restaurants
                    </a>
                            <a href="" class="col-md-3 col-sm-3 locals">
                        <img src="images/bar.png"  alt="bar" class="filters w-100">
                        Bar
                    </a>
                            <a href="" class="col-md-3 col-sm-3 locals">
                        <img src="images/disco.png"  alt="disco" class="filters w-100">
                        Disco
                    </a>
                            <a href="" class="col-md-3 col-sm-3 locals">
                        <img src="images/events.png"  alt="events" class="filters w-100">
                        Events
                    </a>
                        </div>
                    </div>
                    <div id="localListContainer">
                    </div>

                    <!-- Locals Sidebar -->
                    <div class="disappearance sidebar-header d-none">
                        <h2 class="localEventName"></h2>
                        <h6 class="localEventSubtitles"></h6>
                        <div id="carouselExampleControls" class="carousel slide" data-ride="carousel">
                            <div class="carousel-inner">
                                <div class="carousel-item active">
                                    <img class="d-block w-100" src="images/FinixIcon.png" alt="First slide">
                                </div>
                                <div class="carousel-item">
                                    <img class="d-block w-100" src="images/Finix.png" alt="Second slide">
                                </div>
                                <div class="carousel-item">
                                    <img class="d-block w-100" src="images/FinixEdit.png" alt="Third slide">
                                </div>
                                <div class="carousel-item">
                                    <img class="d-block w-100" src="images/Finix.png" alt="Fourth slide">
                                </div>
                            </div>
                            <a class="carousel-control-prev" href="#carouselExampleControls" role="button" data-slide="prev">
                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        <span class="sr-only">Previous</span>
                    </a>
                            <a class="carousel-control-next" href="#carouselExampleControls" role="button" data-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        <span class="sr-only">Next</span>
                    </a>
                        </div>
                    </div>

                    <ul class="disappearance list-unstyled d-none">
                        <li>
                            <a href="#hoursSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle dropdown-toggle2 openClosedToday">
                        Today: 
                        <span class="openOrClosed"></span>
                    </a>
                            <ul class="collapse list-unstyled" id="hoursSubmenu">
                                <li class="day">
                                    <span>Monday: </span>
                                    <span class="monday1"></span>
                                    <span>-</span>
                                    <span class="monday2"></span>
                                </li>
                                <li class="day">
                                    <span>Tuesday: </span>
                                    <span class="tuesday1"></span>
                                    <span>-</span>
                                    <span class="tuesday2"></span>
                                </li>
                                <li class="day">
                                    <span>Wednesday: </span>
                                    <span class="wednesday1"></span>
                                    <span>-</span>
                                    <span class="wednesday2"></span>
                                </li>
                                <li class="day">
                                    <span>Thursday: </span>
                                    <span class="thursday1"></span>
                                    <span>-</span>
                                    <span class="thursday2"></span>
                                </li>
                                <li class="day">
                                    <span>Friday: </span>
                                    <span class="friday1"></span>
                                    <span>-</span>
                                    <span class="friday2"></span>
                                </li>
                                <li class="day">
                                    <span>Saturday: </span>
                                    <span class="saturday1"></span>
                                    <span>-</span>
                                    <span class="saturday2"></span>
                                </li>
                                <li class="day">
                                    <span>Sunday: </span>
                                    <span class="sunday1"></span>
                                    <span>-</span>
                                    <span class="sunday2"></span>
                                </li>
                            </ul>
                        </li>
                        <hr>
                        <li class="position">
                            <a>
                                <p class="city"></p>
                                <p class="street"></p>
                            </a>
                        </li>
                        <hr>
                        <li>
                            <a class="description"></a>
                        </li>
                        <hr>
                        <li>
                            <a href="#contactSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle dropdown-toggle2">
                        Contacts
                    </a>
                            <ul class="collapse list-unstyled" id="contactSubmenu">
                                <li>
                                    <div>
                                        <a class="localTelephone"></a>
                                    </div>
                                </li>
                                <li>
                                    <div>
                                        <a class="localEmail" href="mailto:ciao@gmail.com"></a>
                                    </div>
                                </li>
                                <li>
                                    <div>
                                        <a class="localWebSite" href=""></a>
                                    </div>
                                </li>
                            </ul>
                        </li>
                    </ul>
                    <div id="distanceSlider">
                        <!--label for="customRange">Example range</label-->
                        <p>Distance: <span id="distance"></span></p>
                        <input type="range" class="custom-range" min="100" max="1000" step="10" value="200" id="customRange">
                    </div>
                </div>
            </nav>


            <!-- Page Content Holder -->
            <div id="content">
                <button type="button" id="sidebarCollapse" class="navbar-btn">
                <span></span>
                <span></span>
                <span></span>
            </button>
            </div>
        </div>








        <!-- Optional JavaScript -->
        <!-- jQuery first, then Popper.js, then Bootstrap JS -->
        <script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.2/js/bootstrap.min.js" integrity="sha384-o+RDsa0aLu++PJvFqy8fFScvbHFLtbvScb8AjopnFD+iEQ7wo/CG0xlczd+2O/em" crossorigin="anonymous"></script>

        <script async defer src="https://maps.googleapis.com/maps/api/js?v=3.exp&key=AIzaSyA9Xc7CpM-rYNaCe0tti4rCtsJ45jP5PvM&callback=initMap"></script>

        <script src="js/index.js"></script>
</body>

</html>
