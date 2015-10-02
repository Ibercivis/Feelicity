# -*- coding: utf-8 -*-
<mako:inherit file="common.mako">
</mako:inherit>
<mako:def name="title()">
  ${_(u'view_place')}
</mako:def>
<mako:def name="head()">
  <link rel="stylesheet" type="text/css" href="/css/view.css" />
  <script type="text/javascript" src="/js/flowplayer-3.2.4.min.js"></script>
  <script type="text/javascript" src="/js/jquery.tagcloud.min.js" charset="utf-8"></script>
  <script type="text/javascript">
    var user = "${c.user}";
    var password = "${c.password}";
    var user_id;
    var place_id;
    % if c.user:
    var user_id = "${c.user.id}"
    % endif
    % if c.place_id:
    var place_id = "${c.place_id}";
    % endif
  </script >
  <script type="text/javascript" src="/js/view.js" charset="utf-8"></script>
</mako:def>

<mako:def name="init()"></mako:def>

<mako:def name="content()">
  <div id="loading_div" style="padding-top:20px; display: none">
    ${_(u'sending_processing_please_wait')}
  </div>
  <div id="new_comment_div" style="padding-top: 10px;">
    <div class="sidebarIzq">
      <br />
    </div>

    <div class="content_center">
      <h3>${_(u'happy_moments')}</h3>
      <div id="list"></div>

      <div id="srToolsDown"></div>
      <br />
      <br />

      <div id="add_comment">
	<h3>${_(u'add_comment')}</h3>
	<div id="users"></div>
	% if c.user:
	<div id="manchaIzda">
	  <div class="colDetStreetr">
	    <div id="descripcionStreetr">
	      <a class="titulo01">${_(u'comment_content')}:</a>
	      <br />
	      <br />
	      <textarea id="comment_content" class="long_textarea"></textarea>
	    </div>
	    
	    <div id="selecImages">
	      <a class="titulo01">${_(u'comment_attach')}:</a>
	      <div style="clear:both; height:20px; padding-top:10px;">
		<div id="botonSubirImg">
		  <a class="estiloAzul" href="javascript:new_attachment('image');">
		    <img src="/images/iconoFotografia.png" alt="Subir Imagen" longdesc="Click aqui para subir una nueva imagen. Tamaño Máximo 10x15.Resolución 72 dpi." />
		    ${_(u'image')}
		  </a>
		</div>
		<div id="botonYoutube">
		  <a class="estiloAzul" href="javascript:new_youtube_link();">
		    <img src="/images/iconoYoutube.png" alt="Enlazar con un video de YouTube." longdesc="Click aquí para enlazar con un video de YouTube." />
		    ${_(u'youtube')}
		  </a>
		</div>
	      </div>
	      
	      <div id="link" title="link">
		<form>
		  <fieldset>
		    <input type="text" id="youtube_link" name="file">
		    </input>
		  </fieldset>
		</form>
	      </div>
	      
	      <div id="files"></div>
	      <iframe style="display:none;" id="file_upload_iframe" name="file_upload_iframe"></iframe>
	    </div>

	    <div id="tags_content">
	      <a class="titulo01">${_(u'comment_tags')}:</a>
	      <div style="height: 100px; margin-top: 10px; margin-bottom: 10px;">
		<ul id="cloud" class="xmpl">
		</ul>
	      </div>
	      <input type="text" id="comment_tags" class="long_input" />
	      <div id="numCaracter">
		${_(u'write_tags_comma_separated_or_click')}
	      </div>
	    </div>
	  
	    <a href="javascript:void(0);" onclick="new_comment();" style="float:right; clear:both; color:white; text-decoration:none;" class="accion">${_(u'save')}</a>
	  </div>
	</div>
	%else:
	${_(u'login_first_to_comment')} <!-- Para hacer un comentario hace falta hacer login primero -->
	% endif
      </div>
    </div>

    <div class="sidebarDer">
      <div id="logos">
	<h3>${_(u'idea')}:</h3>
	<a href="http://tedxzaragoza.com"><img src="/images/TEDx_logo.png" alt="Logo TEDx Zaragoza" /></a>
	<h3>${_(u'developed')}:</h3>
	<a href="http://bifi.es"><img src="/images/BIFI_logo.png" alt="Logo BIFI" /></a>
	<a href="http://www.ibercivis.es"><img src="/images/logo_fundacion.png" alt="Logo Fundación Ibercivis" /></a>
      </div>

      <h3>${_(u'follow_us')}:</h3>
      <a href="http://www.facebook.com/FeelicityApp" target="_blank">
	<img src="/images/facebook.png"  class="left social" />
      </a>
      <a href="http://www.twitter.com/FeelicityApp" target="_blank">
	<img src="/images/twitter.png" class="left social" />
      </a>

      <h3>${_(u'available')}:</h3>
      <a href="http://itunes.apple.com/app/feelicity/id452958224?mt=8" target="_blank">
	<img src="/images/imovil.png" class="left" />
      </a>
      <a href="https://market.android.com/details?id=com.bifi.feelicity" target="_blank">
	<img src="/images/androidmovil.png" class="left" />
      </a>

      <h3>${_(u'happy_cities')}:</h3>
      <div id="happy_cities">
      </div>
    </div>
    
    <div id="attachment_modal" title="Attachment" style="z-index: 9999;"></div>
</mako:def>
