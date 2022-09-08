<?php

$to      = 'pietroputelli80@gmail.com';
$subject = 'the subject';
$message = '<html>

  <style>

    @@font-face {
      font-family: "LEIXO";
      src: url("https://finixin.com/website/LEIXO-Regular.ttf");
    }

    body {
      font-family: "LEIXO";
    }

    p {
      text-align: center;
    }

    .appStore {
      content: url("https://finixinc.com/wow_resources/app_store.png");
      width: 200px;
      height: auto;
      margin: 0 auto;
    }

    .nav3 {
    height: auto;
    width: 100px;
    padding-left: 20px;
    font-family: Arial, Helvetica, sans-serif;
    font-size: 12px;
    padding-top: 20px;
    padding-right: 20px;
    padding-left: 20px;
    margin: 0 auto;
}

  </style>

  <body>

    <p style="font-size:50px"> WoW </p>
    <p style="font-size:20px">
                               E\' molto frequente che ci si trovi a cercare un luogo dove far festa, passare una piacevole serata, pranzare con gli amici, fare un aperitivo o una semplice colazione.
                               <br> WoW rende piu\' semplice questa ricerca e permettera alle persone di trovare il vostro locale in modo rapido e gratuito. <br>
                               WoW e la nuova app che vi permette di condividere e pubblicizzare il vostro locale e gli eventi che organizzate! <br>
                               E\' studiata appositamente per essere semplice e intuitiva da utilizzare ed e proprio questo che vi permettera\' di far conoscere al meglio la vostra attivita\'.
                               <br> Inserire un locale o un evento e rapido e completamente gratuito, basta scaricare l\' app e registrarsi.
    </p>

    <a href="http://itunes.apple.com/us/app/WoW./id1453280714">
      <div class="appStore"></div>
  </a>

  <div class="nav3">
    <a href="https://www.instagram.com/finix_wow/"><img src="https://finixinc.com/wow_resources/insta_icon.png" width="40"></a>
    <img src="">
    <a href="https://finix147.wixsite.com/finix"><img src="https://finixinc.com/wow_resources/finix.png" width="40"></a>
  </div>

  <p> Finix </p>
  <p style="font-size: 12px"> &copy; Gianfranco Putelli </p>

  </body>

</html>
';

$headers = 'From: finix@finixinc.com' . "\r\n" .
    'Reply-To: finix@finixinc.com' . "\r\n" .
$headers .= "MIME-Version: 1.0\r\n";
$headers .= "Content-Type: text/html; charset=UTF-8\r\n";

mail($to, $subject, $message, $headers);