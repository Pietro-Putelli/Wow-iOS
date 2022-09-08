<?php 
session_start();
    if ($_GET['logout'] == 1) {
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

    <link rel="shortcut icon" href="../images/FinixIcon.png">
    <link rel="stylesheet" href="../css/login_register_style.css">

    <title>Account Changes - Finix</title>
</head>

<body class="text-center">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <h1 class="mb-4">Change Profile Image</h1>
                <div class="row">
                    <div class="col-md-12">
                        <div class="mx-auto" id="userImagesChanges">
                            <img id="imageProfile2" src="../../usersAccountData/<?php echo $_SESSION['email'];?>/profilePicture.jpg">
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <h1 class="mb-4">Change Username</h1>
                <form class="form-group">
                    <div class="controls">
                        <div class="row justify-content-center">
                            <div class="col-md-6">
                                <div class="form-group mx-md-3 mb-3">
                                    <label for="staticEmail2" class="sr-only">Email</label>
                                    <input type="text" readonly class="form-control-plaintext text-center" id="staticEmail2" value="<?php echo $_SESSION['email'];?>">
                                </div>
                            </div>
                        </div>
                        <div class="row justify-content-center">
                            <div class="col-md-6">
                                <div class="form-group mx-md-3 mb-4">
                                    <label for="inputUsername2" class="sr-only">Username</label>
                                    <input type="username" class="form-control" id="inputUsername2" placeholder="Username" value="<?php echo $_SESSION['username'];?>">
                                </div>
                            </div>
                        </div>
                            <div class="row justify-content-center">
                            <div class="col-md-6">
                                <button type="submit" class="btn btn-primary mb-2">Change username</button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <h1 class="mb-4">Change Password</h1>
            </div>
            <div class="col-md-12">
                <form id="form-group" method="post" action="" role="form">
                    <div class="controls">
                        <div class="row justify-content-center">
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label for="inputUsername2" class="sr-only">Password</label>
                                    <input type="password" class="form-control" id="inputUsername2" placeholder="Old Password">
                                </div>
                            </div>
                        </div>
                        <div class="row justify-content-center">
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label for="inputUsername2" class="sr-only">Password</label>
                                    <input type="password" class="form-control" id="inputUsername2" placeholder="New Password">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label for="inputUsername2" class="sr-only">Password</label>
                                    <input type="password" class="form-control" id="inputUsername2" placeholder="Confirm New Password">
                                </div>
                            </div>
                        </div>
                        <div class="row justify-content-center">
                            <div class="col-md-12">
                                <button type="submit" class="btn btn-primary mb-2">Change password</button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>


    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.2/js/bootstrap.min.js" integrity="sha384-o+RDsa0aLu++PJvFqy8fFScvbHFLtbvScb8AjopnFD+iEQ7wo/CG0xlczd+2O/em" crossorigin="anonymous"></script>

    <script src="../js/login_register.js"></script>

</body>

</html>
