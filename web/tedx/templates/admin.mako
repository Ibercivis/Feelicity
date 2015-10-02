# -*- coding: utf-8 -*-
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>
			Administración	
		</title>
		<script type="text/javascript" src="/js/jquery-1.6.2.min.js">
        </script>
        <script type="text/javascript" src="/js/jquery.json-2.2.min.js">
        </script>
		<link rel="stylesheet" type="text/css" href="/css/jquery-ui-1.8.9.custom.css" />
		<link rel="stylesheet" type="text/css" href="/css/tablesorterstyle.css" />
		<script type="text/javascript" src="/js/jquery-ui-1.8.9.custom.min.js"></script>
		<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
		<script type="text/javascript">
			init = function(){
				$('#example').tabs();
				$('#search_button').button();
				$('#delete_button').button();
				$('#save_button').button();
				users();
				
			}
			searcho = function(){
				if ($('#type').attr('value') == "users") {
					users();
				} else if ($('#type').attr('value') == "places") {
					places();
				} else {
					comments();
				}
				
			}
			users = function(){
				$('#type').attr('value','users');
				$('#results').empty();
				$('#results').append($('<img src="images/loading.gif"/>'));
				$.ajax({
			        url: '/admin/search',
			        type: 'GET',
			        async: true,
			        cache: false,
			        data: {
			            'type' : 'users',
						'query': $('#search').attr('value')
					},
			        success: function(responseText){
						var users = $.parseJSON(responseText).results;
						$('#results').empty();
						if (users.length >0){
							var table = $('<table id="table_results" class="tablesorter"></table>');
							table.append($('<thead><tr><th></th><th>id</th><th>nickname</th><th>email</th>\
							<th>avatar</th><th>description</th> \
							<th>created_on</th><th>deleted_on</th><th>last_activity</th>\
							<th>longitude</th><th>latitude</th></tr></thead>'));
							
							var tbody = $('<tbody></tbody>');
							for (var i=0; i<users.length; i++){
								tbody.append($('<tr><td><input name="checkbox" value="'+users[i].id+'" id="'+users[i].id+'_checkbox" type="checkbox"></input></td><td>'+users[i].id+'</td><td><input id="'+users[i].id+'_nickname" value="'+users[i].nickname+'"></input></td><td><input id="'+users[i].id+'_email" value="'+users[i].email+'"></input></td>\
														<td>'+users[i].avatar+'</td>\
														<td><input id="'+users[i].id+'_description" value="'+users[i].description+'"></input></td>\
														<td>'+users[i].created_on+'</td><td>'+users[i].deleted_on+'</td><td>'+users[i].last_activity+'</td>\
														<td><input id="'+users[i].id+'_longitude" value="'+users[i].longitude+'"></input></td><td><input id="'+users[i].id+'_latitude" value="'+users[i].latitude+'"></input></td></tr>'));
							}
							table.append(tbody);
							$('#results').append(table);
							$('#table_results').tablesorter();
						} else {
							$('#results').append("No se han encontrado resultados");
						}
					}
				});	
			}
			
			places = function(){
				$('#type').attr('value','places');
				$('#results').empty();
				$('#results').append($('<img src="images/loading.gif"/>'));
				$.ajax({
			        url: '/admin/search',
			        type: 'GET',
			        async: true,
			        cache: false,
			        data: {
			            'type' : 'places',
						'query': $('#search').attr('value')
					},
			        success: function(responseText){
						var users = $.parseJSON(responseText).results;
						$('#results').empty();
						if (users.length >0){
							var table = $('<table id="table_results" class="tablesorter"></table>');
							table.append($('<thead><tr><th></th><th>id</th><th>name</th><th>user_id</th><th>user_name</th><th>longitude</th><th>latitude</th>\
							<th>visits</th><th>created_on</th></tr></thead>'));
							
							var tbody = $('<tbody></tbody>');
							var geocoder = new google.maps.Geocoder();
    							
							for (var i=0; i<users.length; i++){
								tbody.append($('<tr><td><input name="checkbox" value="'+users[i].id+'" id="'+users[i].id+'_checkbox" type="checkbox"></input></td><td>'+users[i].id+'</td><td><input id="'+users[i].id+'_name" value="'+users[i].name+'"></input></td><td>'+users[i].user_id+'</td><td><input id="'+users[i].id+'_user_name" value="'+users[i].user_name+'"></input></td>\
														<td><input id="'+users[i].id+'_longitude" value="'+users[i].longitude+'"></input></td><td><input id="'+users[i].id+'_latitude" value="'+users[i].latitude+'"></input></td><td><input id="'+users[i].id+'_visits" value="'+users[i].visits+'"></input></td>\
														<td>'+users[i].created_on+'</td></tr>'));
								//update_location(users[i].id, users[i].latitude, users[i].longitude);
								
							}
							table.append(tbody);
							$('#results').append(table);
							
						} else {
							$('#results').append("No se han encontrado resultados");
						}
					}
				});	
			}
			
			update_location = function(id,lat,lng){
				
				var geocoder = new google.maps.Geocoder();
				var latlng = new google.maps.LatLng(lat, lng);
    							var city;
    							var country;
    								if (geocoder) {
								      geocoder.geocode({'latLng': latlng}, function(results, status) {
								    	if (status == google.maps.GeocoderStatus.OK) {
								          var address = results[0].address_components;
								          for (var a=0; a< address.length; a++){
								        	  if (address[a].types[0] == "locality"){
								        		  city = address[a].long_name;
								        	  }
								        	  if (address[a].types[0] == "country"){
								        		  country = address[a].long_name;
								        	  }
								          }
								          $.ajax({
									  	      url: '/admin/update_place',
									  	      type: 'GET',
									  	      async: true,
									  	      cache: false,
									  	      data: {
									  	      	  'id' : id,
									  	          'city' : city,
									  	          'country' : country,
									  	         },
									  	      success: function(responseText){
									  	      	alert('ok');
									  	      }
									  	      
									  	    });
								        } else {
								          alert("Geocoder failed due to: " + status);
								        }
								      });
								    }
								
			}
			
			comments = function(){
				$('#type').attr('value','comments');
				$('#results').empty();
				$('#results').append($('<img src="images/loading.gif"/>'));
				$.ajax({
			        url: '/admin/search',
			        type: 'GET',
			        async: true,
			        cache: false,
			        data: {
			            'type' : 'comments',
						'query': $('#search').attr('value')
					},
			        success: function(responseText){
						var users = $.parseJSON(responseText).results;
						$('#results').empty();
						if (users.length >0){
							var table = $('<table id="table_results" class="tablesorter"></table>');
							
							var table = $('<table id="table_results" class="tablesorter"></table>');
							table.append($('<thead><tr><th></th><th>id</th><th>place_id</th><th>user_id</th><th>longitude</th><th>latitude</th>\
							<th>title</th><th>content</th><th>created_on</th></tr></thead>'));
							
							var tbody = $('<tbody></tbody>');
							for (var i=0; i<users.length; i++){
								tbody.append($('<tr><td><input name="checkbox" value="'+users[i].id+'" id="'+users[i].id+'_checkbox" type="checkbox"></input></td><td>'+users[i].id+'</td><td>'+users[i].place_id+'</td><td>'+users[i].user_id+'</td><td><input id="'+users[i].id+'_longitude" value="'+users[i].longitude+'"></input></td>\
														<td><input id="'+users[i].id+'_latitude" value="'+users[i].latitude+'"></input></td><td><input id="'+users[i].id+'_title" value="'+users[i].title+'"></input></td><td><input id="'+users[i].id+'_content" value="'+users[i].content+'"></input></td><td>'+users[i].created_on+'</td>\
														</tr>'));
							}
							table.append(tbody);
							$('#results').append(table);
							$('#table_results').tablesorter();
						} else {
							$('#results').append("No se han encontrado resultados");
						}
					}
				});	
			}
			
			delete_entity = function(){
				var elements = document.getElementsByName("checkbox");
				var to_delete = new Array();
				for (i=0; i<elements.length; i++){
					if (elements[i].checked) {
						to_delete.push(elements[i].value);
					}	
				}
				$.ajax({
			        url: '/admin/delete_entity',
			        type: 'GET',
			        async: true,
			        cache: false,
			        data: {
			            'ids' : $.toJSON(to_delete),
						'type' : $('#type').attr('value')
					},
			        success: function(responseText){
						if (responseText == "OK"){
							alert('OK');
						} else {
							alert('Error');
						}
					}
				});	
			}
			
			save_entities = function(){
				var elements = document.getElementsByName("checkbox");
				var to_update = new Array();
				for (i=0; i<elements.length; i++){
					if (elements[i].checked) {
						to_update.push(elements[i].value);
					}	
				}
				for (var i =0; i < to_update.length; i++){
					if ($('#type').attr('value')=="users"){
						$.ajax({
					        url: '/admin/update_entity',
					        type: 'GET',
					        async: true,
					        cache: false,
					        data: {
					            'type' : $('#type').attr('value')
								
							},
					        
						});
					} else if($('#type').attr('value')=="places"){
						
						$.ajax({
					        url: '/admin/update_entity',
					        type: 'GET',
					        async: true,
					        cache: false,
					        data: {
					            'type' : $('#type').attr('value'),
								
							},
					        
						});
					} else {
						$.ajax({
					        url: '/admin/update_entity',
					        type: 'GET',
					        async: true,
					        cache: false,
					        data: {
					            'type' : $('#type').attr('value'),
								'id' : $('#'+to_update[i]+'_checkbox').attr('value'),
								'longitude': $('#'+to_update[i]+'_longitude').attr('value'),
								'latitude': $('#'+to_update[i]+'_latitude').attr('value'),
								'title' : $('#'+to_update[i]+'_title').attr('value'),
								'content': $('#'+to_update[i]+'_content').attr('value')
							},
					   });
					}
				}	
				alert('OK');
			}
			
		</script>
	</head>
	<body onload="init();">
		<h2>Administración</h2>
		<div>
			<input id="search" type="text"><div id="search_button"><a href="javascript:void(0);" onclick="searcho();">Búsqueda</a></div></input>
		</div>
		
		<div id="example" style="margin-top:20px;">
			<ul>
				<li><a href="javascript:void(0);" onclick="users();">Usuarios</a></li>
				<li><a href="javascript:void(0)"  onclick="places();">Lugares</a></li>
				<li><a href="javascript:void(0);" onclick="comments();">Comentarios</a></li>
			</ul>
			<input id="type" type="hidden" value="users"></input>
		</div>
		<div id="results">
		</div>
		<div> 
			<div id="delete_button" onclick="delete_entity();">Eliminar</div>
			<div id="save_button" onclick="save_entities();">Guardar</div>
		</div>
	</body>
</html>