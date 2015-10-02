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

                <div id="MainContent">
                    ${next.MainContent()}
                </div>

            </div>
            <div id="map"></div>      
        </div>
        <%include file="search_map.mako"/>


        <div style="clear: both;"></div>

        <div id="content">${next.content()}</div>
        <div class="clear"></div>

        <div id="barraFooter">
            <div class="footer-element centerize">
                <a href="javascript: open_team_dialog();">${_(u'Equipo')}</a>&nbsp;&nbsp;|&nbsp;&nbsp;
                <a href="javascript: open_about_dialog();">${_(u'Acerca de')}</a>&nbsp;&nbsp;|&nbsp;&nbsp;
                <a href="javascript: open_disclaimer_dialog();">${_(u'Responsabilidades')}</a>&nbsp;&nbsp;|&nbsp;&nbsp;
                <a href="javascript: send_contact_message();">${_(u'Contacto')}</a>
            </div>
        </div>
        <div class="clear"></div>
     </div>
     <iframe style="display:none;" id="file_download_iframe" name="file_download_iframe"></iframe>
        <%include file="dialog_contact.mako"/>
        <%include file="dialog_team.mako"/>
        <%include file="dialog_about.mako"/>
        <%include file="dialog_moreinformation.mako"/>
    </body>
</html>
