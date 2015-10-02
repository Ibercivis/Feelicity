# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 6
_modified_time = 1394727178.75563
_template_filename=u'/var/www/feelicity/current/tedx/templates/common.mako'
_template_uri=u'/common.mako'
_template_cache=cache.Cache(__name__, _modified_time)
_source_encoding='utf-8'
from webhelpers.html import escape
_exports = []


def render_body(context,**pageargs):
    context.caller_stack._push_frame()
    try:
        __M_locals = __M_dict_builtin(pageargs=pageargs)
        c = context.get('c', UNDEFINED)
        session = context.get('session', UNDEFINED)
        _ = context.get('_', UNDEFINED)
        next = context.get('next', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 2
        __M_writer(u'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> \n<html xmlns="http://www.w3.org/1999/xhtml">\n    <head>\n        <title>Feelicity - ')
        # SOURCE LINE 5
        __M_writer(escape(next.title()))
        __M_writer(u'</title>\n        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>\n\t<meta name="Keywords" content="quality, water, geotagging, geolocalizaci\xf3n, social network, red social, mapa"/>\n    <meta name="Description" content="Aqua ibercivis lets you tag water quality places and sharing them with your friends.')
        # SOURCE LINE 9
        __M_writer(u'\t\t\t\t\t\t\t\t\t\t  by selecting a place in a map  ')
        # SOURCE LINE 10
        __M_writer(u'                                          . With this app you can share water qualitys, images and videos as well as comment ')
        # SOURCE LINE 11
        __M_writer(u'\t\t\t\t\t\t\t\t\t\t  on other people posts."/> \n                                          <meta name="Author" content="Ibercivis"/>\n\t<meta name="Identifier" scheme="URI" content="http://aqua.ibercivis.es"/>\n    <meta name="page-topic" content="water,quality,geotagging, geolocalizaci\xf3n, social network, red social,mapa"/>\n\t<meta name="audience" content="All"/>\n\t<meta name="Rating" content="General"/>\n\t<meta name="Distribution" content="Global"/>\n        \n\t<link rel="shortcut icon" href="/images/favicon.ico" />\n        <link rel="stylesheet" type="text/css" href="/css/common.css" />\n        <link rel="stylesheet" type="text/css" href="/css/jquery-ui-1.8.9.custom.css" />\n        <link rel="stylesheet" type="text/css" href="/css/jquery.fileupload-ui.css" />\n        \n\t<script type="text/javascript" src="/js/jquery-1.6.2.min.js"></script>\n        <script type="text/javascript" src="/js/jquery.json-2.2.min.js"></script>\n        <script type="text/javascript" src="/js/geo.js" charset="utf-8"></script>\n        <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>\n        <script type="text/javascript" src="/js/common.js"></script>\n        <script type="text/javascript" src="/common/translation"></script>\n        <script type="text/javascript" src="/js/jquery-ui-1.8.9.custom.min.js"></script>\n\t<script type="text/javascript" src="/js/jquery.form.js"></script>\n\n        ')
        # SOURCE LINE 33
        __M_writer(escape(next.head()))
        __M_writer(u'\n\n        <script type="text/javascript">\n\t  $(document).ready( function() {\n')
        # SOURCE LINE 37
        if not "app_message" in session:
            # SOURCE LINE 38
            __M_writer(u'          ')

            session['app_message'] = True
            session.save()
            
            
            # SOURCE LINE 41
            __M_writer(u'\n          var uagent = navigator.userAgent.toLowerCase();\n\t  \n          if ((navigator.platform.search("iPhone") > -1) || (navigator.platform.search("iPod") > -1)) {\n          var answer = confirm("')
            # SOURCE LINE 45
            __M_writer(escape(_(u'iphone_application_exists')))
            __M_writer(u'")\n          if (answer) {\n          window.location = "http://itunes.apple.com/app/feelicity/id452958224?mt=8";\n          }\n          }\n\t  \n          if (uagent.search("android") > -1) {\n          var answer = confirm("')
            # SOURCE LINE 52
            __M_writer(escape(_(u'android_application_exists')))
            __M_writer(u'")\n          if (answer) {\n          window.location = "https://market.android.com/details?id=com.bifi.feelicity";\n          }\n          }\n')
            pass
        # SOURCE LINE 58
        __M_writer(u'\t  \n')
        # SOURCE LINE 59
        if c.message:
            # SOURCE LINE 60
            __M_writer(u'          tedx_alert("')
            __M_writer(escape(c.message))
            __M_writer(u'");\n')
            pass
        # SOURCE LINE 62
        __M_writer(u'          common_init();\n\t  ')
        # SOURCE LINE 63
        __M_writer(escape(
          next.init()))
        # SOURCE LINE 64
        __M_writer(u'\n')
        # SOURCE LINE 65
        if c.user:
            # SOURCE LINE 66
            __M_writer(u'          get_profile_data();\n')
            pass
        # SOURCE LINE 68
        __M_writer(u'          });\n        </script>\n    </head>\n    <body>\n      <div id="notification">\n\t<p>\n\t  ')
        # SOURCE LINE 74
        __M_writer(escape(_(u'Has creado tu contenido con éxito.')))
        __M_writer(u' ')
        __M_writer(escape(_(u'¿Quieres compartirlo?')))
        __M_writer(u'\n\t  <a id="facebook-share-link" href="#" target="_blank">Facebook</a>&nbsp;|&nbsp;<a id="twitter-share-link" href="#" target="_blank">Twitter</a>\n\t</p>\n\t<a href="#" class="close">X</a>\n      </div>\n\n    <div id="contenedor">\n\t<div id="cabecera">\n\t  <div id="idioma" style="margin-top: 10px;">\n\t    <a href="javascript: change_language(\'es\')">Espa\xf1ol</a> / <a href="javascript: change_language(\'en\')">English</a>\n\t  </div>\n\t  <div id="logotipo" style="float:left; margin">\n\t    <a href="/"><img src="/images/logo-web-fondo-transparente.png" alt="Logo Tedx"  /></a>\n\t  </div>\n')
        # SOURCE LINE 88
        if not c.user:
            # SOURCE LINE 89
            __M_writer(u'\t  <div id="login" class="right">\n\t    <form id="form1" method="post" action="/common/form_login" >\n\t      <div id="logLeft" class="bordeHalf">\n\t\t\t<div for="usuario" >')
            # SOURCE LINE 92
            __M_writer(escape(_(u'usuario / email')))
            __M_writer(u'</div><input type="text"  name="login_email" id="login_email"></input>\n\t\t\t<div for="password" >')
            # SOURCE LINE 93
            __M_writer(escape(_(u'password')))
            __M_writer(u'</div><input type="password" name="login_password" id="login_password" onkeydown="if ((event.which && event.which == 13) || (event.keyCode && event.keyCode == 13)) {$(\'#form1\').submit();}"></input>\n\t\t\t<a href="javascript: forgot_password();" id="lost" class="left">')
            # SOURCE LINE 94
            __M_writer(escape(_('forgotten_password')))
            __M_writer(u'</a>\n\t\t\t<a href="#" onclick="$(\'#form1\').submit();" style="text-transform: uppercase;" class="accion right bordeSoft">')
            # SOURCE LINE 95
            __M_writer(escape(_(u'log_in')))
            __M_writer(u'</a>\n\t      </div>\n\t      <div id="logRight">\n\t\t<p>')
            # SOURCE LINE 98
            __M_writer(escape(_(u'login_question')))
            __M_writer(u'</p>\n\t\t<a href="javascript:register_user();" class="registro left bordeSoft" style="text-transform: uppercase;">')
            # SOURCE LINE 99
            __M_writer(escape(_(u'register')))
            __M_writer(u'</a>\n\t      </div>\n\t    </form>\n\t  </div>\n')
            # SOURCE LINE 103
        else:
            # SOURCE LINE 104
            __M_writer(u'\t  <div id="login" class="right">\n\t  \t<div id="logLeft" class="bordeHalf">\n\t\t  \t<h2>')
            # SOURCE LINE 106
            __M_writer(escape(_(u'hello')))
            __M_writer(u' <a href="/my_account"><span class="username">')
            __M_writer(escape(c.user.nickname))
            __M_writer(u'</span></a>!</h2>\n\t\t  \t<span class="logOut"><a href="javascript:logout();">Salir</a></span>\n\t\t  \t<div id="placesUp" class="stat"></div>\n\t\t  \t<div id="commentsUp" class="stat"></div>\n\t\t  \t<div id="visitsUp" class="stat"></div>\n\t\t  \t<div id="likeUp" class="stat"></div>\t\n\t  \t</div>\n\t  \t\n\t  \t<img src="')
            # SOURCE LINE 114
            __M_writer(escape(c.user.avatar))
            __M_writer(u'_mid.png" width=136 height=136 alt=')
            __M_writer(escape(c.user.nickname))
            __M_writer(u' />\n\t  \t\n\t  </div>\n')
            pass
        # SOURCE LINE 118
        __M_writer(u'\n\t  <div id="MenuTop">\n\t  </div>\n\t</div>\n            \n\t<div id="map_container">\n\t  <input type="hidden" id="city" value="')
        # SOURCE LINE 124
        __M_writer(escape(c.city))
        __M_writer(u'"/>\n\t  <input type="hidden" id="country" value="')
        # SOURCE LINE 125
        __M_writer(escape(c.country))
        __M_writer(u'"/>\n\t  \t\n\t  <div class="map_legend">\n\t    <div id="queMapa">\n\t      \n')
        # SOURCE LINE 130
        if not c.user:
            # SOURCE LINE 131
            __M_writer(u'\t      ')
            __M_writer(_(u'what_map'))
            __M_writer(u'\n')
            # SOURCE LINE 132
        else:
            # SOURCE LINE 133
            __M_writer(u'\t      <h2 class="mom">')
            __M_writer(escape(_(u'new_place')))
            __M_writer(u'</h2>\n\t\n\t      <form id="new-instant-form" action="/content/fast_new_instant" enctype="multipart/form-data">\n\t\t<label for="new-instant-txtName">')
            # SOURCE LINE 136
            __M_writer(escape(_(u'title')))
            __M_writer(u': <input type="text" id="new-instant-txtName" name="new-instant-txtName" placeholder="')
            __M_writer(escape(_(u'Nombre')))
            __M_writer(u'"></input></label>\n\t\t<br /><br />\n\t\t<label for="new-instant-txtDescription">')
            # SOURCE LINE 138
            __M_writer(escape(_(u'description')))
            __M_writer(u':<textarea id="new-instant-txtDescription" name="new-instant-txtDescription" placeholder="')
            __M_writer(escape(_(u'Descripción')))
            __M_writer(u'"></textarea></label>\n\t\t<div class="clear"></div>\n\t\t<br />\n\t\t<div>\n\t\t  <img src="/images/iconoFotografia.png" alt="A\xf1adir imagen" /> <label>')
            # SOURCE LINE 142
            __M_writer(escape(_(u'image')))
            __M_writer(u':</label>\n\t\t  <input size="12" type="file" id="new-instant-image" name="new-instant-image" /> \n\t\t</div>\n\t\t<br />\n\t\t<div>\n\t\t  <img src="/images/iconoYoutube.png" alt="A\xf1adir video" /> <label>')
            # SOURCE LINE 147
            __M_writer(escape(_(u'youtube')))
            __M_writer(u':</label>\n\t\t  <input type="text" id="new-instant-youtube" name="new-instant-youtube" />\n\t\t</div>\n\t\t<input type="hidden" id="new-instant-txtLatitude" name="new-instant-txtLatitude" />\n\t\t<input type="hidden" id="new-instant-txtLongitude" name="new-instant-txtLongitude" />\n\t\t<input type="hidden" id="new-instant-city" name="new-instant-city"/>\n\t\t<input type="hidden" id="new-instant-country" name="new-instant-country"/>\n\t      </form>\n\t      <br /><br />\n\t      <a class="avanzado" href="/content">')
            # SOURCE LINE 156
            __M_writer(escape(_(u'advanced')))
            __M_writer(u'</a>&nbsp;&nbsp;&nbsp;<a href="javascript: new_happy_instant();" class="registro bordeSoft" id="new-instant-btnSend">')
            __M_writer(escape(_(u'Enviar datos')))
            __M_writer(u'</a>\n')
            pass
        # SOURCE LINE 158
        __M_writer(u'\t    </div>\n\t  </div>\n\t  <div id="map"></div>      \n\t</div>\n\n\t<div id="buscarMapa" class="left  clear">\n\t  <label for="srch" style="float:left;padding:5px 0px;"><input type="text" id="search_string" placeholder="Buscar momentos felices" onkeydown="if ((event.which && event.which == 13) || (event.keyCode && event.keyCode == 13)) {search_query();}"></input></label>\n\t  <a href="javascript:void(0);" onclick="search_query();" class="left accion bordeSoft">')
        # SOURCE LINE 165
        __M_writer(escape(_(u'search')))
        __M_writer(u'</a>\n\t  <a href="javascript:void(0);" onclick="get_current_position(on_position_success, on_position_error);" class="left accion bordeSoft" id="geo">')
        # SOURCE LINE 166
        __M_writer(escape(_(u'geolocation')))
        __M_writer(u'</a>\n\t  \n\t</div>\n\n\t<div style="clear: both;"></div>\n            \n\t<!-- End Save for Web Slices -->\n\t<div id="content">\n\t  ')
        # SOURCE LINE 174
        __M_writer(escape(next.content()))
        __M_writer(u'\n\t</div>\n\t<div class="clear">\n\t</div>\n\t\n\t<div id="barraFooter">\n\t  <div class="footer-element">\n\t    <a href="javascript: open_team_dialog();">')
        # SOURCE LINE 181
        __M_writer(escape(_(u'equipo')))
        __M_writer(u'</a>&nbsp;|&nbsp;\n\t    <a href="javascript: open_about_dialog();">')
        # SOURCE LINE 182
        __M_writer(escape(_(u'acerca de')))
        __M_writer(u'</a>&nbsp;|&nbsp;\n\t    <a href="javascript: open_disclaimer_dialog();">')
        # SOURCE LINE 183
        __M_writer(escape(_(u'disclaimer')))
        __M_writer(u'</a>&nbsp;|&nbsp;\n\t    <a href="javascript: send_contact_message();">')
        # SOURCE LINE 184
        __M_writer(escape(_(u'contacto')))
        __M_writer(u'</a>\n\t  </div>\n\t</div>\n\t<div class="clear">\n\t</div>\n      </div>\n      <iframe style="display:none;" id="file_download_iframe" name="file_download_iframe"></iframe>\n\n\n\n      <!-- Dialog windows -->\n      <div id="dialog-forgotten-password" title="')
        # SOURCE LINE 195
        __M_writer(escape(_(u'Recuperar contraseña')))
        __M_writer(u'">\n\t<p>\n\t  ')
        # SOURCE LINE 197
        __M_writer(escape(_(u'Introduce el email con el que te registraste y te enviaremos tu nueva contraseña allí.')))
        __M_writer(u'\n\t</p>\n\t<input type="text" id="dialog-forgotten-password-txtEmail" style="width: 200px;"/>\n\t<br />\n\t<br />\n\t<img id="dialog-forgotten-password-imgLoading" src="/images/loading.gif" alt="Loading image" style="height: 100px; width: 100px;" />\n\t<button id="dialog-forgotten-password-btnAccept">\n\t  ')
        # SOURCE LINE 204
        __M_writer(escape(_(u'accept')))
        __M_writer(u'\n\t</button>\n\t<button id="dialog-forgotten-password-btnCancel">\n\t  ')
        # SOURCE LINE 207
        __M_writer(escape(_(u'cancel')))
        __M_writer(u'\n\t</button>\n      </div>\n      <div id="dialog-registration" title="')
        # SOURCE LINE 210
        __M_writer(escape(_(u'Registro de usuario')))
        __M_writer(u'">\n\t<label for="dialog-registration-txtEmail" class="form-label">\n\t  ')
        # SOURCE LINE 212
        __M_writer(escape(_(u'email')))
        __M_writer(u'*:\n\t</label>\n\t<br />\n\t<input type="text" id="dialog-registration-txtEmail" maxlength="256" class="form-input" />\n\t<br />\n\t\n\t<label for="dialog-registration-txtContra" class="form-label">\n\t  ')
        # SOURCE LINE 219
        __M_writer(escape(_(u'password')))
        __M_writer(u'*:\n\t</label>\n\t<br />\n\t<input type="password" id="dialog-registration-txtContra" maxlength="32" class="form-input" />\n\t<br />\n\t\n\t<label for="dialog-registration-txtContraConfirmation" class="form-label">\n\t  ')
        # SOURCE LINE 226
        __M_writer(escape(_(u'repeat_password')))
        __M_writer(u'*:\n\t</label>\n\t<br />\n\t<input type="password" id="dialog-registration-txtContraConfirmation" maxlength="32" class="form-input" />\n\t<br />\n\t\n\t<label for="dialog-registration-txtNickname" class="form-label">\n\t  ')
        # SOURCE LINE 233
        __M_writer(escape(_(u'nickname')))
        __M_writer(u'*:\n\t</label>\n\t<br />\n\t<input type="text" id="dialog-registration-txtNickname" maxlength="32" class="form-input" />\n\t<br />\n\t\n\t<div id="sex_container" class="form-label">\n\t  ')
        # SOURCE LINE 240
        __M_writer(escape(_(u'sex')))
        __M_writer(u'*:\n\t</div>\n\t<label for="dialog-registration-rdMan" class="form-label">\n\t  ')
        # SOURCE LINE 243
        __M_writer(escape(_(u'man')))
        __M_writer(u'\n\t</label>\n\t<input id="dialog-registration-rdMan" name="dialog-registration-rdSex" type="radio" value="V" />\n\t<label for="dialog-registration-rdWoman" class="form-label">\n\t  ')
        # SOURCE LINE 247
        __M_writer(escape(_(u'woman')))
        __M_writer(u'\n\t</label>\n\t<input id="dialog-registration-rdWoman" name="dialog-registration-rdSex" type="radio" value="M" />\n\t\n\t<br />\n\t<br />\n\t<img id="dialog-registration-imgLoading" src="/images/loading.gif" alt="Loading image" style="height: 100px; width: 100px;" />\n\t<button id="dialog-registration-btnAccept">\n\t  ')
        # SOURCE LINE 255
        __M_writer(escape(_(u'accept')))
        __M_writer(u'\n\t</button>\n\t<button id="dialog-registration-btnCancel">\n\t  ')
        # SOURCE LINE 258
        __M_writer(escape(_(u'cancel')))
        __M_writer(u'\n\t</button>\n      </div>\n      <div id="dialog-contact" title="')
        # SOURCE LINE 261
        __M_writer(escape(_(u'Contacta con el equipo de Feelicity')))
        __M_writer(u'">\n\t<label for="dialog-contact-txtName" class="form-label">\n\t  ')
        # SOURCE LINE 263
        __M_writer(escape(_(u'Nombre')))
        __M_writer(u':\n\t</label>\n\t<br />\n\t<input type="text" id="dialog-contact-txtName" class="form-input" />\n\t<br />\n\t\n\t<label for="dialog-contact-txtEmail" class="form-label">\n\t  ')
        # SOURCE LINE 270
        __M_writer(escape(_(u'email')))
        __M_writer(u'*:\n\t</label>\n\t<br />\n\t<input type="text" id="dialog-contact-txtEmail" maxlength="256" class="form-input" />\n\t<br />\n\t\n\t<label for="dialog-contact-txtContent" class="form-label">\n\t  ')
        # SOURCE LINE 277
        __M_writer(escape(_(u'Contenido')))
        __M_writer(u'*:\n\t</label>\n\t<br />\n\t<textarea id="dialog-contact-txtContent" class="form-label">\n\t</textarea>\n\t<br />\n\t<br />\n\t<img id="dialog-contact-imgLoading" src="/images/loading.gif" alt="Loading image" style="height: 100px; width: 100px;" />\n\t<button id="dialog-contact-btnAccept">\n\t  ')
        # SOURCE LINE 286
        __M_writer(escape(_(u'accept')))
        __M_writer(u'\n\t</button>\n\t<button id="dialog-contact-btnCancel">\n\t  ')
        # SOURCE LINE 289
        __M_writer(escape(_(u'cancel')))
        __M_writer(u'\n\t</button>\n      </div>\n      <div id="dialog-team" title="')
        # SOURCE LINE 292
        __M_writer(escape(_(u'Equipo')))
        __M_writer(u'">\n\t<div>\n\t  <p>Feelicity nace como un proyecto dentro de las actividades que se est\xe1n organizando con motivo del I <a href="http://www.TEDxZaragoza.com" target="blank">TEDxZaragoza</a> , que se celebrar\xe1, en Zaragoza (Espa\xf1a), el pr\xf3ximo 5 de Noviembre de 2011, en el que se debatir\xe1 sobre \u201cEl Futuro de la Felicidad\u201d.</p>\n\t  \n\t  <p>Para conseguir que lo que \u201cs\xf3lo\u201d era una \u201cidea feliz\u201d de un grupo de so\xf1adores, se convirtiera en un proyecto real, operativo, en tiempo record, y darlo a conocer de forma que t\xfa - y otra mucha gente como t\xfa de todos los rincones del mundo - llegara hasta aqu\xed, ha sido necesaria la colaboraci\xf3n de un GRAN equipo de personas. Menci\xf3n especial merece el equipo del <a href="http://www.BIFI.es" target="blank">BIFI</a> - el Instituto de Biocomputaci\xf3n y F\xedsica de Sistemas Complejos de la Universidad de Zaragoza - responsables de la parte t\xe9cnica del proyecto, de la programaci\xf3n de la web y de las aplicaciones m\xf3viles y, si entre todos damos de alta un n\xfamero suficiente de momentos y lugares felices, de analizar los datos y extraer de ellos conclusiones cient\xedficas sobre lo que nos hace felices.</p>\n\t  \n\t  <p>El equipo que ha hecho posible que exista Feelicity est\xe1 compuesto por:</p>\n\t  \n\t  \n\t  <div class="team_member">\n\t    <div style="float:left;"><a href="http://www.fernandoval.es/" target="blank">Fernando Val </a></div>\n\t    <div style="float:left; width:25px;clear:left;"><img src="/images/twitter.png" width="25px" height="25px"/></div><div style="float:left; margin-top:6px;"><a href="http://www.twitter.com/aaromnido" target="blank">@aaromnido</a></div>\n\t    <div style="float:left; clear:left;">Dise\xf1o visual para web y iphone</div>\n\t  </div>\n\t  <div class="team_member">\n\t    <div style="float:left;"><a href="http://www.mamenpradel.com/" target="blank">Mamen Pradel </a></div>\n\t    <div style="float:left; width:25px;clear:left;"><img src="/images/twitter.png" width="25px" height="25px"/></div><div style="float:left; margin-top:6px;"><a href="http://www.twitter.com/pensieve" target="blank">@Pensieve</a></div>\n\t    <div style="float:left; clear:left;">Dise\xf1o Visual y de Interacci\xf3n</div>\n\t  </div>\n\t  \n\t  <div class="team_member">\n\t    <div style="float:left;"><a href="http://www.sonicbyte.com/" target="blank">Pablo Jimeno </a></div>\n\t    <div style="float:left; width:25px;clear:left;"><img src="/images/twitter.png" width="25px" height="25px"/></div><div style="float:left; margin-top:6px;"><a href="http://www.twitter.com/pablojimeno" target="blank">@PabloJimeno</a></div>\n\t    <div style="float:left; clear:left;">Conceptualizaci\xf3n y Dise\xf1o web</div>\n\t  </div>\n\t  \n\t  <div class="team_member">\n\t    <div style="float:left;"><a href="http://www.sonicbyte.com/" target="blank">Rodrigo Noales </a></div>\n\t    <div style="float:left; width:25px;clear:left;"><img src="/images/twitter.png" width="25px" height="25px"/></div><div style="float:left; margin-top:6px;"><a href="http://www.twitter.com/rodrigonoales" target="blank">@RodrigoNoales</a></div>\n\t    <div style="float:left; clear:left;">Dise\xf1o web</div>\n\t  </div>\n\t  <div class="team_member">\n\t    <div style="float:left;"><a href="http://www.ceconbe.es" target="blank">Lucas Aisa</a></div>\n\t    <div style="float:left; width:25px;clear:left;"><img src="/images/twitter.png"/ width="25px" height="25px"></div><div style="float:left; margin-top:6px;"><a href="http://www.twitter.com/CalvoConBarba" target="blank">@CalvoConBarba</a></div>\n\t      <div style="float:left; clear:left;">Comunicaci\xf3n y Redes Sociales</div>\n\t    </div>\n\t  </div>\n\t  <br />\n\t  <div style="clear:both;">\n\t    <button id="dialog-team-btnAccept">\n\t      Aceptar\n\t    </button>\n\t  </div>\n\t</div>\n\t<div id="dialog-about" title="')
        # SOURCE LINE 336
        __M_writer(escape(_(u'Acerca de')))
        __M_writer(u'">\n\t  <div>\n\t    <p>\xbfDe qu\xe9 va \xe9sto?</p>\n\t    <p>\xbfCansado de que la cara del mundo que nos muestran los medios de comunicaci\xf3n sea siempre triste y gris? \xbfHarto de que tus buenos momentos, aquellos lugares donde has vivido momentos felices, se pierdan en el recuerdo? \xbfTe gustar\xeda construir tu propio archivo de lugares y momentos felices para que est\xe9n siempre vivos y poder as\xed compartirlos con el mundo?</p>\n\t    <p>Pues eso es Feelicity. Un lugar donde ir recogiendo todas las cosas buenas que nos pasan, para conservarlas, para compartirlas, y entre todos construir un nuevo tipo de mapa del mundo, basado en las personas y en lo que les hace felices. Ni m\xe1s, ni menos. \xbfEst\xe1s viviendo ahora mismo un momento feliz? Reg\xedstralo para que nunca se pierda. \xbfEst\xe1s pasando por un lugar que te trae buenos recuerdos? Reg\xedstralo y revive ese momento siempre que quieras entrando en la web !! \xbfTe imaginas poder coger un taxi y decirle \u201cll\xe9venos a \u201cEl banco de mi primer beso\u201d con \u201cEl hospital donde naci\xf3 mi primer hijo\u201d, por favor\u201d ? Ser\xeda maravilloso, \xbfno crees? Ser\xeda una perfecta muestra de <a href="http://translate.google.com/#en|es|felicity" target="_blank">Felicity</a>, que  nos permitir\xeda verdaderamente <a href="http://translate.google.com/#en|es|feel%20the%20city" target="_blank">\u201cFeel the city\u201d </a>... ;)</p>\n\t    <p>Centr\xe9monos todos en los buenos momentos. Cambiemos el foco hacia lo positivo, y disfrutemos de las cosas buenas que nos pasan en la vida. Posiblemente nuestra vida ser\xe1 mejor si todos lo hacemos as\xed...</p>\n\t    <p>Sed Felices !!</p>\n\t  </div>\n\t  <div class="powered">\n\t    Powered By\n\t    <a href="http://www.streetrs.com" style="text-align:center;">Streetrs</a>\n\t  </div>\n\t  <br />\n\t  <button id="dialog-about-btnAccept">\n\t    ')
        # SOURCE LINE 350
        __M_writer(escape(_(u'accept')))
        __M_writer(u'\n\t  </button>\n\t</div>\n\t<div id="dialog-message" title="Feelicity">\n\t  <div id="dialog-content-message"></div>\n\t  <button id="dialog-message-btnAccept">')
        # SOURCE LINE 355
        __M_writer(escape(_(u'Aceptar')))
        __M_writer(u'</button>\n\t</div>\n\t\n\t<div id="dialog-disclaimer" title="')
        # SOURCE LINE 358
        __M_writer(escape(_('Disclaimer')))
        __M_writer(u'">\n\t  <p>\n\t    Feelicity y las entidades asociadas a la misma no se hacen responsables de las opiniones escritas por los usuarios de esta p\xe1gina web as\xed como de los posibles contenidos fraudulentos que se puedan subir a la misma.\n\t  </p>\n\t</div>\n\n\t<div id="dialog-more-info" title="M\xe1s informaci\xf3n sobre el estudio">\n\t  <p style="font-size:14px; text-align: justify;">\n\t    Desde el departamento de Bioinformaci\xf3n y Biolog\xeda de sistemas del IACS se est\xe1 realizando un estudio cient\xedfico de la risa. Hasta ahora no se ha establecido la relaci\xf3n entre las distintas clases de risa y los estados emocionales. La risa apareci\xf3 mucho antes que el habla, y la hemos estado usando como respuesta y expresi\xf3n de m\xfaltiples situaciones y estados. Pero no deja de ser una se\xf1al ac\xfastica, muy parecida al lenguaje pero con una serie de caracter\xedsticas propias, temporales y frecuenciales, con una gran variabilidad. Esa variabilidad se utiliza para llevar informaci\xf3n al oyente qu\xe9 nos ha hecho re\xedr y c\xf3mo nos sentimos. Seg\xfan el ritmo y la melod\xeda, es decir, seg\xfan la duraci\xf3n y espaciado de la carcajada y sus frecuencias, se puede indicar si nos ha sorprendido gratamente algo, si nos gusta una persona o su forma de ser o si queremos incluir o exclu\xedr a alguien de nuestro grupo social.\n\t  </p>\n\n\t  <p style="font-size: 14px; text-align: justify;">\n\t    El poder clasificar y agrupar autom\xe1ticamente esos tipos de risa servir\xeda para entender un poco mejor nuestro comportamiento emocional. Pero el principal inconveniente es la imposibilidad de reproducir risas naturales y espont\xe1neas en el laboratorio. Por eso, toda grabaci\xf3n de una situaci\xf3n alegre, feliz, c\xf3mica, nos ayudar\xeda mucho. Con el m\xf3vil y simplemente una peque\xf1a descripci\xf3n del contexto (saludando a viejos amigos, ri\xe9ndome con la pareja, ante un buen chiste), y si es posible sin mucho ruido o conversaciones de fondo, aportar\xedas una informaci\xf3n important\xedsima.\n\t  </p>\n\t  <br />\n\t</div>\n\t\n    </body>\n  </html>\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


