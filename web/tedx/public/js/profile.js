init = function() {
	list_mode = true;
	mode = "profile";
	profile_id = user_id;
	
    if (profile_id != "") {
        get_profile_data();
        get_places();
        get_relations();
    }
}
get_profile_data = function() {
    $.ajax({
        url: '/profile/get_profile_data',
        type: 'GET',
        async: true,
        cache: false,
        data: {
            'user_id': user_id
        },
        success: function(responseText) {
            var response = $.parseJSON(responseText);

            if (response.status == 'OK') {
            	$('#nickname_profile').html('');
                $('#description').html('');
                $('#avatarPerfil').empty();
                $('#avatarPerfil').append($('<img src="'+response.avatar+'_mid.png"/>'));
                $('#nickname_profile').html(response.nickname);
                $('#nickname').attr('value',response.nickname);
                $('#description').html(response.description);
                
            }
            
            
        }
    });
}

get_relations = function(){
    $.ajax({
        url: '/profile/get_relations',
        type: 'GET',
        async: true,
        cache: false,
        data: {
            'user_id': user_id
        },
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status = "OK"){
                var following = response.following;
                var followers = response.followers;
                if (following.length > 0){
                    var ul = $('<ul style="list-style:none outside none;" ></ul>');
                    $('#following').append(ul);
                    for (var i = 0; i < following.length ; i++){
                    	ul.append($('<li class="ItemFollowing"><a href="/' + following[i].nickname +'"><img title="'+following[i].nickname+'" src="'+following[i].avatar+'_small.png" alt="'+following[i].nickname+'" /></a></li>'));
                    }
                } else {
	    		    $('#following').append($('<span>' + _('You are not currently following anyone') + '</span>'));
	    		}
                if (followers.length > 0){
                    var ul2 = $('<ul style="list-style:none outside none;" ></ul>');                    
                    $('#followed').append(ul2);
                    for (var i = 0; i < followers.length ; i++){
                    	ul2.append($('<li class="ItemFollower"><a href="/' + followers[i].nickname +'"><img title="'+followers[i].nickname+'" src="'+followers[i].avatar+'_small.png" alt="'+followers[i].nickname+'" /></a></li>'));
                    }                   
                } else {
	    		    $('#followed').append($('<span>' + _('You are not currently being followed by anyone') + '</span>'));
	    		}
            }
        }
    });
}


