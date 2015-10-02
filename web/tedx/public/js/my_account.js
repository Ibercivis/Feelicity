var wait_for_avatar;

init = function(){
	list_mode = true;
    
   
    
    mode = "profile";
    profile_id = user_id;
    get_places();
    get_stats();
    get_details();
}



get_details = function() {
    $.ajax({
        url: '/my_account/get_details',
        type: 'GET',
        async: true,
        cache: false,
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status = "OK") {
                $('#avatarPerfil').empty();
                $('#avatarPerfil').append($('<img src="'+response.avatar+'_mid.png?d='+ new Date().getTime()+'" alt="'+response.user_name+'"/>'));
                if (response.user_nickname) {
                	$('#nickname_profile').html('');
                	$('#nickname_profile').append($('<a href="#" class="clear">'+ response.user_nickname+'</a>'));
                	$('#nickname').attr('value',response.user_nickname);
                }
                if (response.user_description){
                	 $('#description').attr('value',response.user_description);
                }
                	
                
            }
        }
    });
}

get_relations = function(){
	$.ajax({
        url: '/my_account/get_relations',
        type: 'GET',
        async: true,
        cache: false,
        success: function(responseText) {
        	var response = $.parseJSON(responseText);
        	if (response.status = "OK"){
        		var following = response.following;
        		var followers = response.followers;
        		
        		$('#following').empty();
        		if (following.length > 0){
            		for (var i = 0; i < following.length ; i++){
            			$('#following').append($('<div class="seguirAvatar">\
                            <a href="/' + following[i].nickname +'" class="estiloAzul">\
                            <img src="'+following[i].avatar+'_small.png" alt="'+following[i].nickname+'" title="'+following[i].nickname+'" longdesc="Click aqui para dejar de seguir a este usuario." /></a>\
                            <br /><a href="javascript:void(0);" class="estiloAzul" onclick="unfollow(\'' + following[i].id + '\');">' + _('unfollow') + '</a></div>'));
                    }
	    		} else {
	    		    $('#following').append($('<span>' + _('You are not currently following anyone') + '</span>'));
	    		}
	    		
	    		$('#followed').empty();
        		if (followers.length > 0){
            		for (var i = 0; i < followers.length ; i++){
            		    if (i > 0 && i % 7 == 0) {
            		        $('#followed').append($('<div class="clear"></div>'));
            		    }
	        			$('#followed').append($('<div class="seguirAvatar">\
                            <a href="/' + followers[i].nickname +'" class="estiloAzul">\
                            <img src="'+followers[i].avatar+'_small.png" alt="'+followers[i].nickname+'" title="'+followers[i].nickname+'" longdesc="Click aqui para dejar de seguir a este usuario." /></a>\
                            <br /><a href="javascript:void(0);" class="estiloAzul" onclick="unfollow(\'' + followers[i].id + '\');">' + _('unfollow') + '</a></div>'));
	        		}	        		
	    		} else {
	    		    $('#followed').append($('<span>' + _('You are not currently being followed by anyone') + '</span>'));
	    		}
        	}
        }
	});
}

get_stats = function(){
    $.ajax({
        url: '/my_account/get_stats',
        type: 'GET',
        async: true,
        cache: false,
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status = "OK"){
                //$('#streetits_stats').html(response.places);
            	if (response.comments != "1")    $('#comments').html(response.comments + " Comentarios");
            	else 							 $('#comments').html(response.comments + " Comentario");
                if (response.visits != "1")      $('#visits').html(response.visits + " Visitas");
                else							 $('#visits').html(response.visits + " Visita");
                $('#likes').html(response.positive_scorings + " Me gusta");
                 
                //$('#videos_stats').html(response.videos);
                //$('#images_stats').html(response.images);
                //$('#links_stats').html(response.links);
                //$('#likes').html(response.positive_scorings);
                //$('#negative_scorings_stats').html(response.negative_scorings);
            }
        }
    });
}

get_pending_categories = function() {
    $.ajax({
        url: '/category/pending_categories',
        type: 'GET',
        async: true,
        cache: false,
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status == 'OK') {
                var categories = response.categories;
                if (categories.length > 0){
                    var ul = $('<ul style="list-style:none outside none; padding-left: 0px;" ></ul>');
                    $('#pending_categories').append(ul);
                    for (var i=0; i<categories.length; i++){
                        ul.append($('<li><input type="checkbox" name="checkbox_categories" id="'+categories[i].id+'" value="'+categories[i].id+'" />'+categories[i].name+'</li>'))  
                    }
                    $('#pending_categories').append($('<a class="botonRojo" style="float:right;" href="javascript:void(0);" onclick="join_categories();">' + _('join_categories') + '</a><div class="clear"></div>'));
                } else {
                    $('#pending_categories').append($('<span>' + _('There are no pending categories to join') + '</span>'));
                }
            } else {
                tedx_alert(response.message);
            }
        }
    });
}

get_requests = function(){
    $('#requests').empty();
    $.ajax({
        url: '/my_account/get_requests',
        type: 'GET',
        async: true,
        cache: false,
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status = "OK"){
                var requests = response.requests;
                if (requests.length > 0){
                    var ul = $('<ul style="list-style:none outside none;" ></ul>');
                    $('#requests').append(ul);
                    for (var i=0; i<requests.length; i++){
                        ul.append($('<li><input type="checkbox" name="checkbox_requests" id="'+requests[i].id+'" value="'+requests[i].id+'"></input>'+requests[i].category_name+' '+ requests[i].user_name+'</li>'))    
                    }
                    $('#requests').append($('<a class="botonRojo" style="float:right;" href="javascript:void(0);" onclick="accept_requests();">' + _('accept') + '</a>'));
                    $('#requests').append($('<a class="botonRojo" style="float:right;" href="javascript:void(0);" onclick="reject_requests();">' + _('reject') + '</a>'));
                } else {
                    $('#requests').append($('<span>' + _('There are no pending requests') + '</span>'));
                }
            }
        }
    });
}

view_place = function(id,place_id){
	$.ajax({
        url: '/my_account/remove_message',
        type: 'GET',
        async: true,
        cache: false,
        data: {
        	'id' : id
        },
        success: function(responseText) {
        	var response = $.parseJSON(responseText);
        	if (response.status == "OK"){
        		document.location = "/view/place?id=" + place_id;
        	} else {
        		tedx_alert(response.message);
        	}
        }
	});
}



remove_messages = function(){
	var to_remove = new Array();
	var inputs = document.getElementsByName("checkbox_messages");
	for (i=0; i<inputs.length; i++){
		if (inputs[i].checked) {
			to_remove.push(inputs[i].value);
		}	
	}
	$.ajax({
	       url: '/my_account/remove_messages',
	       type: 'GET',
	       async: true,
	       cache: false,
	       data: {
	           'ids' : $.toJSON(to_remove)
	       },
	       success: function(responseText) {
	    	   var response = $.parseJSON(responseText);
	    	   if (response.status != 'OK'){
	    		   alert(response.message);
	    	   }
	    	   get_messages();
	       }
	});
}

accept_requests = function(){
	var to_remove = new Array();
	var inputs = document.getElementsByName("checkbox_requests");
	for (i=0; i<inputs.length; i++){
		if (inputs[i].checked) {
			to_remove.push(inputs[i].value);
		}	
	}
	$.ajax({
	       url: '/my_account/accept_requests',
	       type: 'GET',
	       async: true,
	       cache: false,
	       data: {
	           'ids' : $.toJSON(to_remove)
	       },
	       success: function(responseText) {
	    	   var response = $.parseJSON(responseText);
	    	   if (response.status != 'OK'){
	    		   alert(response.message);
	    	   }
	    	   get_requests();
	       }
	});
}

reject_requests = function(){
	var to_remove = new Array();
	var inputs = document.getElementsByName("checkbox_requests");
	for (i=0; i<inputs.length; i++){
		if (inputs[i].checked) {
			to_remove.push(inputs[i].value);
		}	
	}
	$.ajax({
	       url: '/my_account/reject_requests',
	       type: 'GET',
	       async: true,
	       cache: false,
	       data: {
	           'ids' : $.toJSON(to_remove)
	       },
	       success: function(responseText) {
	    	   var response = $.parseJSON(responseText);
	    	   if (response.status != 'OK'){
	    		   alert(response.message);
	    	   }
	    	   get_requests();
	       }
	});
}

change_password = function(){
	$('#change_password_div').hide();
	$('#new_password_div').show();
}

save = function(){
	if ( ($('old_password') == null) || ((($('password1') + $('password2')) != "") && $('password1').value == $('password2').value)) {
     	$.ajax({
	        url: '/my_account/save',
	        type: 'GET',
	        async: true,
	        cache: false,
	        data: {
	            'email': $('#email').attr('value'),
				'old_password': $('#password1').attr('value'),
				'password': $('#password2').attr('value'),
				'nickname': $('#nickname').attr('value'),
				'latitude': latitude,
				'longitude': longitude,
				'description': $('#description').attr('value'),
				'user_tags': $('#user_tags').attr('value')
	        },
	        success: function(responseText){
				var response = $.parseJSON(responseText);
	            if (response.status == 'OK') {
	            	var re = /\.[^.]+$/;
	                var ext = $('#avatar').attr('value').toLowerCase().match(re);
		            if ($('#avatar').attr('value')!= ""){    
	                	if (!image_extensions[ext]) {
		                    alert(_("file_selected_is_not_an image"));
		        		} else {
		        			$('#form_avatar').submit();
		        			wait_for_avatar = setInterval('check_avatar("'+response.message+'")', 1000);
		        			
		        		}
		            }else{
		            	tedx_alert(response.message);
		            	window.location = '/my_account';
		            }
	            }
	            else {
	                tedx_alert(response.message);
	            }
	            get_details();
	        }
	    });
	} else {
		tedx_alert(_("error_changing_password"));
	}
}

upload_avatar = function() {
    if ($('avatar').value != "") {
        $('avatar_form').action = '/gdt_profile/upload_avatar?gp.fileupload.id=avatar_${c.entity.id}';
        $('avatar_form').submit();
        $('avatar_controls').setStyle('display', 'none');
        wait_for_avatar = setInterval('check_avatar();', 1000);
    }
}
check_avatar = function() {
    new Request({
        url: '/gp.fileupload.stat/avatar_${c.entity.id}',
        method: 'get',
        async: true,
        noCache: true,
        onSuccess: function(responseText) {
            var stats = JSON.decode(responseText);
            if (stats.state == 1) {
                progress_bar.setUploaded(stats.partial, stats.total);
                if (stats.percent == 100) {
                    var final_status = $('avatar_iframe').contentWindow.document.body.innerHTML;
                    if (final_status != '') {
                        if (final_status != 'OK') {
                            hq_alert('Error subiendo el avatar');
                        } else {
                            $('avatar_img').innerHTML = "<img src='/images/avatars/" + self_id + ".jpg?refresh=" + Math.random() + "' />";
                            $('current_avatar').innerHTML = "<img  id='current_avatar_img' src='/images/avatars/" + self_id + "_mid.jpg?refresh=" + Math.random() + "' /><div id='gobierno' class='ic_iluminado'></div>";
                            $('avatar_controls').setStyle('display', 'block');
                        }
                        clearInterval(wait_for_avatar);
                        $('avatar_iframe').contentWindow.document.body.innerHTML = '';
                    }
                }
            } else {
                hq_alert('Error subiendo el archivo');
            }
        }
    }).send();
}
delete_avatar = function() {
    new Request({
        url: '/my_account/delete_avatar',
        method: 'get',
        async: false,
        noCache: true,
        onSuccess: function(responseText) {
            if (responseText == 'OK') {

                $('avatar_img').innerHTML = "";
                $('avatar').value = "";

                $('current_avatar').innerHTML = "<img id='current_avatar_img' src='/images/avatars/default_mid.jpg?refresh=" + Math.random() + "' /><div id='gobierno' class='ic_iluminado'></div>";
                $('avatar_controls').setStyle('display', 'none');
            } else {
                hq_alert('Error borrando el avatar');
            }
        }
    }).send();
}

check_avatar = function(message){
	if (document.getElementById('file_upload_avatar').contentWindow.document.body.innerHTML != ""){
		clearInterval(wait_for_avatar);
		tedx_alert(message);
    	get_details();
	}
}

print_page_stickers = function() {
    //checkToPrint
    var to_print = new Array();
    var inputs = document.getElementsByName('checkToPrint');
    for (i=0; i<inputs.length; i++) {
        if (inputs[i].checked) {
            to_print.push(inputs[i].value);
        }
    }
    var src = "/home/Stickers?ids=" + $.toJSON(to_print);
    $("#stickers_download_iframe").attr("src",src);

}

generate_empty_place = function(){
	$.ajax({
		url: '/content/new_empty_place',
		type: 'GET',
	    async: true,
	    cache: false,
	    success: function(responseText){
			var response = $.parseJSON(responseText);
			if (response.status == 'OK'){
				get_places();
				var to_print = new Array();
				to_print.push(response.message)
				var src = "/home/Stickers?ids=" + $.toJSON(to_print);
			    $("#stickers_download_iframe").attr("src",src);
			}
		}
	});
}

edit_place = function(id){
	document.location = '/content?place=' + id;
}

join_categories = function(){
	var to_remove = new Array();
	var inputs = document.getElementsByName("checkbox_categories");
	for (i=0; i<inputs.length; i++){
		if (inputs[i].checked) {
			to_remove.push(inputs[i].value);
		}	
	}
	$.ajax({
	       url: '/my_account/join_categories',
	       type: 'GET',
	       async: true,
	       cache: false,
	       data: {
	           'ids' : $.toJSON(to_remove)
	       },
	       success: function(responseText) {
	    	   var response = $.parseJSON(responseText);
	    	   if (response.status != 'OK'){
	    		   tedx_alert(response.message);
	    	   }
	    	   get_messages();
	       }
	});
}
