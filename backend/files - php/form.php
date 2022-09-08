

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cloud Vision Demo</title>

    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

	<link href='https://fonts.googleapis.com/css?family=Lato:100,100italic,300,300italic,400,400italic,700,700italic,900,900italic' rel='stylesheet' type='text/css'>

	<link href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css' rel='stylesheet' type='text/css'>

     <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">




    <script src="https://code.jquery.com/jquery-2.1.1.min.js" type="text/javascript"></script>

    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js" integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU=" crossorigin="anonymous"></script>

    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>




</head>
<body>



	
<div class="container-fluid">
	<div class="row">
		<div class="col-sm-offset-3 col-sm-6">

          
             <form id=""  action="getEventsArea.php" method="post" >
                <p id="scegliImmagine">Seleziona unimamgine da caricare:</p>
                <div class="row">

                <div class="col-sm-offset-3 col-sm-6" style="text-align: center">
                    Latitude
                    <input type="number" name="latitude"  id="latitude" step="any" class="btn btn-default btn-file">
                    <br>
                    Longitude
                    <input type="number" name="longitude" step="any" id="longitude" class="btn btn-default btn-file">

                    <input type="submit" value="Invia" name="submit" id="submit" >
                </div>
                </div>
                <br>

               

            




              </form>
        </div>
    </div>

</div>






</body>
</html>


