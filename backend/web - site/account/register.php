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

    <title>Register - Finix</title>
</head>

<body class="text-center">
    
    <form class="form-signin" action="../../php/userAccountUploadPHP_web.php" method="post" role="login">
        <a href="../index.php">
            <img class="mb-4" src="../images/FinixIcon.png" alt="" width="82" height="100">
        </a>
        <h1 class="h3 mb-3 font-weight-normal">Register</h1>
        <label for="username" class="sr-only">Username</label>
        <input type="username" id="username" name="username" class="form-control" placeholder="Username" required autofocus>
        <label for="email" class="sr-only">Email address</label>
        <input type="email" id="email" name="email" class="form-control rounder" placeholder="Email address" required>
        <label for="password" class="sr-only">Password</label>
        <input type="password" id="password" name="password" class="form-control" placeholder="Password" required>
        <label>
                <input type="checkbox" onclick="showFunction()">Show Password
        </label>
        <button class="btn btn-lg btn-success btn-block" id="disabledButton" type="submit" disabled>Register</button>
        <p>Already have an account?  <a href="login.php">Log in here</a></p>
        <p class="mt-4 mb-3 text-muted text-center">&copy; 2018 Gianfraco Putelli</p>
    </form>





    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.2/js/bootstrap.min.js" integrity="sha384-o+RDsa0aLu++PJvFqy8fFScvbHFLtbvScb8AjopnFD+iEQ7wo/CG0xlczd+2O/em" crossorigin="anonymous"></script>

    <script src="../js/login_register.js"></script>

</body>

</html>
