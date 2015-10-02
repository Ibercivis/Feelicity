init = function() {
    get_places();
    
    var dragend_listener = google.maps.event.addListener(map, "dragend", function() {
        refresh_results();
    });
    var zoom_changed_listener = google.maps.event.addListener(map, "zoom_changed", function() {
        refresh_results();
    });
}

/*return the name of the Operative System used by the phone*/
nameSO = function() {
	if(navigator.userAgent.indexOf('Android') != -1)
		{ var OpSys = "Android"; }
	else if(navigator.userAgent.indexOf('iPhone') != -1)
		{ var OpSys = "iPhone"; }
	else if(navigator.userAgent.indexOf('Symbian') != -1)
		{ var OpSys = "Symbian"; }
	else if(navigator.userAgent.indexOf('Blackberry') != -1)
		{ var OpSys = "Blackberry"; }
	else if(navigator.userAgent.indexOf('Win') != -1)
		{ var OpSys = "Windows"; }
	else if(navigator.userAgent.indexOf('Linux') != -1)
	{ var OpSys = "Linux"; }
	else if(navigator.userAgent.indexOf('Mac') != -1)
	{ var OpSys = "Mac"; }
	else { var OpSys = "Other"; }
	return OpSys; 	
}