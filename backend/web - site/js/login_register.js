function showFunction() {
    var x = document.getElementById("password");
    if (x.type === "password") {
        x.type = "text";
    } else {
        x.type = "password";
    }
}


$(document).on('keydown', '#password', function(e) {
    if (e.keyCode == 32) return false;
});


var checkPass = document.getElementById("password");
checkPass.onkeyup = function() {
    
    var pswd = $('#password').val().replace(/\s+/g, '');
    if (pswd.length >= 8) {
        $("#disabledButton").removeAttr("disabled");
    }else {
        $("#disabledButton").attr("disabled", true);
    }
}