# -*- coding: utf-8 -*-
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Feelicity - ${next.title()}</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta name="Keywords" content="geotagging, geolocalización, social network, red social, mapa"/>
	<meta name="Description" content="Feelicity lets you tag places and events sharing them with your friends. You can tag places virtually \
										  by selecting a place in a map  \
										  . With this app you can share places, images and videos as well as comment \
										  on other people posts."/> 
	<meta name="Author" content="BIFI,Tedx"/>
	<meta name="Identifier" scheme="URI" content="http://www.tedx.com"/>
	<meta name="page-topic" content="geotagging, geolocalización, social network, red social,mapa"/>
	<meta name="audience" content="All"/>
	<meta name="Rating" content="General"/>
	<meta name="Distribution" content="Global"/>
        
	<link rel="shortcut icon" href="/images/favicon.ico" />
        <link rel="stylesheet" type="text/css" href="/css/common.css" />
        <link rel="stylesheet" type="text/css" href="/css/jquery-ui-1.8.9.custom.css" />
        <link rel="stylesheet" type="text/css" href="/css/jquery.fileupload-ui.css" />
        
	<script type="text/javascript" src="/js/jquery-1.6.2.min.js"></script>
        <script type="text/javascript" src="/js/jquery.json-2.2.min.js"></script>
        <script type="text/javascript" src="/js/geo.js" charset="utf-8"></script>
        <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
        <script type="text/javascript" src="/js/common.js"></script>
        <script type="text/javascript" src="/common/translation"></script>
        <script type="text/javascript" src="/js/jquery-ui-1.8.9.custom.min.js"></script>
	<script type="text/javascript" src="/js/jquery.form.js"></script>

        ${next.head()}

        <script type="text/javascript">
	  $(document).ready( function() {
	  % if not "app_message" in session:
          <%
            session['app_message'] = True
            session.save()
            %>
          var uagent = navigator.userAgent.toLowerCase();
	  
          if ((navigator.platform.search("iPhone") > -1) || (navigator.platform.search("iPod") > -1)) {
          var answer = confirm("${_(u'iphone_application_exists')}")
          if (answer) {
          window.location = "http://itunes.apple.com/app/feelicity/id452958224?mt=8";
          }
          }
	  
          if (uagent.search("android") > -1) {
          var answer = confirm("${_(u'android_application_exists')}")
          if (answer) {
          window.location = "https://market.android.com/details?id=com.bifi.feelicity";
          }
          }
          % endif
	  
          % if c.message:
          tedx_alert("${c.message}");
          % endif
          common_init();
	  ${
          next.init()}
          % if c.user:
          get_profile_data();
          %endif
          });
        </script>
    </head>
    <body>
      <div id="notification">
	<p>
	  ${_(u'Has creado tu contenido con éxito.')} ${_(u'¿Quieres compartirlo?')}
	  <a id="facebook-share-link" href="#" target="_blank">Facebook</a>&nbsp;|&nbsp;<a id="twitter-share-link" href="#" target="_blank">Twitter</a>
	</p>
	<a href="#" class="close">X</a>
      </div>

    <div id="contenedor">
	<div id="cabecera">
	  <div id="idioma" style="margin-top: 10px;">
	    <a href="javascript: change_language('es')">Español</a> / <a href="javascript: change_language('en')">English</a>
	  </div>
	  <div id="logotipo" style="float:left; margin">
	    <a href="/"><img src="/images/logo-web-fondo-transparente.png" alt="Logo Tedx"  /></a>
	  </div>
	  %if not c.user:
	  <div id="login" class="right">
	    <form id="form1" method="post" action="/common/form_login" >
	      <div id="logLeft" class="bordeHalf">
			<div for="usuario" >${_(u'usuario / email')}</div><input type="text"  name="login_email" id="login_email"></input>
			<div for="password" >${_(u'password')}</div><input type="password" name="login_password" id="login_password" onkeydown="if ((event.which && event.which == 13) || (event.keyCode && event.keyCode == 13)) {$('#form1').submit();}"></input>
			<a href="javascript: forgot_password();" id="lost" class="left">${_('forgotten_password')}</a>
			<a href="#" onclick="$('#form1').submit();" style="text-transform: uppercase;" class="accion right bordeSoft">${_(u'log_in')}</a>
	      </div>
	      <div id="logRight">
		<p>${_(u'login_question')}</p>
		<a href="javascript:register_user();" class="registro left bordeSoft" style="text-transform: uppercase;">${_(u'register')}</a>
	      </div>
	    </form>
	  </div>
	  % else:
	  <div id="login" class="right">
	  	<div id="logLeft" class="bordeHalf">
		  	<h2>${_(u'hello')} <a href="/my_account"><span class="username">${c.user.nickname}</span></a>!</h2>
		  	<span class="logOut"><a href="javascript:logout();">Salir</a></span>
		  	<div id="placesUp" class="stat"></div>
		  	<div id="commentsUp" class="stat"></div>
		  	<div id="visitsUp" class="stat"></div>
		  	<div id="likeUp" class="stat"></div>	
	  	</div>
	  	
	  	<img src="${c.user.avatar}_mid.png" width=136 height=136 alt=${c.user.nickname} />
	  	
	  </div>
	  %endif

	  <div id="MenuTop">
	  </div>
	</div>
            
	<div id="map_container">
	  <input type="hidden" id="city" value="${c.city}"/>
	  <input type="hidden" id="country" value="${c.country}"/>
	  	
	  <div class="map_legend">
	    <div id="queMapa">
	      
	      %if not c.user:
	      ${_(u'what_map')|n}
	      %else:
	      <h2 class="mom">${_(u'new_place')}</h2>
	
	      <form id="new-instant-form" action="/content/fast_new_instant" enctype="multipart/form-data">
		<label for="new-instant-txtName">${_(u'title')}: <input type="text" id="new-instant-txtName" name="new-instant-txtName" placeholder="${_(u'Nombre')}"></input></label>
		<br /><br />
		<label for="new-instant-txtDescription">${_(u'description')}:<textarea id="new-instant-txtDescription" name="new-instant-txtDescription" placeholder="${_(u'Descripción')}"></textarea></label>
		<div class="clear"></div>
		<br />
		<div>
		  <img src="/images/iconoFotografia.png" alt="Añadir imagen" /> <label>${_(u'image')}:</label>
		  <input size="12" type="file" id="new-instant-image" name="new-instant-image" /> 
		</div>
		<br />
		<div>
		  <img src="/images/iconoYoutube.png" alt="Añadir video" /> <label>${_(u'youtube')}:</label>
		  <input type="text" id="new-instant-youtube" name="new-instant-youtube" />
		</div>
		<input type="hidden" id="new-instant-txtLatitude" name="new-instant-txtLatitude" />
		<input type="hidden" id="new-instant-txtLongitude" name="new-instant-txtLongitude" />
		<input type="hidden" id="new-instant-city" name="new-instant-city"/>
		<input type="hidden" id="new-instant-country" name="new-instant-country"/>
	      </form>
	      <br /><br />
	      <a class="avanzado" href="/content">${_(u'advanced')}</a>&nbsp;&nbsp;&nbsp;<a href="javascript: new_happy_instant();" class="registro bordeSoft" id="new-instant-btnSend">${_(u'Enviar datos')}</a>
	      %endif
	    </div>
	  </div>
	  <div id="map"></div>      
	</div>

	<div id="buscarMapa" class="left  clear">
	  <label for="srch" style="float:left;padding:5px 0px;"><input type="text" id="search_string" placeholder="Buscar momentos felices" onkeydown="if ((event.which && event.which == 13) || (event.keyCode && event.keyCode == 13)) {search_query();}"></input></label>
	  <a href="javascript:void(0);" onclick="search_query();" class="left accion bordeSoft">${_(u'search')}</a>
	  <a href="javascript:void(0);" onclick="get_current_position(on_position_success, on_position_error);" class="left accion bordeSoft" id="geo">${_(u'geolocation')}</a>
	  
	</div>

	<div style="clear: both;"></div>
            
	<!-- End Save for Web Slices -->
	<div id="content">
	  ${next.content()}
	</div>
	<div class="clear">
	</div>
	
	<div id="barraFooter">
	  <div class="footer-element">
	    <a href="javascript: open_team_dialog();">${_(u'equipo')}</a>&nbsp;|&nbsp;
	    <a href="javascript: open_about_dialog();">${_(u'acerca de')}</a>&nbsp;|&nbsp;
	    <a href="javascript: open_disclaimer_dialog();">${_(u'disclaimer')}</a>&nbsp;|&nbsp;
	    <a href="javascript: send_contact_message();">${_(u'contacto')}</a>
	  </div>
	</div>
	<div class="clear">
	</div>
      </div>
      <iframe style="display:none;" id="file_download_iframe" name="file_download_iframe"></iframe>



      <!-- Dialog windows -->
      <div id="dialog-forgotten-password" title="${_(u'Recuperar contraseña')}">
	<p>
	  ${_(u'Introduce el email con el que te registraste y te enviaremos tu nueva contraseña allí.')}
	</p>
	<input type="text" id="dialog-forgotten-password-txtEmail" style="width: 200px;"/>
	<br />
	<br />
	<img id="dialog-forgotten-password-imgLoading" src="/images/loading.gif" alt="Loading image" style="height: 100px; width: 100px;" />
	<button id="dialog-forgotten-password-btnAccept">
	  ${_(u'accept')}
	</button>
	<button id="dialog-forgotten-password-btnCancel">
	  ${_(u'cancel')}
	</button>
      </div>
      <div id="dialog-registration" title="${_(u'Registro de usuario')}">
	<label for="dialog-registration-txtEmail" class="form-label">
	  ${_(u'email')}*:
	</label>
	<br />
	<input type="text" id="dialog-registration-txtEmail" maxlength="256" class="form-input" />
	<br />
	
	<label for="dialog-registration-txtContra" class="form-label">
	  ${_(u'password')}*:
	</label>
	<br />
	<input type="password" id="dialog-registration-txtContra" maxlength="32" class="form-input" />
	<br />
	
	<label for="dialog-registration-txtContraConfirmation" class="form-label">
	  ${_(u'repeat_password')}*:
	</label>
	<br />
	<input type="password" id="dialog-registration-txtContraConfirmation" maxlength="32" class="form-input" />
	<br />
	
	<label for="dialog-registration-txtNickname" class="form-label">
	  ${_(u'nickname')}*:
	</label>
	<br />
	<input type="text" id="dialog-registration-txtNickname" maxlength="32" class="form-input" />
	<br />
	
	<div id="sex_container" class="form-label">
	  ${_(u'sex')}*:
	</div>
	<label for="dialog-registration-rdMan" class="form-label">
	  ${_(u'man')}
	</label>
	<input id="dialog-registration-rdMan" name="dialog-registration-rdSex" type="radio" value="V" />
	<label for="dialog-registration-rdWoman" class="form-label">
	  ${_(u'woman')}
	</label>
	<input id="dialog-registration-rdWoman" name="dialog-registration-rdSex" type="radio" value="M" />
	
	<br />
	<br />
	<img id="dialog-registration-imgLoading" src="/images/loading.gif" alt="Loading image" style="height: 100px; width: 100px;" />
	<button id="dialog-registration-btnAccept">
	  ${_(u'accept')}
	</button>
	<button id="dialog-registration-btnCancel">
	  ${_(u'cancel')}
	</button>
      </div>
      <div id="dialog-contact" title="${_(u'Contacta con el equipo de Feelicity')}">
	<label for="dialog-contact-txtName" class="form-label">
	  ${_(u'Nombre')}:
	</label>
	<br />
	<input type="text" id="dialog-contact-txtName" class="form-input" />
	<br />
	
	<label for="dialog-contact-txtEmail" class="form-label">
	  ${_(u'email')}*:
	</label>
	<br />
	<input type="text" id="dialog-contact-txtEmail" maxlength="256" class="form-input" />
	<br />
	
	<label for="dialog-contact-txtContent" class="form-label">
	  ${_(u'Contenido')}*:
	</label>
	<br />
	<textarea id="dialog-contact-txtContent" class="form-label">
	</textarea>
	<br />
	<br />
	<img id="dialog-contact-imgLoading" src="/images/loading.gif" alt="Loading image" style="height: 100px; width: 100px;" />
	<button id="dialog-contact-btnAccept">
	  ${_(u'accept')}
	</button>
	<button id="dialog-contact-btnCancel">
	  ${_(u'cancel')}
	</button>
      </div>
      <div id="dialog-team" title="${_(u'Equipo')}">
	<div>
	  <p>Feelicity nace como un proyecto dentro de las actividades que se están organizando con motivo del I <a href="http://www.TEDxZaragoza.com" target="blank">TEDxZaragoza</a> , que se celebrará, en Zaragoza (España), el próximo 5 de Noviembre de 2011, en el que se debatirá sobre “El Futuro de la Felicidad”.</p>
	  
	  <p>Para conseguir que lo que “sólo” era una “idea feliz” de un grupo de soñadores, se convirtiera en un proyecto real, operativo, en tiempo record, y darlo a conocer de forma que tú - y otra mucha gente como tú de todos los rincones del mundo - llegara hasta aquí, ha sido necesaria la colaboración de un GRAN equipo de personas. Mención especial merece el equipo del <a href="http://www.BIFI.es" target="blank">BIFI</a> - el Instituto de Biocomputación y Física de Sistemas Complejos de la Universidad de Zaragoza - responsables de la parte técnica del proyecto, de la programación de la web y de las aplicaciones móviles y, si entre todos damos de alta un número suficiente de momentos y lugares felices, de analizar los datos y extraer de ellos conclusiones científicas sobre lo que nos hace felices.</p>
	  
	  <p>El equipo que ha hecho posible que exista Feelicity está compuesto por:</p>
	  
	  
	  <div class="team_member">
	    <div style="float:left;"><a href="http://www.fernandoval.es/" target="blank">Fernando Val </a></div>
	    <div style="float:left; width:25px;clear:left;"><img src="/images/twitter.png" width="25px" height="25px"/></div><div style="float:left; margin-top:6px;"><a href="http://www.twitter.com/aaromnido" target="blank">@aaromnido</a></div>
	    <div style="float:left; clear:left;">Diseño visual para web y iphone</div>
	  </div>
	  <div class="team_member">
	    <div style="float:left;"><a href="http://www.mamenpradel.com/" target="blank">Mamen Pradel </a></div>
	    <div style="float:left; width:25px;clear:left;"><img src="/images/twitter.png" width="25px" height="25px"/></div><div style="float:left; margin-top:6px;"><a href="http://www.twitter.com/pensieve" target="blank">@Pensieve</a></div>
	    <div style="float:left; clear:left;">Diseño Visual y de Interacción</div>
	  </div>
	  
	  <div class="team_member">
	    <div style="float:left;"><a href="http://www.sonicbyte.com/" target="blank">Pablo Jimeno </a></div>
	    <div style="float:left; width:25px;clear:left;"><img src="/images/twitter.png" width="25px" height="25px"/></div><div style="float:left; margin-top:6px;"><a href="http://www.twitter.com/pablojimeno" target="blank">@PabloJimeno</a></div>
	    <div style="float:left; clear:left;">Conceptualización y Diseño web</div>
	  </div>
	  
	  <div class="team_member">
	    <div style="float:left;"><a href="http://www.sonicbyte.com/" target="blank">Rodrigo Noales </a></div>
	    <div style="float:left; width:25px;clear:left;"><img src="/images/twitter.png" width="25px" height="25px"/></div><div style="float:left; margin-top:6px;"><a href="http://www.twitter.com/rodrigonoales" target="blank">@RodrigoNoales</a></div>
	    <div style="float:left; clear:left;">Diseño web</div>
	  </div>
	  <div class="team_member">
	    <div style="float:left;"><a href="http://www.ceconbe.es" target="blank">Lucas Aisa</a></div>
	    <div style="float:left; width:25px;clear:left;"><img src="/images/twitter.png"/ width="25px" height="25px"></div><div style="float:left; margin-top:6px;"><a href="http://www.twitter.com/CalvoConBarba" target="blank">@CalvoConBarba</a></div>
	      <div style="float:left; clear:left;">Comunicación y Redes Sociales</div>
	    </div>
	  </div>
	  <br />
	  <div style="clear:both;">
	    <button id="dialog-team-btnAccept">
	      Aceptar
	    </button>
	  </div>
	</div>
	<div id="dialog-about" title="${_(u'Acerca de')}">
	  <div>
	    <p>¿De qué va ésto?</p>
	    <p>¿Cansado de que la cara del mundo que nos muestran los medios de comunicación sea siempre triste y gris? ¿Harto de que tus buenos momentos, aquellos lugares donde has vivido momentos felices, se pierdan en el recuerdo? ¿Te gustaría construir tu propio archivo de lugares y momentos felices para que estén siempre vivos y poder así compartirlos con el mundo?</p>
	    <p>Pues eso es Feelicity. Un lugar donde ir recogiendo todas las cosas buenas que nos pasan, para conservarlas, para compartirlas, y entre todos construir un nuevo tipo de mapa del mundo, basado en las personas y en lo que les hace felices. Ni más, ni menos. ¿Estás viviendo ahora mismo un momento feliz? Regístralo para que nunca se pierda. ¿Estás pasando por un lugar que te trae buenos recuerdos? Regístralo y revive ese momento siempre que quieras entrando en la web !! ¿Te imaginas poder coger un taxi y decirle “llévenos a “El banco de mi primer beso” con “El hospital donde nació mi primer hijo”, por favor” ? Sería maravilloso, ¿no crees? Sería una perfecta muestra de <a href="http://translate.google.com/#en|es|felicity" target="_blank">Felicity</a>, que  nos permitiría verdaderamente <a href="http://translate.google.com/#en|es|feel%20the%20city" target="_blank">“Feel the city” </a>... ;)</p>
	    <p>Centrémonos todos en los buenos momentos. Cambiemos el foco hacia lo positivo, y disfrutemos de las cosas buenas que nos pasan en la vida. Posiblemente nuestra vida será mejor si todos lo hacemos así...</p>
	    <p>Sed Felices !!</p>
	  </div>
	  <div class="powered">
	    Powered By
	    <a href="http://www.streetrs.com" style="text-align:center;">Streetrs</a>
	  </div>
	  <br />
	  <button id="dialog-about-btnAccept">
	    ${_(u'accept')}
	  </button>
	</div>
	<div id="dialog-message" title="Feelicity">
	  <div id="dialog-content-message"></div>
	  <button id="dialog-message-btnAccept">${_(u'Aceptar')}</button>
	</div>
	
	<div id="dialog-disclaimer" title="${_('Disclaimer')}">
	  <p>
	    Feelicity y las entidades asociadas a la misma no se hacen responsables de las opiniones escritas por los usuarios de esta página web así como de los posibles contenidos fraudulentos que se puedan subir a la misma.
	  </p>
	</div>

	<div id="dialog-more-info" title="Más información sobre el estudio">
	  <p style="font-size:14px; text-align: justify;">
	    Desde el departamento de Bioinformación y Biología de sistemas del IACS se está realizando un estudio científico de la risa. Hasta ahora no se ha establecido la relación entre las distintas clases de risa y los estados emocionales. La risa apareció mucho antes que el habla, y la hemos estado usando como respuesta y expresión de múltiples situaciones y estados. Pero no deja de ser una señal acústica, muy parecida al lenguaje pero con una serie de características propias, temporales y frecuenciales, con una gran variabilidad. Esa variabilidad se utiliza para llevar información al oyente qué nos ha hecho reír y cómo nos sentimos. Según el ritmo y la melodía, es decir, según la duración y espaciado de la carcajada y sus frecuencias, se puede indicar si nos ha sorprendido gratamente algo, si nos gusta una persona o su forma de ser o si queremos incluir o excluír a alguien de nuestro grupo social.
	  </p>

	  <p style="font-size: 14px; text-align: justify;">
	    El poder clasificar y agrupar automáticamente esos tipos de risa serviría para entender un poco mejor nuestro comportamiento emocional. Pero el principal inconveniente es la imposibilidad de reproducir risas naturales y espontáneas en el laboratorio. Por eso, toda grabación de una situación alegre, feliz, cómica, nos ayudaría mucho. Con el móvil y simplemente una pequeña descripción del contexto (saludando a viejos amigos, riéndome con la pareja, ante un buen chiste), y si es posible sin mucho ruido o conversaciones de fondo, aportarías una información importantísima.
	  </p>
	  <br />
	</div>
	
    </body>
  </html>
