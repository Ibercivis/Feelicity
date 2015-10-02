var map;

init = function(){
	$('#map').append($('<img src="http://maps.google.com/maps/api/staticmap?center=' + $('#latitude').attr('value') + ',' + $('#longitude').attr('value') +
				'&zoom=14&size=400x300&maptype=hybrid&markers=icon:http://www.tedx.com/images/red_marker.png|shadow:true|'
				+ $('#latitude').attr('value') + ',' + $('#longitude').attr('value') + '&sensor=false"/>'));
}

notify = function(){
	$('#loading_div').show();
    $('#register_div').hide();
	$.ajax({
		url: '/notification/notify',
	    type: 'GET',
	    async: true,
	    cache: false,
	    data: {
	    	'receivers': $('#receivers').attr('value'),
			'message': $('#message').attr('value'),
			'element_id': $('#element_id').attr('value')
		},
	    success: function(responseText){
	    	var response = $.parseJSON(responseText);
	        if (response.status == 'OK') {
				tedx_alert(_("notification_sent"));
				window.location = '/';
	        }
	        else {
	            tedx_alert(response.message);
	        }
	    }
	});
}


