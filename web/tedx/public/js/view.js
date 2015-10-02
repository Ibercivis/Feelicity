var wait_for_file;
var files_ids = new Array();
var regex = /https?:\/\/([-\w\.]+)+(:\d+)?(\/([\w/_%\.]*(\?\S+)?)?)?/g;
var youtubeexp = /\[YOUTUBE\][^\[]*\[\/YOUTUBE\]/g;
var youtube_exp = /^http:\/\/(?:www\.)?youtube.com\/watch\?(?=.*v=\w+)(?:\S+)?/;
var link_exp = /v=([a-z0-9-_]+)/i;
var place_page = 1;
var place_page_size = 10;
var video_player;

init = function() {
    if (user_id) {
        get_comment_tags();
        $('#link').dialog({
            autoOpen: false,
            buttons: {
                "Add": function() {
                    if ($('#youtube_link').attr('value').match(youtube_exp)) {
                        var random_id = random_string(3);
                        var type = "youtube";
                        files_ids.push(random_id);
                        input = '<form id="form' + random_id + '" enctype="multipart/form-data" target="file_upload_iframe" method="post" action="/content/upload_file">' +
                            _(type) +
                            ': <input id="' +
                            random_id +
                            '" type="text" readonly size="35" value="'+$('#youtube_link').attr('value')+'" name="file"></input>\
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
            }
        });
    }
    get_place_data();
}

var get_place_data = function() {
    $.ajax({
        url: '/view/get_place_data',
        type: 'GET',
        async: true,
        cache: false,
        data: {
            'id': place_id,
            'page': place_page,
            'page_size': place_page_size,
            'latitude': latitude,
            'longitude': longitude
        },
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status == 'OK') {
                var place = response.place;
                var results = response.comments;
		
                if (mode == 'map') {
                    map.setCenter(new google.maps.LatLng(place.latitude, place.longitude));
                    map.setZoom(max_zoom);
                }
		
                $('#srToolsDown').empty();

                if (response.current_page > 1 && response.pages > 1) {
                    $('#srToolsDown').append($('<a class="estiloAzul" href="javascript:void(0);" onclick="get_place_page(1);"><<</a> <a class="estiloAzul" href="javascript:void(0);" onclick="get_place_page(' + (response.current_page - 1) + ');"><</a>'));
                    $('#srToolsDown').append(' ');
                }

                $('#srToolsDown').append(' ' + _('page') + ': ');
                $('#srToolsDown').append($('<input type="text" size="1" value="' + response.current_page + '" onchange="get_place_page(this.value);"/>'));
                $('#srToolsDown').append(' ' + _('of') + ' ' + response.pages + ' ');

                if (response.current_page < response.pages && response.pages > 1) {
                    $('#srToolsDown').append(' ');
                    $('#srToolsDown').append($('<a class="estiloAzul" href="javascript:void(0);" onclick="get_place_page(' + (response.current_page + 1) + ');">></a> <a class="estiloAzul" href="javascript:void(0);" onclick="get_place_page(' + response.pages + ');">>></a>'));
                }

                $('#srToolsDown').append($('<input type="text" size="1" value="' + place_page_size + '" onchange="get_place_page_size(this.value);"/>'));
                $('#srToolsDown').append(' ' + _('results_per_page'));

                
                // Place comments
                var comments = $('#list');
                comments.empty();

                // Translated strings that are repeated
                var notify_string = _("notify");
                var download_sticker_string = _("download_sticker");
                var download_video_string = _("download_video");
                var remove_string = _("remove");
                
                // Place comments
                for (var i = 0; i < results.length; i++) {
		    // After the happy instant we should place the comments title
		    if (i == 1) comments.append('<h4 class="left clear comm">Comentarios:</h4>');

		    // Happy instant with comments
		    var comment_data = results[i];
		    var comment_title = place.place_name;
		    var comment_description = '';
		    if (comment_data.comment_content != undefined) {
			comment_description = replace_links(comment_data.comment_content);
		    }

		    var comment = $('<div class="item"></div>');
		    if (!comment_data.deleted_on) {
			comment.append($('<div style="width:70px;float:left;"><img src="' + comment_data.user_avatar + '_small.png?d=' + new Date().getTime() + '"/></div>'));
			comment.append($('<a href="../' + comment_data.user_name + '">' + comment_data.user_name + '</a>'));
			if (i == 0) {
			    comment.append($('<h4>'+ comment_title +'</h4>'));
			}
			comment.append($('<p>'+ comment_description + '</p>'));
			var comment_details = $('<div class="momentoCont left clear"><p class="clear">'+ comment_data.last_update + '</p></div>');
			comment_details.append(create_actions(place, comment_data, i));
			comment.append(comment_details);
			comment.append(create_attachments(comment_data.files));
		    } else {
			comment.append($('<div>' + _('comment_removed_on') + ' ' + results[i].deleted_on + '</div>'));
		    }
		    comments.append(comment);
                }

                // Place marker html
                if (place.place_id != "") {
                    name = '<a class="estiloAzul" href="/view/place?id=' + place.place_id + '&latitude=' + latitude + '&longitude=' + longitude + '">' + place.place_name + '</a>';
                } else {
                    name = results[i].place_name;
                }
                var html = '<table>\
                <tr><td colspan="2">'+
                name+'</td></tr>\
                <tr><td><b>' +
                _("author") +
                ':</b></td><td><a class="estiloAzul" href="/' + place.user_name + '">' +
                place.user_name +
                '</a></td></tr>';

                

                html += '<tr><td><b>' +
                _("last_update") +
                ':</b></td><td>' +
                place.last_update +
                ' por ' +
                place.last_updater_name +
                '</td></tr>\
                <tr><td><b>' +
                _("comments") +
                ':</b></td><td>' +
                place.num_comments +
                '</td></tr>\
                <tr><td><b>' +
                _("visits") +
                ':</b></td><td>' +
                place.visits +
                '</td></tr>\
                <tr><td><b>' +
                _("scoring") +
                ':</b></td><td>'+place.positive_scorings+'</td></tr>';
                
                if (place.comment_image != null){
                	html += '<tr><td><img src ="' + place.comment_image +'_small.jpg"/></td></tr>\
                	</table>';
                } else {
                	html += '</table>';
                }

                var marker = drawn_places[place.place_id];
                if (marker == undefined) {
                    
                    var marker = red_marker;
                    

                    var marker = create_marker({
                        position: new google.maps.LatLng(place.latitude, place.longitude),
                        icon: marker,
                        //shadow: marker_shadow,
                        map: map
                    }, infowindow, html);
                    markers_array.push(marker);

                    drawn_places[place.place_id] = marker;
                }
            } else {
                tedx_alert(response.message);
                document.location = '/';
            }
        }
    });
}

replace_links = function(content) {
    var links = content.match(regex);
    var result = content;
    if (links != null) {
        for (var j = 0; j < links.length; j++) {
            result = content.replace(links[j], '<a href="' + links[j] + '">' + links[j] + '</a>');
        }
    }
    
    result = result.replace('\n','<br/>');
    return result;
};

create_attachments = function(attachments) {
    var comment_attachments = $('<div class="comment_attachments"></div>');
    for (var j = 0; j < attachments.length; j++) {
        if (j != 0 && (j % 4 == 0)) {
	    comment_attachments.append($('<div class="clear"></div>'));
	}

        var comment_attachment = $('<div class="comment_attachment"></div>');
        comment_attachments.append(comment_attachment);

        // Video
        if (attachments[j].type == "video") {
	    comment_attachment.append($('<a href="javascript:void(0);" onclick="show_attachment(\'video\', \'' + attachments[j].id + '\', \'' + 
					results[i].files[j].path + '\');"><img class="video_attachment" src="' + 
					results[i].files[j].path + '.jpg" /><img class="play_button" src="/images/play_button_red.png" /></a>'));
	} else if (attachments[j].type == "image") {
            // Picture
            comment_attachment.append($('<a href="javascript:void(0);" onclick="show_attachment(\'image\', \'' + attachments[j].path + 
					'\');"><img class="image_attachment" src="' + attachments[j].path + '.jpg" /></a>'));
        } else {
            // Youtube link
            link_id = attachments[j].path.match(link_exp);
            if (link_id != null) {
                link_id = link_id.toString().split(',')[1];
                comment_attachment.append($('<a href="javascript:void(0);" onclick="show_attachment(\'youtube\', \'' + link_id + 
					    '\');"><img class="video_attachment" src="http://img.youtube.com/vi/' + link_id + 
					    '/1.jpg" /><img class="play_button" src="/images/play_button_red.png" /></a>'));
            }
        }
    }
    comment_attachments.append($('<div class="clear"></div>'));
    return comment_attachments;
};

create_actions = function(place, comment, i) {
    var comment_actions = $('<div class="comment_actions"></div>');

    if (i == 0) {
        comment_actions.append($('<a class="comment_action estiloNegro" href="javascript:void(0);" onclick="add_place_scoring(\'' + place.place_id + 
				 '\',1);"><img  src="/images/iconoVotoUp.png"/>' + place.positive_scorings + '</a>&nbsp;'));
    } else {
        comment_actions.append($('<a class="comment_action estiloNegro" href="javascript:void(0);" onclick="add_comment_scoring(\'' + comment.comment_id + 
				 '\',1);"><img  src="/images/iconoVotoUp.png"/>' + comment.positive_scorings + '</a>&nbsp;'));
    }

    if (comment.editable) {
    	if (i == 0){
    	comment_actions.append($('<a class="comment_action" href="javascript:void(0);" onclick="delete_place(\'' + place.place_id + 
   			 '\')";><img  src="/images/miniconoEliminar.png" alt="' + _("remove") + '" title="' + _("remove") + '"></a>'));
       		
    	} else {
        comment_actions.append($('<a class="comment_action" href="javascript:void(0);" onclick="delete_comment(\'' + comment.comment_id + 
				 '\')";><img  src="/images/miniconoEliminar.png" alt="' + _("remove") + '" title="' + _("remove") + '"></a>'));
    	}
    }
    
    return comment_actions;
};

get_place_page = function(new_page) {
    place_page = new_page;
    get_place_data();
}

get_place_page_size = function(new_page_size) {
    place_page_size = new_page_size;
    get_place_data();
}

show_attachment = function(type, video_id, video_path) {
    $('#attachment_modal').empty();

    if (type == 'youtube') {
        $('#attachment_modal').append($('<iframe class="youtube-player" type="text/html" width="480" height="360" src="http://www.youtube.com/embed/' + video_id + '" frameborder="0"></iframe>'));

        $('#attachment_modal').dialog({
            autoOpen: true,
            modal: true,
            resizable: false,
            draggable: false,
            width: 'auto',
            height: 'auto',
            show: "slide",
            modal: true,
            buttons: {
                Cerrar: function() {
                    $( this ).dialog( "close" );
                }
            },
            close: function() {
                $('#attachment_modal').dialog( "destroy" );
            }
        });
    } else if (type == 'video') {

        $('#attachment_modal').dialog({
            autoOpen: true,
            modal: true,
            resizable: false,
            draggable: false,
            width: '505',
            height: '500',
            show: "slide",
            modal: true,
            buttons: {
                Cerrar: function() {
                    $( this ).dialog( "close" );
                    video_player.unload();
                }
            },
            create: function() {
                setTimeout( function() {
                    var video_box = $('<div class="video-js-box"></div>');
                    $('#attachment_modal').append($(video_box));

                    var flash_player = $('<a href="' + video_path + '.flv" style="display:block;width:480px;height:360px;" id="player_' + video_id + '"></a>');
                    video_box.append(flash_player);

                    // Download video controls
                    var download_videos = $('<p class="vjs-no-video"><strong>' + _('download_video') + ':</strong>\
                    <a href="' +
                    video_path +
                    '.mp4">MP4</a>\
                    <a href="' +
                    video_path +
                    '.flv">FLV</a><br>\
                    </p>');
                    $('#attachment_modal').append(download_videos);

                    video_player = flowplayer("player_" + video_id, "/swf/flowplayer-3.2.5.swf", {
                        clip: {
                            autoPlay: false,
                            autoBuffering: true,
                        }
                    });
                }, 500);
            },
            close: function() {
                $('#attachment_modal').dialog( "destroy" );
            }
        });

    } else if (type == 'image') {
        var img = $('<img src="" />');
        $('#attachment_modal').append(img);
        img.attr('src', video_id + '.jpg?nocache=' + Math.random());

        img.load( function() {
            $('#attachment_modal').dialog({
                modal: true,
                resizable: false,
                draggable: false,
                width: 'auto',
                height: 'auto',
                autoOpen: true,
                show: "slide",
                modal: true,
                buttons: {
                    Cerrar: function() {
                        $( this ).dialog( "close" );
                    }
                },
                close: function() {
                    $('#attachment_modal').dialog( "destroy" );
                }
            });
        });
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
                    if (response.categories[i].name =="ambar") {
                        categories.append($('<div name="categories" id="' + response.categories[i].id + '" class="yellow_category" title="'+response.categories[i].name+'" onclick="select_category(\''+response.categories[i].id+'\');"></div>'));
                    } else if (response.categories[i].name="psoe") {
                        categories.append($('<div name="categories" id="' + response.categories[i].id + '" class="red_category" title="'+response.categories[i].name+'" onclick="select_category(\''+response.categories[i].id+'\');"></div>'));
                    } else {
                        categories.append($('<div name="categories" id="' + response.categories[i].id + '" class="yellow_category" title="'+response.categories[i].name+'" onclick="select_category(\''+response.categories[i].id+'\');"></div>'));
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
    for (var i=0; i<categories.length ; i++) {
        if (categories[i].className == "yellow_category_selected") {
            categories[i].className = "yellow_category";
        } else if (categories[i].className == "red_category_selected") {
            categories[i].className = "red_category";
        }

        if (categories[i].id == id ) {
            categories[i].className = categories[i].className + "_selected";
        }
    }

}

add_tag = function(tag) {
    strings = $("#comment_tags").attr('value').split(' ');
    var found = false;
    for (i=0; i<strings.length; i++) {
        if (strings[i] == tag) {
            found = true;
        }
    }
    if (!found)
        $("#comment_tags").attr('value',$("#comment_tags").attr('value') + ' ' + tag);
}

new_comment = function() {
    if (!$('#comment_content').attr('value')) {
        tedx_alert(_("comment_content_cannot_be_null"));
        return;
    }
    $('#loading_div').show();
    $('#new_comment_div').hide();
    $.ajax({
        url: '/content/new_comment',
        type: 'GET',
        async: true,
        cache: false,
        data: {
            'place_id': place_id,
            'latitude': $('#latitude').attr('value'),
            'longitude': $('#longitude').attr('value'),
            'comment_title': $('#comment_title').attr('value'),
            'comment_content': $('#comment_content').attr('value'),
            'comment_tags': $('#comment_tags').attr('value')
        },
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status == 'OK') {
                upload_files(response.comment_id);
            } else {
                tedx_alert(response.message);
            }
            clear_fields();
        }
    });
}

clear_fields = function() {
    $('#comment_title').attr('value','');
    $('#comment_content').attr('value','');
    $('#edit_description_count').html('0');
    $('#comment_tags').attr('value','');
}

add_place_scoring = function(place,value) {
    $.ajax({
        url: '/view/add_place_scoring',
        type: 'GET',
        async: true,
        cache: false,
        data: {
            'place_id': place,
            'value': value,
        },
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status == 'OK') {
                tedx_alert(_("scoring_successfully_saved"));
                get_place_data();
            } else {
                tedx_alert(response.message);
            }
        }
    });
}

add_comment_scoring = function(comment, value) {
    $.ajax({
        url: '/view/add_comment_scoring',
        type: 'GET',
        async: true,
        cache: false,
        data: {
            'comment_id': comment,
            'value': value,
        },
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status == 'OK') {
                tedx_alert(_("scoring_successfully_saved"));
                get_place_data();
            } else {
                tedx_alert(response.message);
            }
        }
    });
}

new_attachment = function(type) {
    var random_id = random_string(3);
    files_ids.push(random_id);
    input = '<form id="form' + random_id + '" enctype="multipart/form-data" target="file_upload_iframe" method="post" action="/content/upload_file">' +
    _(type) +
    ': <input type="file" id="' +
    random_id +
    '" value="" name="file" accept="' + type + '/*"></input>\
    <input type="hidden" name="type" value="' + type + '"></input>\
    </form>';

    $(input).appendTo($('#files'));

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
        $('#comment_content').attr('value', $('#comment_content').attr('value') + '[YOUTUBE]' + $('#youtube_link').attr('value') + '[/YOUTUBE]');
        $('#youtube_link').attr('value', '');
        $('#link').dialog("close");
    } else {
        tedx_alert(_("url_is_not_valid"));
    }
}

upload_files = function(comment_id) {
    if (files_ids.length > 0) {
        upload_file(files_ids[0],comment_id);
    } else {
        $('#files').empty();
        
        $('#loading_div').hide();
        $('#new_comment_div').show();
        tedx_alert(_("comment_successfully_saved"));
        get_place_data();
    }
}

upload_file = function(id,comment_id) {
    $('#file_upload_iframe').contents().find('body').empty();
    input = '<input type="hidden" name="comment_id" value="'+comment_id+'" />';
    $(input).appendTo($('#form' +id));
    $('#form' +id).submit();
    wait_for_file = setInterval('check_file("'+comment_id+'");', 1000);
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
        files_ids.splice(0, 1);
        upload_files(comment_id);
    }
}

remove_comment = function(comment_id) {
    $.ajax({
        url: '/content/remove_comment',
        type: 'GET',
        async: true,
        cache: false,
        data: {
            'comment_id': comment_id,
        },
        success: function(responseText) {
            var response = $.parseJSON(responseText);
            if (response.status == 'OK') {
                tedx_alert(_("comment_successfully_removed"));
                get_place_data();
            } else {
                tedx_alert(response.message);
            }
        }
    });
}
