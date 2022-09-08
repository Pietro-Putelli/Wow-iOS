$(document).ready(function() {
    $('#sidebarCollapse').on('click', function() {
        if ($('#sidebar').hasClass('active')) {
            $('#sidebar').toggleClass('active');
            $(this).toggleClass('active');
        }else if ($('.reverseDisappearance').is(':visible') && $('.disappearance').is(":hidden")) {
            $('#sidebar').toggleClass('active');
            $(this).toggleClass('active');
        }else if($('.disappearance').is(":visible")) {
            $('.disappearance').addClass('d-none');
            $('.reverseDisappearance').removeClass("d-none");
         }
    });
});

// Initialize and add the map
function initMap() {
    // The location of italy
    var italy = {
        lat: 41.902701,
        lng: 12.496249
    };

    // The map
    var myStyle = [
        {
            featureType: "poi",
            elementType: "labels",
            stylers: [
                {
                    visibility: "off"
                }
         ]
       },{
            featureType: "road",
            elementType: "labels",
            stylers: [
                { 
                    visibility: "off" 
                }
            ]
        }
     ];

    var map = new google.maps.Map(
        document.getElementById('map'), {
            mapTypeControlOptions: {
                mapTypeIds: ['mystyle'],
                position: google.maps.ControlPosition.LEFT_BOTTOM
            },
            mapTypeId: 'mystyle',
            zoom: 6,
            center: italy,
            zoomControl: true,
            mapTypeControl: false,
            scaleControl: true,
            streetViewControl: false,
            rotateControl: true,
            fullscreenControl: false,
            minZoom: 3
        });

    map.mapTypes.set('mystyle', new google.maps.StyledMapType(myStyle, {
        name: 'My Style'
    }));

    //Geolocation
    infoWindow = new google.maps.InfoWindow;

    if (navigator.geolocation) {

        navigator.geolocation.getCurrentPosition(function (position) {
            
            var loading = document.getElementById('loading');

            loading.innerHTML = 'Searching your position';

            var pos = {
                lat: position.coords.latitude,
                lng: position.coords.longitude
            };

            infoWindow.setPosition(pos);
            infoWindow.setContent('Your location');
            infoWindow.open(map);
            map.setCenter(pos);

            var marker = new google.maps.Marker({
                animation: google.maps.Animation.DROP,
                position: pos,
                map: map,
                icon: 'images/position_marker.png',
                
            });
            
            
            var slider = document.getElementById("customRange");
            var output = document.getElementById("distance");
            output.innerHTML = slider.value;
            var maxdistance = slider.value;
            slider.oninput = function() {
                output.innerHTML = this.value + ' Km';
                var maxdistance = slider.value;
                //console.log(maxdistance);
            };
            
            $.ajax({
                
				type: "POST",
				url: "../php/local_area_get_web.php",
				data: {
					latitudeFrom: pos.lat,
                    longitudeFrom: pos.lng,
                    maxDistance: maxdistance
				},
				success: function (r) {
               },
				error: function (jqXHR, textStatus, errorThrown) {
                   alert("local error");
				}
			}).done(function (data) {
				data = JSON.parse(data);
				console.log(data);
			
				for (i=0;i<data.length;i++) {
				    
				    var jsonData = JSON.parse(data[i][3]);
				    var myLatLng = {lat: parseFloat(data[i][1]), lng: parseFloat(data[i][2])};
				    
				    var markers = new google.maps.Marker({
                        animation: google.maps.Animation.DROP,
                        position: myLatLng,
                        map: map,
                        label: {
                            marginLeft: '-20px',
                            text: jsonData.title,
                        },
                        icon: {
                            labelOrigin: new google.maps.Point(16, 40),
                            url: 'images/local_marker.png',
                        },
                        id: data[i][0],
                        city: jsonData.city,
                        subtitle: jsonData.subtitle,
                        address: jsonData.address,
                        details: jsonData.details,
                        phoneNumber: jsonData.phoneNumber,
                        email: jsonData.email,
                        localWebSite: jsonData.webSite,
                        distance: data[i][4],
                        timetable: jsonData.timetable
                    });
                    
                    $('#localListContainer').append('<div class="reverseDisappearance localList"><div class="col-md-12 localContainer"><div class="localsDivImage"><img class="rounded mx-auto d-block localsImage" src="images/app-icon2.png"></div><div class="row"><div class="localListTitle col-md-12">'+jsonData.title+'</div></div><div class="row"><span class="col-md-6"><span class="localListSubtitle">'+jsonData.subtitle+'</span></span><span class="col-md-6">'+jsonData.city+'</span></div><div class="row"><div class="col-md-12"><span>Today: </span><span class="openOrClosed"></span></div></div></div></div>');
                    console.log(this);
                    $('.localList').on('click', function() {
                        $('.disappearance').removeClass('d-none');
                        $('.reverseDisappearance').addClass('d-none');
                        $('.localEventName').text(markers.label.text);
                        $('.localEventSubtitles').text(markers.subtitle);
                        $('.city').text(markers.city);
                        $('.street').text(markers.address);
                        $('.description').text(markers.details);
                        $('.localTelephone').text(markers.phoneNumber);
                        $('.localEmail').text(markers.email);
                        $('.localWebSite').text(markers.localWebSite);
                        $('.monday1').text(markers.timetable[0]);
                        $('.monday2').text(markers.timetable[1]);
                        $('.tuesday1').text(markers.timetable[2]);
                        $('.tuesday2').text(markers.timetable[3]);
                        $('.wednesday1').text(markers.timetable[4]);
                        $('.wednesday2').text(markers.timetable[5]);
                        $('.thursday1').text(markers.timetable[6]);
                        $('.thursday2').text(markers.timetable[7]);
                        $('.friday1').text(markers.timetable[8]);
                        $('.friday2').text(markers.timetable[9]);
                        $('.saturday1').text(markers.timetable[10]);
                        $('.saturday2').text(markers.timetable[11]);
                        $('.sunday1').text(markers.timetable[12]);
                        $('.sunday2').text(markers.timetable[13]);
                    });
                  
               
         
                    markers.addListener('click', function () {
                        $('.localEventName').text(this.label.text);
                        $('.localEventSubtitles').text(this.subtitle);
                        $('.city').text(this.city);
                        $('.street').text(this.address);
                        $('.description').text(this.details);
                        $('.localTelephone').text(this.phoneNumber);
                        $('.localEmail').text(this.email);
                        $('.localWebSite').text(this.localWebSite);
                        $('.monday1').text(this.timetable[0]);
                        $('.monday2').text(this.timetable[1]);
                        $('.tuesday1').text(this.timetable[2]);
                        $('.tuesday2').text(this.timetable[3]);
                        $('.wednesday1').text(this.timetable[4]);
                        $('.wednesday2').text(this.timetable[5]);
                        $('.thursday1').text(this.timetable[6]);
                        $('.thursday2').text(this.timetable[7]);
                        $('.friday1').text(this.timetable[8]);
                        $('.friday2').text(this.timetable[9]);
                        $('.saturday1').text(this.timetable[10]);
                        $('.saturday2').text(this.timetable[11]);
                        $('.sunday1').text(this.timetable[12]);
                        $('.sunday2').text(this.timetable[13]);
                        
                        if($('#sidebar').hasClass('active') && $('.reverseDisappearance').is(':visible')) {
                            $('#sidebar').removeClass('active');
                            $('#sidebarCollapse').removeClass('active');
                            $('.disappearance').removeClass('d-none');
                            $('.reverseDisappearance').addClass('d-none');
                        }else if($('.reverseDisappearance').is(':visible')) {
                            $('.disappearance').removeClass('d-none');
                            $('.reverseDisappearance').addClass('d-none');
                        }
                        
                        if(this.phoneNumber.length == 0) {
                            $('.localTelephone').addClass('d-none');
                        }
                        if(this.email.length == 0) {
                            $('.localEmail').addClass('d-none');
                        }
                        if(this.localWebSite.length == 0) {
                            $('.localWebSite').addClass('d-none');
                        }
                    });
				}
			});
            $.ajax({
                
				type: "POST",
				url: "../php/event_area_get_web.php",
				data: {
					latitudeFrom: pos.lat,
                    longitudeFrom: pos.lng,
                    maxDistance: maxdistance
				},
				success: function (r) {
               },
				error: function (jqXHR, textStatus, errorThrown) {
                   alert("local error");
				}
			}).done(function (data) {
				data = JSON.parse(data);
				console.log(data);
			
				for (i=0;i<data.length;i++)
				{
				    console.log(data[i][3]);
				    
				    var jsonData = JSON.parse(data[i][3]);
                    m.push(JSON.parse(data[i][3]));
				    var myLatLng = {lat: parseFloat(data[i][1]), lng: parseFloat(data[i][2])};
				    
				    var markers = new google.maps.Marker({
                        animation: google.maps.Animation.DROP,
                        position: myLatLng,
                        map: map,
                        label: {
                            marginLeft: '-20px',
                            text: jsonData.title,
                        },
                        icon: {
                            labelOrigin: new google.maps.Point(16, 40),
                            url: 'images/local_marker.png',
                        },
                        /*id: data[i][0],
                        city: jsonData.city,
                        subtitle: jsonData.subtitle,
                        address: jsonData.address,
                        details: jsonData.details,
                        phoneNumber: jsonData.phoneNumber,
                        email: jsonData.email,
                        localWebSite: jsonData.webSite,
                        distance: data[i][4],
                        timetable: jsonData.timetable*/
                    });
                    
                    /*$('#localListContainer').append('<div class="reverseDisappearance localList"><div class="col-md-12 localContainer"><div class="localsDivImage"><img class="rounded mx-auto d-block localsImage" src="images/app-icon2.png"></div><div class="row"><div class="localListTitle col-md-12">'+jsonData.title+'</div></div><div class="row"><span class="localListSubtitle col-md-6">'+jsonData.subtitle+'</span><span class="col-md-6">'+jsonData.city+'</span></div><div class="row"><div class="col-md-12"><span>Today: </span><span class="openOrClosed"></span></div></div></div></div>');
                    
                    $('.localList').on('click', function() {
                        $('.disappearance').removeClass('d-none');
                        $('.reverseDisappearance').addClass('d-none');
                        $('.localEventName').text(markers.label.text);
                        $('.localEventSubtitles').text(markers.subtitle);
                        $('.city').text(markers.city);
                        $('.street').text(markers.address);
                        $('.description').text(markers.details);
                        $('.localTelephone').text(markers.phoneNumber);
                        $('.localEmail').text(markers.email);
                        $('.localWebSite').text(markers.localWebSite);
                        $('.monday1').text(markers.timetable[0]);
                        $('.monday2').text(markers.timetable[1]);
                        $('.tuesday1').text(markers.timetable[2]);
                        $('.tuesday2').text(markers.timetable[3]);
                        $('.wednesday1').text(markers.timetable[4]);
                        $('.wednesday2').text(markers.timetable[5]);
                        $('.thursday1').text(markers.timetable[6]);
                        $('.thursday2').text(markers.timetable[7]);
                        $('.friday1').text(markers.timetable[8]);
                        $('.friday2').text(markers.timetable[9]);
                        $('.saturday1').text(markers.timetable[10]);
                        $('.saturday2').text(markers.timetable[11]);
                        $('.sunday1').text(markers.timetable[12]);
                        $('.sunday2').text(markers.timetable[13]);
                    });
                  
               
         
                    markers.addListener('click', function () {
                        $('.localEventName').text(this.label.text);
                        $('.localEventSubtitles').text(this.subtitle);
                        $('.city').text(this.city);
                        $('.street').text(this.address);
                        $('.description').text(this.details);
                        $('.localTelephone').text(this.phoneNumber);
                        $('.localEmail').text(this.email);
                        $('.localWebSite').text(this.localWebSite);
                        $('.monday1').text(this.timetable[0]);
                        $('.monday2').text(this.timetable[1]);
                        $('.tuesday1').text(this.timetable[2]);
                        $('.tuesday2').text(this.timetable[3]);
                        $('.wednesday1').text(this.timetable[4]);
                        $('.wednesday2').text(this.timetable[5]);
                        $('.thursday1').text(this.timetable[6]);
                        $('.thursday2').text(this.timetable[7]);
                        $('.friday1').text(this.timetable[8]);
                        $('.friday2').text(this.timetable[9]);
                        $('.saturday1').text(this.timetable[10]);
                        $('.saturday2').text(this.timetable[11]);
                        $('.sunday1').text(this.timetable[12]);
                        $('.sunday2').text(this.timetable[13]);
                        
                        if($('#sidebar').hasClass('active') && $('.reverseDisappearance').is(':visible')) {
                            $('#sidebar').removeClass('active');
                            $('#sidebarCollapse').removeClass('active');
                            $('.disappearance').removeClass('d-none');
                            $('.reverseDisappearance').addClass('d-none');
                        }else if($('.reverseDisappearance').is(':visible')) {
                            $('.disappearance').removeClass('d-none');
                            $('.reverseDisappearance').addClass('d-none');
                        }
                        
                        if(this.phoneNumber.length == 0) {
                            $('.localTelephone').addClass('d-none');
                        }
                        if(this.email.length == 0) {
                            $('.localEmail').addClass('d-none');
                        }
                        if(this.localWebSite.length == 0) {
                            $('.localWebSite').addClass('d-none');
                        }
                    });*/
				}
			});
            
                    

            map.setZoom(12);

            $("#start").fadeOut(3000);

            
        }, function (error) {

            switch (error.code) {
                case error.POSITION_UNAVAILABLE:
                    alert("Location information is unavailable.")
                    break;
                case error.TIMEOUT:
                    alert("The request to get user location timed out.")
                    break;
                case error.UNKNOWN_ERROR:
                    alert("An unknown error occurred.")
                    break;

            }



            handleLocationError(true, infoWindow, map.getCenter());
        });
    } else {
        // Browser doesn't support Geolocation
        handleLocationError(false, infoWindow, map.getCenter());

    }
}


function handleLocationError(browserHasGeolocation, infoWindow, pos) {
    infoWindow.setPosition(pos);
    infoWindow.setContent(browserHasGeolocation ?
        'Error: The Geolocation service failed.' :
        'Error: Your browser doesn\'t support geolocation.');
    $("#start").fadeOut(3000);
    infoWindow.open(map);
}



// Mobile
function detectBrowser() {
    var useragent = navigator.userAgent;
    var mapdiv = document.getElementById("map");

    if (useragent.indexOf('iPhone') != -1 || useragent.indexOf('Android') != -1) {
        mapdiv.style.width = '100%';
        mapdiv.style.height = '100%';
    } else {
        mapdiv.style.width = '600px';
        mapdiv.style.height = '800px';
    }
}