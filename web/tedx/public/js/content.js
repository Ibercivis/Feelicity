var wait_for_file;
var files_ids = new Array();
var place_id;
var city;
var country;
var youtube_exp = /^http:\/\/(?:www\.)?youtube.com\/watch\?(?=.*v=\w+)(?:\S+)?/;

init = function() {
    get_comment_tags();
    
    $('#link').dialog({
        autoOpen: false,
        buttons: {
            "Add": function() {
                if ($('#youtube_link').attr('value').match(youtube_exp)) {
                    var random_id = random_string(3);
                    var type = "youtube";
                    files_ids.push(random_id);
                    var input = '<form id="form' + random_id + '" enctype="multipart/form-data" target="file_upload_iframe" method="post" action="/content/upload_file">' +
			_(type) + ': <input id="' + random_id +	'" type="text"  readonly size="35" value="'+$('#youtube_link').attr('value')+'" name="file"></input>\
<input type="button" onclick="$(\'#form'+random_id+'\').remove();" value="Eliminar"></input>\
<input type="hidden" name="type" value="' + type + '"></input>\
</form>';

                    $(input).appendTo($('#files'));
		    
                    $('#youtube_link').attr('value', '');
                    $('#link').hide();
                } else {
                    tedx_alert(_("url_is_not_valid"));
                }

                $( this ).dialog( "close" );
            },
            Cancel: function() {
                $( this ).dialog( "close" );
            }
        },
    });

}

add_tag = function(tag) {
    strings = $("#place_tags").attr('value').split(' ');
    var found = false;
    for (i = 0; i < strings.length; i++) {
        if (strings[i] == tag) {
            found = true;
        }
    }
    if (!found)
        $("#place_tags").attr('value', $("#place_tags").attr('value') + ' ' + tag);
}

new_place = function() {
	if (!$('#place_name').attr('value')) {
        tedx_alert(_("place_name_cannot_be_null"));
        return;
    }
    if (!$('#comment_content').attr('value')) {
        tedx_alert(_("comment_content_cannot_be_null"));
        return;
    }
    
    if (latitude==null || longitude==null){
    	tedx_alert(_("location_cannot_be_null"));
    	return
    }
    if ($('#checkNotification').attr('checked') == true && !$('#receivers').attr('value')) {
        tedx_alert(_("receivers_cannot_be_null"));
        return
    }
    //$('#loading_div').show();
    //$('#new_place_div').hide();
    var geocoder = new google.maps.Geocoder();
    var latlng = new google.maps.LatLng(latitude, longitude);
    if (geocoder) {
      geocoder.geocode({'latLng': latlng}, function(results, status) {
    	if (status == google.maps.GeocoderStatus.OK) {
          var address = results[0].address_components;
          for (var i=0; i< address.length; i++){
        	  if (address[i].types[0] == "locality"){
        		  $('#city').attr('value',address[i].long_name);
        	  }
        	  if (address[i].types[0] == "country"){
        		  $('#country').attr('value',address[i].long_name);
        	  }
          }
            $.ajax({
	  	        url: '/content/new_place',
	  	        type: 'GET',
	  	        async: true,
	  	        cache: false,
	  	        data: {
	  	            'edit_place_id': edit_place_id,
	  	            'place_name': $('#place_name').attr('value'),
	  	            'latitude': latitude,
	  	            'longitude': longitude,
	  	            'city' : $('#city').attr('value'),
	  	            'country' : $('#country').attr('value'),
	  	            'comment_title': $('#comment_title').attr('value'),
	  	            'comment_content': $('#comment_content').attr('value'),
	  	            'place_category': $('#comment_category').attr('value'),
	  	            'place_tags': $('#place_tags').attr('value'),
	  	            'insitu': $('#check_in_situ').attr('checked'),
	  	            'privacy': $('#check_privacy').attr('checked')
	  	        },
	  	        success: function(responseText) {
	  	            var response = $.parseJSON(responseText);
	  	            if (response.status == 'OK') {
	  	                place_id = response.place_id;
	  	                upload_files(response.comment_id);
	  	            } else {
	  	                tedx_alert(response.message);
	  	                document.location = '/';
	  	            }
	  	        }
	  	    });
        } else {
          alert("Geocoder failed due to: " + status);
        }
      });
    }
}

get_comment_categories = function() {
    $.ajax({
        url: '/category/my_categories',
        type: 'GET',
        async: true,
        cache: false,
        success: function(responseText) {
	    var response = $.parseJSON(responseText);
	    if (response.status == 'OK') {
                var categories = $("#comment_category");
                for (i = 0; i < response.categories.length; i++) {
                    if (response.categories[i].name =="ambar"){
                	categories.append($('<div name="categories" id="' + response.categories[i].id + '" class="yellow_category" title="' + 
					    response.categories[i].name+'" onclick="select_category(\''+response.categories[i].id+'\');"></div>'));
                    } else if (response.categories[i].name="psoe"){
                	categories.append($('<div name="categories" id="' + response.categories[i].id + '" class="red_category" title="' + 
					    response.categories[i].name+'" onclick="select_category(\''+response.categories[i].id+'\');"></div>'));
                    } else {
                	categories.append($('<div name="categories" id="' + response.categories[i].id + '" class="yellow_category" title="' + 
					    response.categories[i].name+'" onclick="select_category(\''+response.categories[i].id+'\');"></div>'));
                    }
                }
	    } else {
                tedx_alert(response.message);
	    }
        }
    });
}

select_category = function(id) {
    $('#comment_category').attr('value',id);
    var categories = document.getElementsByName("categories");
    for (var i=0; i<categories.length ; i++){
	if (categories[i].className == "yellow_category_selected"){
	    categories[i].className = "yellow_category";
	} else if (categories[i].className == "red_category_selected"){
	    categories[i].className = "red_category";
	}
	
	if (categories[i].id == id ){
	    categories[i].className = categories[i].className + "_selected";
	}
    }
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
                    if (percent < 20) {
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
                    cloud.append($('<li   value="' + response.tags[i].value + '"><a class="' + classtag + '" style="text-decoration:none;" href="javascript:add_tag(\'' + 
				   response.tags[i].name + '\')">' + response.tags[i].name + '</a></li>'));
                }
            } else {
                tedx_alert(response.message);
            }
        }
    });
}

new_attachment = function(type) {
    var random_id = random_string(3);
    files_ids.push(random_id);
    var form = '<form id="form' + random_id + '" enctype="multipart/form-data" name="form' + random_id + 
	'" method="post" action="/content/upload_file" target="file_upload_iframe">' +
	_(type) +
	': <input type="file" id="file' +
	random_id +
	'" value="" name="file" accept="' + type + '/*"></input>\
<input type="hidden" id="type' + random_id + '" name="type" value="' + type + '"></input>\
</form>';
   
    $(form).appendTo($('#files'));

    $('#' + random_id).bind('change', function() {
        var re = /\.[^.]+$/;
        var ext = $(this).attr('value').toLowerCase().match(re);
        if (type == 'image' && !image_extensions[ext]) {
            alert(_("file_selected_is_not_an image"));
            $(this).parent().remove();
            files_ids.splice(files_ids.indexOf($(this).attr('id')),1);
        }
        if (type == 'video' && !video_extensions[ext]) {
            alert(_("file_selected_is_not_a_video"));
            $(this).parent().remove();
            files_ids.splice(files_ids.indexOf($(this).attr('id')),1);
        }
    });
    if (!$.browser.msie) {
    	$('#' + random_id).trigger('click');
    }
}

new_youtube_link = function() {
    $('#link').dialog("open");

}

add_link = function() {
    if ($('#youtube_link').attr('value').match(youtube_exp)) {
        var random_id = random_string(3);
        files_ids.push(random_id);
        var input = '<form id="form' + random_id + '" enctype="multipart/form-data" target="file_upload_iframe" method="post" action="/content/upload_file">' +
        _(type) +
        ': <div id="' +
        random_id +
        '" value="'+$('#youtube_link').attr('value')+'" name="file"></div>\
        <input type="button">Eliminar</input>\
        <input type="hidden" name="type" value="' + type + '"></input>\
        </form>';

        $(input).appendTo($('#files'));

        $('#youtube_link').attr('value', '');
        $('#link').dialog("close");
    } else {
        tedx_alert(_("url_is_not_valid"));
    }
}

upload_files = function(comment_id) {
    if (files_ids.length > 0) {
        upload_file(files_ids[0], comment_id);
    } else {
        $('#files').empty();
        
        if ($('#checkNotification').attr('checked') == true) {
            $.ajax({
                url: '/notification/notify',
                type: 'GET',
                async: true,
                cache: false,
                data: {
                    'receivers': $('#receivers').attr('value'),
                    'message': $('#message').attr('value'),
                    'element_id': comment_id
                },
                success: function(responseText) {
                    var response = $.parseJSON(responseText);
                    if (response.status == 'OK') {
                        tedx_alert(_("place_saved"));
                        window.location = '/view/place?id=' + place_id;
                    } else {
                        tedx_alert(response.message);
                        window.location = '/view/place?id=' + place_id;
                    }
                }
            });
        } else {
            window.location = '/view/place?id=' + place_id;
        }
    }
}


upload_file = function(id, comment_id) {
    $('#file_upload_iframe').contents().find('body').empty();
    var input = '<input type="hidden" name="comment_id" value="' + comment_id + '" />';
    $('#form' + id).append(input);
    
    $('#form' + id).submit();
    
    wait_for_file = setInterval('check_file("' + comment_id + '");', 1000);
}

check_file = function(comment_id) {
    var responseText = $('#file_upload_iframe').contents().find('body').html();
    if (responseText != '') {
        var response = $.parseJSON(responseText);
        if (response.status != 'OK') {
            tedx_alert(response.message);
        }
        clearInterval(wait_for_file);
        $('#form' + files_ids[0]).remove();
        $('#attachment_form').empty();
        files_ids.splice(0, 1);
        upload_files(comment_id);
    }
}

search_address = function() {
	var geocoder = new google.maps.Geocoder();
	var address = $('#position_text').attr('value');
	if (geocoder) {
		geocoder.geocode( { 'address': address}, function(results, status) {
	    if (status == google.maps.GeocoderStatus.OK) {
	          map.setCenter(results[0].geometry.location);
	          if (current_position_marker == null){
	      	    current_position_marker = create_marker({
	      	        position: results[0].geometry.location,
	      	        map: map,
	      	        title: _("you_are_here"),
	      	        draggable: true,
	      	        icon: green_marker,
	      	        //shadow: marker_shadow,
	      	        zIndex: 99999
	      	    }, infowindow, _("you_are_here"));
	          } else { 
	        	  current_position_marker.setPosition(results[0].geometry.location);
	          }
	          latitude = results[0].geometry.location.lat();
        	  longitude = results[0].geometry.location.lng();
	    } else {
	          alert("Geocode was not successful for the following reason: " + status);
	    }
		});
	}
}
