init = function() {
	if ($("#city").attr('value')!=""){
    	setPos($("#city").attr('value'),$("#country").attr('value'));
    }
    list_mode = true;
    get_comment_tags();
    get_places();
    
    
    var dragend_listener = google.maps.event.addListener(map, "dragend", function() {
        refresh_results();
    });
    var zoom_changed_listener = google.maps.event.addListener(map, "zoom_changed", function() {
        refresh_results();
    });
    // desde view se ha pinchado en ver ciudad feliz que ha redirigido a home con los parámetros de ciudad y país
    
}

get_comment_tags = function() {
    $.ajax({
        url: '/common/get_tags',
        type: 'GET',
        async: true,
        cache: false,
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status == 'OK') {
                var tags_content = $("#contentTags");
                tags_content.append($('<ul style="height:100%;list-style:none outside none; padding:0;" id="cloud"></ul>'));
                var cloud = $("#cloud");
                var max = 0;
                var percent;
                var classtag;
                for (i = 0; i < response.tags.length; i++) {
                		if (response.tags[i].value > max) {
                			max = response.tags[i].value;
                		}
                	    // determine the popularity of this term as a percentage
                	    percent = response.tags[i].value/max * 100;
                	 
                	    // determine the class for this term based on the percentage
                	    if (percent < 20)
                	    {
                	        classtag = 'smallest';
                	    } else if (percent >= 20 && percent < 40) {
                	        classtag = 'small';
                	    } else if (percent >= 40 && percent < 60) {
                	        classtag = 'medium';
                	    } else if (percent >= 60 && percent < 80) {
                	        classtag = 'large';
                	    } else {
                	        classtag = 'largest';
                	    }
                	 
                	    // output this term
                	   
                	
                    cloud.append($('<li   value="' + response.tags[i].value + '"><a class="'+classtag+'" style="text-decoration:none;" href="javascript:add_tag(\'' + response.tags[i].name + '\')">' + response.tags[i].name + '</a></li>'));
                }
                
            } else {
                tedx_alert(response.message);
            }
        }
    });
}