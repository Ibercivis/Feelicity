var map;
var markers_array = new Array();
var drawn_places = new Array();
var infowindow = new google.maps.InfoWindow();

var precision = 6;
var max_zoom = 17;

var green_marker = new google.maps.MarkerImage("/images/icono-maps.png", new google.maps.Size(30, 45), new google.maps.Point(0, 0), new google.maps.Point(15, 25));
var red_marker = new google.maps.MarkerImage("/images/icono-maps.png", new google.maps.Size(30, 45), new google.maps.Point(0, 0), new google.maps.Point(15, 25));

var geolocated = false;
var current_position_marker;
var refresh_location_timer;
var refresh_location_delay = 60000;
var geolocation_error_timeout = 60000;

// get_places variables
var list_mode = false;
var places_request;

var mode = "map";
var search_type = "places";
var result_type = "places";
var search_string = "";
var max_latitude = 90;
var max_longitude = 180;
var min_latitude = -90;
var min_longitude = -180;

var global_places;

var profile_id = "";
var latitude;
var longitude;
var range_query = false;
var order = "date";
var page = 1;
var page_size = 300;

var image_extensions = {
    '.bm': true,
    '.bmp': true,
    '.ras': true,
    '.rast': true,
    '.fif': true,
    '.flo': true,
    '.turb': true,
    '.g3': true,
    '.gif': true,
    '.ief': true,
    '.iefs': true,
    '.jfif': true,
    '.jpe': true,
    '.jpeg': true,
    '.jpg': true,
    '.jut': true,
    '.nap': true,
    '.napl': true,
    '.pic': true,
    '.pict': true,
    '.jfif': true,
    '.jpe': true,
    '.jpeg': true,
    '.jpg': true,
    '.png': true,
    '.x-pn': true,
    '.tif': true,
    '.tiff': true,
    '.mcf': true,
    '.dwg': true,
    '.dxf': true,
    '.svf': true,
    '.fpx': true,
    '.fpx': true,
    '.rf': true,
    '.rp': true,
    '.wbmp': true,
    '.xif': true,
    '.ras': true,
    '.dwg': true,
    '.dxf': true,
    '.svf': true,
    '.ico': true,
    '.art': true,
    '.jps': true,
    '.nif': true,
    '.niff': true,
    '.pcx': true,
    '.pct': true,
    '.pnm': true,
    '.pbm': true,
    '.pgm': true,
    '.pgm': true,
    '.ppm': true,
    '.qif': true,
    '.qti': true,
    '.qtif': true,
    '.rgb': true,
    '.tif': true,
    '.tiff': true,
    '.bmp': true,
    '.xbm': true,
    '.xbm': true,
    '.pm': true,
    '.xpm': true,
    '.xwd': true,
    '.xwd': true,
    '.xbm': true,
    '.xpm': true
};

var video_extensions = {
    '.3gp': true,
    '.afl': true,
    '.asf': true,
    '.avi': true,
    '.avs': true,
    '.dl': true,
    '.fli': true,
    '.flv': true,
    '.gl': true,
    '.m1v': true,
    '.m2v': true,
    '.m4v': true,
    '.mkv': true,
    '.mov': true,
    '.mp2': true,
    '.mp3': true,
    '.mp4': true,
    '.mpa': true,
    '.mpe': true,
    '.mpeg': true,
    '.mpg': true,
    '.avi': true,
    '.moov': true,
    '.mov': true,
    '.qt': true,
    '.vdo': true,
    '.viv': true,
    '.vivo': true,
    '.rv': true,
    '.viv': true,
    '.vivo': true,
    '.vos': true,
    '.wmv': true,
    '.xdr': true,
    '.xsr': true,
    '.fmf': true,
    '.dl': true,
    '.dif': true,
    '.dv': true,
    '.fli': true,
    '.gl': true,
    '.isu': true,
    '.mjpg': true,
    '.mp2': true,
    '.mp3': true,
    '.mp2': true,
    '.asf': true,
    '.asx': true,
    '.asx': true,
    '.avi': true,
    '.qtc': true,
    '.scm': true,
    '.movi': true,
    '.mv': true
};

var common_init = function() {
    map = create_map();

    var tiles_listener = google.maps.event.addListener(map, "tilesloaded", function() {
        google.maps.event.removeListener(tiles_listener);

        //get_current_position(on_position_success, on_position_error);
        //refresh_location_timer = setInterval('get_current_position(refresh_position);', refresh_location_delay);

        google.maps.event.addListener(map, 'click', function(event) {
            clearInterval(refresh_location_timer);
            if (current_position_marker) {
                current_position_marker.setPosition(event.latLng);
                latitude = current_position_marker.getPosition().lat().toFixed(precision);
                longitude = current_position_marker.getPosition().lng().toFixed(precision);
            } else {
                latitude = event.latLng.lat();
                longitude = event.latLng.lng();
                show_current_position();
            }
        });
        // Check if the init function exists
        if (typeof init == 'function') {
            init();
        }
    });
    
    get_happy_cities();
    
};

var refresh_results = function() {
    page = 1;
    var latlngbounds = map.getBounds();
    max_latitude = latlngbounds.getNorthEast().lat();
    max_longitude = latlngbounds.getNorthEast().lng();
    min_latitude = latlngbounds.getSouthWest().lat();
    min_longitude = latlngbounds.getSouthWest().lng();
    get_places();
};

var refresh_position = function(p) {
    if (current_position_marker != null) {
        latitude = p.coords.latitude;
        longitude = p.coords.longitude;
        current_position_marker.setPosition(new google.maps.LatLng(latitude, longitude));
    }
};

var on_position_error = function() {
    $.ajax({
        url: '/my_account/get_position',
        type: 'GET',
        async: true,
        cache: false,
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status == 'OK') {
                latitude = response.latitude;
                longitude = response.longitude;
                show_current_position();
            } else {
                tedx_alert(response.message);
            }
        }
    });
};

var on_position_success = function(p) {
    latitude = p.coords.latitude;
    longitude = p.coords.longitude;
    show_current_position();
};

var show_current_position = function() {
    geolocated = true;

    if (current_position_marker == null){
	    current_position_marker = create_marker({
	        position: new google.maps.LatLng(latitude,longitude),
	        map: map,
	        title: _("you_are_here"),
	        draggable: true,
	        icon: green_marker,
	        //shadow: marker_shadow,
	        zIndex: 99999
	    }, infowindow, _("you_are_here"));
    }
    var listener = google.maps.event.addListener(current_position_marker, "dragend", function() {
        clearInterval(refresh_location_timer);
        latitude = current_position_marker.getPosition().lat().toFixed(precision);
        longitude = current_position_marker.getPosition().lng().toFixed(precision);
    });
    if (mode == 'map') {
        map.setCenter(current_position_marker.getPosition());
        map.setZoom(max_zoom);
    }
};

var setPos = function(city,country){
	var geocoder = new google.maps.Geocoder();
	var address = city + ' ' + country;
	if (geocoder) {
		geocoder.geocode( { 'address': address}, function(results, status) {
	    if (status == google.maps.GeocoderStatus.OK) {
	          map.setCenter(results[0].geometry.location);
	          map.setZoom(13);
	      	  refresh_results();
	    } else {
	          alert("Geocode was not successful for the following reason: " + status);
	    }
		});
	}
}

var view_more = function() {
	var results = global_places.results;
	$('#list').empty();
	for (var i = 0; i < results.length; i++) {
		var div = $('<div class="item"></div>');
		// Avatar
		div.append($('<div style="width:70px;float:left;"><img src="' + results[i].avatar + '_small.png?d='+ new Date().getTime()+'"/></div>'));
		// User name
		div.append($('<a href="'+results[i].user_name+'">'+ results[i].user_name +'</a>'));
		// Instant title
		div.append($('<a href="/view/place?id=' + results[i].place_id +'"><h4>'+ results[i].place_name +'</h4></a>'));
		// Instant description
		div.append($('<p>'+ results[i].comment_content+'</p>'));
		// Instant date
		var div2 = $('<div class="momentoCont left clear"><p class="clear">'+ results[i].last_update +'</p></div>');
		// Number of comments, likes and visits
		var ul = $('<ul class="clear"></ul>');
		if (results[i].num_comments != "1") {
			ul.append($('<li style="width:85px;"><a href="/view/place?id=' + results[i].place_id +'">' + results[i].num_comments + ' ' +_("comments") +'</a></li>'));
		} else {
			ul.append($('<li style="width:85px;"><a href="/view/place?id=' + results[i].place_id +'">' + results[i].num_comments + ' ' +_("comment") +'</a></li>'));
		}
		ul.append($('<li style="width:65px;"><a href="#" onclick="add_place_scoring_home(\''+results[i].place_id+'\',1);">' + results[i].positive_scorings + ' '  +_("like") +' </a></li>'));
		if (results[i].visits != "1") {
			ul.append($('<li style="width:85px;"><div style="padding-left:5px;" >' + results[i].visits + ' ' +_("visits") +'</div></li>'));
		} else {
			ul.append($('<li style="width:85px;"><div style="padding-left:5px;" >' + results[i].visits + ' ' +_("visit") +'</div></li>'));
		}
		div2.append(ul);
		div.append(div2);

		$('#list').append(div);
	}
};

var get_places = function() {
    if (places_request) {
        places_request.abort();
    }
    $('#search_title').empty();
    $('#search_title').append($('<div><img src="/images/loading.gif" />' + _('searching_for_results') + '</div>'));
    
    places_request = $.ajax({
        url: '/home/search',
        type: 'GET',
        async: true,
        cache: false,
        data: {
            'mode':  mode,
            'search_type':  search_type,
            'result_type':  result_type,
            'search_string': search_string,
            'max_latitude': max_latitude,
            'min_latitude': min_latitude,
            'max_longitude': max_longitude,
            'min_longitude': min_longitude,
            'profile_id': profile_id,
            'latitude' : latitude,
            'longitude' : longitude,
            'range_query' : range_query,
            'order': order,
            'page': page,
            'page_size': page_size
        },
        success: function(responseText) {
            //delete_overlays(markers_array);
            var response = $.parseJSON(responseText);
            global_places = response;
            if (response.status == 'OK') {
                $('#search_title').empty();

                var results = response.results;
                var users = response.users;
                
                if (users.length > 0 && mode != "place"){
		    	    $('#users').empty();
		    	    
		    	    // Happy users (left bar)
		    	    for (i = 0; i< users.length; i++){
		    	    	var div = $('<div class="item left"><div style="width:70px;float:left;"><img src="'+users[i].user_avatar+'_small.png?d='+ new Date().getTime()+'" class="left"/></div><a href="'+users[i].user_name+'">'+users[i].user_name+'</a><p>' +_("has_uploaded") + " " + users[i].user_contents+ " " + _("contents") +' </p></div>');
		    	    	$('#users').append(div);
		    	    }
                }

            if (results.length > 0) {
                if (list_mode) {
                	// Results message
                    $("#list").show();
                    switch (mode) {
                    	case 'search':
                    		$('#search_title').html(response.num_results + " " + _("results_found_for") + ": " + $('#search_string').attr('value'));
                    		break;
                    	default:
                    		$('#search_title').html(response.num_results + " " + _("results_found_in_this_map_area"));
                    	break;
                    }

                    // Create the page controls
                    $('#srToolsDown').empty();

                    if (response.current_page > 1 && response.pages > 1) {
                        $('#srToolsDown').append($('<a class="estiloAzul" href="javascript:void(0);" onclick="get_page(1);"><<</a> <a class="estiloAzul" href="javascript:void(0);" onclick="get_page(' + (response.current_page - 1) + ');"><</a>'));
                        $('#srToolsDown').append(' ');
                    }

                    $('#srToolsDown').append(' ' + _('page') + ': ');
                    $('#srToolsDown').append($('<input type="text" size="1" value="' + response.current_page + '" onchange="get_page(this.value);"/>'));
                    $('#srToolsDown').append(' ' + _('of') + ' ' + response.pages + ' ');

                    if (response.current_page < response.pages && response.pages > 1) {
                        $('#srToolsDown').append(' ');
                        $('#srToolsDown').append($('<a class="estiloAzul" href="javascript:void(0);" onclick="get_page(' + (response.current_page + 1) + ');">></a> <a class="estiloAzul" href="javascript:void(0);" onclick="get_page(' + response.pages + ');">>></a>'));
                    }

                    $('#srToolsDown').append($('<input type="text" size="1" value="' + page_size + '" onchange="get_page_size(this.value);"/>'));
                    $('#srToolsDown').append(' ' + _('results_per_page'));
                    
                    // List elements
                    var tbody = $("#list").find('tbody');
                        $("#list").trigger('update');
                        tbody.empty();
                } else {
                    if (response.current_page < response.pages && response.pages > 1) {
                        $('#VerMas').show();
                    } else {
                        $('#VerMas').hide();
                    }
                }

                $('#list').empty();
                for (var i = 0; i < results.length; i++) {
                    	// Happy instants (middle bar)
                    	if (list_mode && i<10) {
                    		div = $('<div class="item"></div>');
                    		// Avatar
                    		div.append($('<div style="width:70px;float:left;"><img src="' + results[i].avatar + '_small.png?d='+ new Date().getTime()+'"/></div>'));
                    		// User name
                    		div.append($('<a href="'+results[i].user_name+'">'+ results[i].user_name +'</a>'));
                    		// Instant title
                    		div.append($('<a href="/view/place?id=' + results[i].place_id +'"><h4>'+ results[i].place_name +'</h4></a>'));
                    		// Instant description
                    		div.append($('<p>'+ results[i].comment_content+'</p>'));
                    		// Instant date
                    		var div2 = $('<div class="momentoCont left clear"><p class="clear">'+ results[i].last_update +'</p></div>');
                    		// Number of comments, likes and visits
                    		var ul = $('<ul class="clear"></ul>');
                    		if (results[i].num_comments != "1") {
                    			ul.append($('<li style="width:85px;"><a href="/view/place?id=' + results[i].place_id +'">' + results[i].num_comments + ' ' +_("comments") +'</a></li>'));
                    		} else {
                    			ul.append($('<li style="width:85px;"><a href="/view/place?id=' + results[i].place_id +'">' + results[i].num_comments + ' ' +_("comment") +'</a></li>'));
                    		}
                    		ul.append($('<li style="width:65px;"><a href="#" onclick="add_place_scoring_home(\''+results[i].place_id+'\',1);">' + results[i].positive_scorings + ' '  +_("like") +' </a></li>'));
                    		if (results[i].visits != "1") {
                    			ul.append($('<li style="width:85px;"><div style="padding-left:5px;" >' + results[i].visits + ' ' +_("visits") +'</div></li>'));
                    		} else {
                    			ul.append($('<li style="width:85px;"><div style="padding-left:5px;" >' + results[i].visits + ' ' +_("visit") +'</div></li>'));
                    		}
                    		div2.append(ul);
                    		div.append(div2);
	        	    
                    		$('#list').append(div);
                    	}
                    	
                    	
                        // Place marker html
                        if (results[i].place_id != "") {
                            name = '<a class="estiloAzul" href="/view/place?id=' + results[i].place_id + '&latitude=' + latitude + '&longitude=' + longitude + '">' + results[i].place_name + '</a>';
                        } else {
                            name = results[i].place_name;
                        }
                        var html = '<table>\
                        <tr><td colspan="2">'+
                        name+'</td></tr>\
                        <tr><td><b>' +
                        _("author") +
                        ':</b></td><td><a class="estiloAzul" href="/' + results[i].user_name + '">' +
                        results[i].user_name +
                        '</a></td></tr>';

                        

                        html += '<tr><td><b>' +
                        _("last_update") +
                        ':</b></td><td>' +
                        results[i].last_update +
                        ' por ' +
                        results[i].last_updater_name +
                        '</td></tr>\
                        <tr><td><b>' +
                        _("comments") +
                        ':</b></td><td>' +
                        results[i].num_comments +
                        '</td></tr>\
                        <tr><td><b>' +
                        _("visits") +
                        ':</b></td><td>' +
                        results[i].visits +
                        '</td></tr>\
                        <tr><td><b>' +
                        _("scoring") +
                        ':</b></td><td>0</td></tr>';
                        
                        if (results[i].comment_image != null){
                        	html += '<tr><td><img src ="' + results[i].comment_image +'_small.jpg"/></td></tr>\
                        	</table>';
                        } else {
                        	html += '</table>';
                        }
                        

                        // Place the instant on the google map ???
                        var marker = drawn_places[results[i].place_id];
                        if (marker == undefined) {
                            marker = red_marker;
                            
                            marker = create_marker({
                                position: new google.maps.LatLng(results[i].latitude, results[i].longitude),
                                icon: marker,
                                map: map
                            }, infowindow, html);
                            markers_array.push(marker);

                            drawn_places[results[i].place_id] = marker;
                        }

                        if (list_mode) {
                            var context = {
                                id: results[i].place_id,
                                marker: marker
                            };

                            var handler = function( event ) {
                                google.maps.event.trigger(this.marker, 'click');
                                $('html, body').animate({scrollTop:$('#map').offset().top}, 'slow');
                            };
                        }
                }
                if (results.length > 10) {
            		$('#list').append($('<div class="item"><a href="javascript:void(0);" class="registro bordesoft" style="float:right;color:white;" onclick="view_more();">Ver más</a></div>'));
            	}

                    // If it's the first time we have to try to geolocate the user
                    if (!geolocated || mode != "map") {
                        geolocated = true;
                        if (mode=="search") {
                        	fit_to_bounds();
                        }
                    }
            } else {
                switch (mode) {
                    case 'profile': // No muestra nada porque el search_title no existe
                        $('#search_title').html(_("you_have_no_streetits"));
                        break;
                    case 'search':
                    	$('#list').html(_("no_results_found_for"));
                        break;
                    default: // No muestra nada porque el search_title no existe
                        $('#search_title').html(_("no_results_found_in_this_map_area"));
                        break;
                }
                $('#page_controls_top').empty();
                $('#page_controls_bottom').empty();
            }
            } else {
                tedx_alert(response.message);
            }
        }
    });
};

var get_page = function(new_page) {
    page = new_page;
    get_places();
}

var get_page_size = function(new_page_size) {
    page_size = new_page_size;
    get_places();
}

var tedx_alert = function(message) {
	$('#dialog-content-message').html(message);
	$("#dialog-message").dialog("open");
};

var login = function() {
    $.ajax({
        url: '/common/login',
        type: 'GET',
        async: true,
        cache: false,
        data: {
            'email': $('#login_email').attr('value'),
            'password': $('#login_password').attr('value')
        },
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status == 'OK') {
                window.location = '/';
            } else {
                tedx_alert(response.message);
            }
        }
    });
};

var logout = function() {
    $.ajax({
        url: '/common/logout',
        type: 'GET',
        async: true,
        cache: false,
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status == 'NOK') {
                tedx_alert(response.message);
            }
            window.location = '/';
        }
    });
}


// Forgotten password
$(function() {
    $("#dialog-forgotten-password").dialog({
	modal: true,
	autoOpen: false
    });

    $('#dialog-forgotten-password-btnAccept').button();
    $('#dialog-forgotten-password-imgLoading').hide();
    $('#dialog-forgotten-password-btnAccept').click(function() {
	$('#dialog-forgotten-password-imgLoading').show();
	$.ajax({
	    url: '/common/forgotten_password',
	    type: 'GET',
	    async: true,
	    cache: false,
	    data: { 'email' : $('#dialog-forgotten-password-txtEmail').attr('value') },
	    success: function(responseText) {
		var response = $.parseJSON(responseText);
		if (response.status == 'NOK') {
		    tedx_alert(response.message);
		} else {
		    $("#dialog-forgotten-password").dialog("close");
		    tedx_alert('Se ha enviado el email con la contraseña correctamente.');
		}
		 $('#dialog-forgotten-password-imgLoading').hide();
	    }
	});
    });

    $('#dialog-forgotten-password-btnCancel').button();
    $('#dialog-forgotten-password-btnCancel').click(function() {
	$('#dialog-forgotten-password-imgLoading').hide();
	$("#dialog-forgotten-password").dialog("close");
    });
});

var forgot_password = function() {
    $("#dialog-forgotten-password").dialog("open");
};

// Registration
$(function() {
    $("#dialog-registration").dialog({
	modal: true,
	autoOpen: false
    });

    $('#dialog-registration-btnAccept').button();
    $('#dialog-registration-imgLoading').hide();
    $('#dialog-registration-btnAccept').click(function() {
	if (!$('#dialog-registration-txtEmail').attr('value')) {
	    tedx_alert(_("email_cannot_be_null"));
	    return;
	}
	if (!$('#dialog-registration-txtContra').attr('value')) {
	    tedx_alert(_("password_cannot_be_null"));
	    return;
	}
	if ($('#dialog-registration-txtContra').attr('value') != $('#dialog-registration-txtContraConfirmation').attr('value')) {
	    tedx_alert(_("wrong_password_confirmation"));
	    return;
	}
	if (!$('#dialog-registration-txtNickname').attr('value')) {
	    tedx_alert(_("nickname_cannot_be_null"));
	    return;
	}

	$('#dialog-registration-imgLoading').show();
	$.ajax({
	    url: '/register/save',
	    type: 'GET',
	    async: true,
	    cache: false,
	    data: { 'email' : $('#dialog-registration-txtEmail').attr('value'),
		    'password' : $('#dialog-registration-txtContra').attr('value'),
		    'nickname' : $('#dialog-registration-txtNickname').attr('value'),
		    'sex' : $('input[name=dialog-registration-rdSex]:checked').val()
		  },
	    success: function(responseText) {
		var response = $.parseJSON(responseText);
		if (response.status == 'NOK') {
		    tedx_alert(response.message);
		} else {
		    $("#dialog-registration").dialog("close");
		    tedx_alert(response.message);
		    window.location = '/';
		}
		$('#dialog-registration-imgLoading').hide();
	    }
	});
    });

    $('#dialog-registration-btnCancel').button();
    $('#dialog-registration-btnCancel').click(function() {
	$('#dialog-registration-imgLoading').hide();
	$("#dialog-registration").dialog("close");
    });
});

var register_user = function() {
    $("#dialog-registration").dialog("open");
};

// alert 

$(function() {
	$('#dialog-message-content').html("");
	$("#dialog-message").dialog({
		modal: true,
		autoOpen: false,
		width: "500px"
		
	    });
	    

	$('#dialog-message-btnAccept').button();
	$('#dialog-message-btnAccept').click(function() {
		$("#dialog-message").dialog("close");
	});
});

// Contact
$(function() {
    $("#dialog-contact").dialog({
	modal: true,
	autoOpen: false
    });

    $('#dialog-contact-btnAccept').button();
    $('#dialog-contact-imgLoading').hide();
    $('#dialog-contact-btnAccept').click(function() {
	if (!$('#dialog-contact-txtEmail').attr('value')) {
	    tedx_alert(_("email_cannot_be_null"));
	    return;
	}

	$('#dialog-contact-imgLoading').show();
	$.ajax({
	    url: '/common/contact',
	    type: 'GET',
	    async: true,
	    cache: false,
	    data: { 'email' : $('#dialog-contact-txtEmail').attr('value'),
		    'name' : $('#dialog-contact-txtName').attr('value'),
		    'content' : $('#dialog-contact-txtContent').attr('value')
		  },
	    success: function(responseText) {
		var response = $.parseJSON(responseText);
		if (response.status == 'NOK') {
		    tedx_alert(response.message);
		} else {
		    $("#dialog-contact").dialog("close");
		    $('#dialog-contact-txtEmail').val('');
		    $('#dialog-contact-txtName').val('');
		    $('#dialog-contact-txtContent').val('');
		    tedx_alert(response.message);
		}
		$('#dialog-contact-imgLoading').hide();
	    }
	});
    });

    $('#dialog-contact-btnCancel').button();
    $('#dialog-contact-btnCancel').click(function() {
	$('#dialog-contact-imgLoading').hide();
	$("#dialog-contact").dialog("close");
	$('#dialog-contact-txtEmail').val('');
	$('#dialog-contact-txtName').val('');
	$('#dialog-contact-txtContent').val('');
    });
});

var send_contact_message = function() {
    $("#dialog-contact").dialog("open");
};

// Team and about
$(function() {
    $("#dialog-team").dialog({
	modal: true,
	autoOpen: false,
	width: "700px"
	
    });
    $("#dialog-about").dialog({
	modal: true,
	autoOpen: false,
	width: "700px"
    });

    $('#dialog-team-btnAccept').button();
    $('#dialog-team-btnAccept').click(function() {
	$("#dialog-team").dialog("close");
    });

    $('#dialog-about-btnAccept').button();
    $('#dialog-about-btnAccept').click(function() {
	$("#dialog-about").dialog("close");
    });

    $('#dialog-disclaimer').dialog({
	modal: true,
	autoOpen: false,
	width: "700px"
    });

    $('#dialog-more-info').dialog({
	modal: true,
	autoOpen: false,
	width: "700px"
    });
});

var open_team_dialog = function() {
    $("#dialog-team").dialog("open");
};

var open_about_dialog = function() {
    $("#dialog-about").dialog("open");
};

var open_disclaimer_dialog = function() {
    $("#dialog-disclaimer").dialog("open");
};

var open_more_info_dialog = function() {
    $("#dialog-more-info").dialog("open");
};

// New happy instant
var youtube_link_regex = /^http:\/\/(?:www\.)?youtube.com\/watch\?(?=.*v=\w+)(?:\S+)?/;
$(function() {
    $('#new-instant-form').ajaxForm({
	type: 'post',
	clearForm: true,
	beforeSubmit: function(formData, jqForm, options) {
	    if (!$('#new-instant-txtName').attr('value')) {
		tedx_alert(_("place_name_cannot_be_null"));
		return false;
	    }
	    if (!$('#new-instant-txtDescription').attr('value')) {
		tedx_alert(_("comment_content_cannot_be_null"));
		return false;
	    }
	    
	    if (latitude == null || longitude == null) {
    		tedx_alert(_("location_cannot_be_null"));
    		return false;
	    }
	    
	    var geocoder = new google.maps.Geocoder();
	    var latlng = new google.maps.LatLng(latitude, longitude);
	    if (geocoder) {
		geocoder.geocode({'latLng': latlng}, function(results, status) {
	    	    if (status == google.maps.GeocoderStatus.OK) {
	    		var address = results[0].address_components;
			for (var i = 0; i < address.length; i++) {
	        	    if (address[i].types[0] == "locality"){
	        		$('#new-instant-city').attr('value',address[i].long_name);
	        	    }
	        	    if (address[i].types[0] == "country"){
	        		$('#new-instant-country').attr('value',address[i].long_name);
	        	    }
			}
			
			if ($('#new-instant-youtube').val() != '' && !$('#new-instant-youtube').val().match(youtube_link_regex)) {
			    tedx_alert(_("url_is_not_valid"));
			    return false;
			}
			
			$('#loading_div').show();
			$('#new-instant-btnSend').hide();
			
			return true;
	    	    } else {
			alert("Geocoder failed due to: " + status);
			return false;
	            }
		});
	    }

	    return true;
	},
	success: function(responseText, statusText, xhr, $form) {
	    var response = $.parseJSON(responseText);
	    if (response.status == 'OK') {
		$('#twitter-share-link').attr('href', 'http://twitter.com/share?url=' + escape('http://feelicity.es/view/place?id=' + response.place_id));
		$('#facebook-share-link').attr('href', 'http://facebook.com/sharer.php?u=' + escape('http://feelicity.es/view/place?id=' + response.place_id) + '&t=' + escape('Momento feliz.'));
		$('#notification').fadeToggle('slow');
            } else {
                tedx_alert(response.message);
            }
	    $('#new-instant-btnSend').show();
	}
    });

    $('[placeholder]').focus(function() {
	var input = $(this);
	if (input.val() == input.attr('placeholder')) {
	    input.val('');
	    input.removeClass('placeholder');
	}
    }).blur(function() {
	var input = $(this);
	if (input.val() == '' || input.val() == input.attr('placeholder')) {
	    input.addClass('placeholder');
	    input.val(input.attr('placeholder'));
	}
    }).blur();

    $('a.close').bind('click', function (e) {
        $('#notification').fadeToggle('slow');
        e.preventDefault();
    });
});

var new_happy_instant = function() {
    $('#new-instant-txtLongitude').val(longitude);
    $('#new-instant-txtLatitude').val(latitude);
    $('#new-instant-form').submit();
};

var share_on_twitter = function() {

};

var share_on_facebook = function() {

};



// Search
var search_query = function() {
    search_string = $('#search_string').attr('value');
    if (latitude && longitude && range_query) {
        window.location = "/search?search_string=" + search_string + "&range_query=" + range_query + "&latitude=" + latitude + "&longitude=" + longitude ;
    } else {
        window.location = "/search?search_string=" + search_string;
    }
};

var create_map = function() {
    var myOptions = {
        zoom: 13,
        mapTypeControl: true,
        mapTypeControlOptions: {
            style: google.maps.MapTypeControlStyle.DROPDOWN_MENU,
	    position: google.maps.ControlPosition.BOTTOM_LEFT
        },
        navigationControl: true,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        center: new google.maps.LatLng(41.65, -0.88)
        
    };
    var map = new google.maps.Map($('#map')[0], myOptions);
    google.maps.event.addListenerOnce(map, 'idle', function() {
        for(var it in google.maps.MapTypeId) {
            map.mapTypes[google.maps.MapTypeId[it]].minZoom = 3;
            map.mapTypes[google.maps.MapTypeId[it]].maxZoom = 17;
        }
    });
    return map;
};

var get_current_position = function(on_position_success, on_position_error) {
    if (geo_position_js.init()) {
        geo_position_js.getCurrentPosition(on_position_success, on_position_error, {
            enableHighAccuracy: true,
            timeout: geolocation_error_timeout
        });
    } else {
        on_position_error();
    }
};

var delete_overlays = function() {
    if (markers_array) {
        for (i in markers_array) {
            markers_array[i].setMap(null);
        }
        markers_array = new Array();
        drawn_places = new Array();
    }
};

var create_marker = function(options, infowindow, infowindowHTML) {
    var marker = new google.maps.Marker(options);

    infowindow.close();

    google.maps.event.addListener(marker, 'click', function() {
        infowindow.open(options["map"], marker);
        infowindow.setContent(infowindowHTML);
    });
    return marker;
};

var fit_to_bounds = function() {
    /* Ajustamos el mapa a la extensión de todos los puntos */
    if (markers_array.length > 0) {
        var latlngbounds = new google.maps.LatLngBounds();
        for (var i = 0; i < markers_array.length; i++) {
            latlngbounds.extend(markers_array[i].getPosition());
        }
        map.fitBounds(latlngbounds);
        if (map.getZoom() > max_zoom) {
            map.setZoom(max_zoom);
        }
    }
};

var random_string = function(string_length) {
    if (string_length == null) {
        string_length = 8;
    }
    var chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";
    var randomstring = '';
    for (var i = 0; i < string_length; i++) {
        var rnum = Math.floor(Math.random() * chars.length);
        randomstring += chars.substring(rnum, rnum + 1);
    }
    return randomstring;
};

var _ = function(message) {
    var translated_message = message;
    if (dictionary[message]) {
        translated_message = dictionary[message];
    }
    return translated_message;
};

var change_language = function(lang) {
    $.ajax({
        url: '/common/change_language',
        type: 'GET',
        async: true,
        cache: false,
        data: {
            'selected_lang': lang
        },
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status == 'OK') {
                location.reload(true);
            }
        }
    });
};

var add_place_scoring_home = function(place,value) {
    $.ajax({
        url: '/view/add_place_scoring',
        type: 'GET',
        async: true,
        cache: false,
        data: {
            'place_id': place,
            'value': value
        },
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status == 'OK') {
                tedx_alert(_("scoring_successfully_saved"));
                get_places();
                //get_place_data();
            } else {
                tedx_alert(response.message);
            }
        }
    });
};


var get_tags = function() {
    $.ajax({
        url: '/common/get_tags',
        type: 'GET',
        async: true,
        cache: false,
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status == 'OK') {
                var tags_content = $("#tags_content");
                tags_content.append($('<ul class="xmpl" id="cloud"></ul>'));
                var cloud = $("#cloud");
                for (i = 0; i < response.tags.length; i++) {
                    cloud.append($('<li value="' + response.tags[i].value + '"><a href="javascript:add_tag(\'' + response.tags[i].name + '\')">' + response.tags[i].name + '</a></li>'));
                }
                $("#cloud").tagcloud({
                    type: "sphere",
                    sizemin: 14,
                    sizemax: 30,
                    colormin: "A42A2A",
                    colormax: "A42A2A",
                    height: "100"
                });
            } else {
                tedx_alert(response.message);
            }
        }
    });
};

var get_profile_data = function() {
	$.ajax({
        url: '/my_account/get_stats',
        type: 'GET',
        async: true,
        cache: false,
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status == "OK"){
                //$('#streetits_stats').html(response.places);
            	$('#placesUp').html(_('happy_moments')+' ('+response.places +')');
            	$('#commentsUp').html(_('comments')+' ('+response.comments +')');
            	$('#visitsUp').html(_('visits')+' ('+response.visits +')');
                $('#likeUp').html(response.positive_scorings + " " +_('like'));
                 
                //$('#videos_stats').html(response.videos);
                //$('#images_stats').html(response.images);
                //$('#links_stats').html(response.links);
                //$('#likes').html(response.positive_scorings);
                //$('#negative_scorings_stats').html(response.negative_scorings);
            }
        }
    });
};

var get_happy_cities = function(){
	$.ajax({
        url: '/common/get_happy_cities',
        type: 'GET',
        async: true,
        cache: false,
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status == "OK") {
            	cities = response.cities;
            	var ul = $('<ul></ul>');
        		
            	for (var i=0; i<cities.length; i++){
            		var li = $('<li><a href="javascript:void(0);" onclick="window.location=\'/home?city='+cities[i].city+'&country='+cities[i].country+'\'">'+cities[i].city+'</a></li>');
            		ul.append(li);
            	}
            	
            	$('#happy_cities').append(ul);
            }
        }
    });
};

var delete_place = function(id){
	$.ajax({
        url: '/view/delete_place',
        type: 'GET',
        async: true,
        cache: false,
        data: {
            'id':  id
        },
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status == 'OK') {
            	window.location = "/";
            } else {
                tedx_alert(response.message);
            }
        }
    });
};

var delete_comment = function(id){
	$.ajax({
        url: '/view/delete_comment',
        type: 'GET',
        async: true,
        cache: false,
        data: {
            'id':  id
        },
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status == 'OK') {
            	
                window.location = "/";
            } else {
                tedx_alert(response.message);
            }
        }
    });
};

