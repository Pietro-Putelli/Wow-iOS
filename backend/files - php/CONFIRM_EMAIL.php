<?php
 require_once 'confirmMail/activationsTable.php';
 $token = $_GET['token'];
 $email = $_GET['email']; 
 $user_id = $_GET['id']; 
 
 $activation = new Activations($user_id,$email);
 
 $activation->activeAccount($token);
 
 

?>


<html>
  <head>
    <style>

      .title {
        position: absolute;
        margin-left: auto;
        margin-right: auto;
        left: 0;
        right: 0;
        text-align: center;
        top: 20px;
      }

      a {
        color: #8d312f;
        text-decoration: none;
      }

      a:hover {
        color: gray;
      }

      .bottomBanner {
        font-size: 14px;
        position: absolute;
        margin-left: auto;
        margin-right: auto;
        left: 0;
        right: 0;
        text-align: center;
        bottom: 30px;
        color: #494949;
      }

      .img {
        width: 250px;
        height: 290px;
        max-width: 100%;
        content: url("confirmMail/finix.png");
      }

      .imgContainer {
        position: absolute;
        margin-left: auto;
        margin-right: auto;
        padding-top: 220;
        left: 0;
        right: 0;
        text-align: center;
      }

      .title1 {
          color:#494949;
          font-size: 50px;
          margin: 0;
      }

      .title2 {
        color:#6D6D6D;
        font-size: 25px;
        margin: 20;
      }

      .finixTitle {
        color: #494949;
        font-size: 25px;
        margin: 0;
      }

      .finixSubtitle {
        color: #6D6D6D;
        font-style: oblique;
        font-size: 18px;
        margin: 10;
      }

    </style>
  </head>
  <body style="font-family: Trebuchet MS">
    <div class="title">
      <div> <p class="title1"> Hey there your account has been activated!</p> <p class="title2"> Welcome to WOW, the best app to search locals and events. </p> </div>
    </div>
    <div class="imgContainer">
      <img class="img">
      <div>
        <p class="finixTitle"> FINIX </p>
        <p class="finixSubtitle"> So many ideas, So little time. </p>
      </div>
    </div>
    <div class="bottomBanner">
      <p style="font-size: 16px;">
        If you have any questions, contact us: <a href="mailto:finix@finixinc.com"> finix@finixinc.com </a>
      </p>
      <p style="font-size: 16px">
        &copy 2018 Gianfranco Putelli
      </p>
    </div>
  <body>
</html>
