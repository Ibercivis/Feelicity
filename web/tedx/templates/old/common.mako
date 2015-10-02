# -*- coding: utf-8 -*-
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>AQUA - ${next.title()}</title>
        <%include file="meta.mako"/>
        
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
            %if not "app_message" in session:
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
            ${next.init()}

            % if c.user:
                get_profile_data();
            %endif
        });
    </script>
</head>

    <body>
    <%include file="messages.mako"/>
    <%include file="cabecera.mako"/>
            
	<div id="map_container">
	  <input type="hidden" id="city" value="${c.city}"/>
	  <input type="hidden" id="country" value="${c.country}"/>
	  	
      <div class="map_legend">
          <div id="queMapa">

            %if not c.user:
                <div>
                <h2>${_(u'Controla el agua que bebes')}</h2>
                <p>${_(u'Si hay algo que merece nuestra atención y cuidado, eso es el agua que bebemos todos los dias. Tanto si vives en un pueblo aislado  o en una ciudad con tramos de tubería muy largos, queremos que nos ayudes a controlar si los niveles de" cloro en nuestros grifos son  los adecuados para el consumo. Aquí puedes compartir el resultado de analizar el agua de tu casa, o el de la fuente de tu parque, el que encuentre en tus viajes...')}</p>
                </div>
                <div class="centerize">
                    <a href="javascript:register_user();" class="left accion bordeSoft" style="text-transform: uppercase;" id="grande">
                    ${_(u'Entrar')}
                </a>    
                <a href="/register">holita</a>


            </div>
	    %endif
	    </div>
	  </div>
	  <div id="map"></div>      
	</div>

	<div id="buscarMapa" class="left  clear">
        <label for="srch" style="float:left;padding:5px 0px;">
            <input type="text" id="search_string" placeholder="${_(u'Encuentra una muestra')}" onkeydown="if ((event.which && event.which == 13) || (event.keyCode && event.keyCode == 13)) {search_query();}"></input>
        </label>
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

    <%include file="dialog_forgotpassword.mako"/>
    <%include file="dialog_registration.mako"/>
    <%include file="dialog_start.mako"/>
    <%include file="dialog_contact.mako"/>
    <%include file="dialog_team.mako"/>
    <%include file="dialog_about.mako"/>
    <%include file="dialog_moreinformation.mako"/>
	
    </body>
  </html>
