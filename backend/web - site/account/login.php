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

    <title>Login - Finix</title>
</head>

<body class="text-center">
    
    <form class="form-signin" action="../../php/USER_DATA_WEB_GET.php" method="post">
        <a href="../index.php">
            <img class="mb-4" src="../images/FinixIcon.png" alt="" width="82" height="100">
        </a>
        <h1 class="h3 mb-3 font-weight-normal">Login</h1>
        <label for="inputEmail" class="sr-only">Email address</label>
        <input type="email" id="inputEmail" name="email" class="form-control" placeholder="Email address" required autofocus>
        <label for="inputPassword" class="sr-only">Password</label>
        <input type="password" id="inputPassword" name="password" class="form-control" placeholder="Password" required>
        <?php
            if(isset($_GET['error_login'])) {
                echo '<div style="color: rgb(255, 0, 0);">Incorrect email or password</div>'; 
            }
        ?>
        <p style="margin-bottom: 0;"><a href="forgot_password.php">Forgot Password</a></p>
        <button class="btn btn-lg btn-success btn-block" type="submit">Log in</button>
        <p>Do not have an account? <a href="register.php">Register here</a></p>
        <p class="mt-4 mb-3 text-muted text-center">&copy; 2018 Gianfranco Putelli</p>
    </form>





    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.2/js/bootstrap.min.js" integrity="sha384-o+RDsa0aLu++PJvFqy8fFScvbHFLtbvScb8AjopnFD+iEQ7wo/CG0xlczd+2O/em" crossorigin="anonymous"></script>

    <script src="../js/login_register.js"></script>

</body>

</html>
