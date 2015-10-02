# -*- coding: utf-8 -*-
<mako:inherit file="common.mako"/>
<mako:def name="title()">
  ${_(u'new_streetit')}
</mako:def>
<mako:def name="head()">
  <script type="text/javascript" src="/js/content.js" charset="utf-8">
  </script>
  <script type="text/javascript" src="/js/jquery.tagcloud.min.js" charset="utf-8">
  </script>
  <link rel="stylesheet" type="text/css" href="/css/content.css" />
</script>
<script type="text/javascript">
  % if c.place:
  var edit_place_id = "${c.place.id}";
  % else:
  var edit_place_id = "";
  % endif
</script>
<script type="text/javascript">
  var a2a_config = a2a_config || {};
  a2a_config.linkname = "Streetrs.com";
  a2a_config.linkurl = "' + location.href + '";
</script>
<script type="text/javascript" src="http://static.addtoany.com/menu/page.js">
</script>
</mako:def>
<mako:def name="init()">
</mako:def>
<mako:def name="content()">
  <div id="loading_div" style="padding-top:20px; display: none">
    ${_(u'sending_processing_please_wait')}
  </div>
  <div id="new_place_div" style="padding-top: 10px;">
    <div id="manchaIzda">
				<div id="colDetStreetr">
					<div id="nombreStreetr">
						<a class="titulo01">${_(u'streetit_name')}:</a>
						<br />
						<br />
						<input type="text" id="place_name" class="long_input" />
						<input type="hidden" id="city"/>
						<input type="hidden" id="country"/>
					</div>
					<div id="descripcionStreetr">
						<a  class="titulo01">${_(u'comment_content')}:</a>
						<br />
						<br />
						<textarea id="comment_content" class="long_textarea"></textarea>
					</div>
					<div id="posicionMomento">
						<a class="titulo01">${_(u'position')}:</a>
						<br />
						<br />
						<input type="text" id="position_text" style="float:left;margin-top:5px;" onkeydown="if ((event.which && event.which == 13) || (event.keyCode && event.keyCode == 13)) {search_address();}" class="long_input"/>
						<a href="javascript:void(0);" onclick="search_address();" style="float:right;  color:white; text-decoration:none;" class="accion">${_(u'search')}</a>
					</div>
					<div id="selecImages">
						<a class="titulo01">${_(u'comment_attach')}:</a>
						<div style=" height:20px; ">
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
						<form id="attachment_form" enctype="multipart/form-data" name="attachment_form" method="post" action="/content/upload_file" target="file_upload_iframe">
						</form>
						<div id="files">
						</div>
						<iframe name="file_upload_iframe" id="file_upload_iframe" style="display:none;" >
						</iframe>
					</div>
					<div id="tags_content">
						<a class="titulo01">${_(u'comment_tags')}:</a>
						<div style="height: 100px; margin-top: 10px; margin-bottom: 10px;">
							<ul id="cloud" class="xmpl">
							</ul>
						</div>
						<input type="text" id="place_tags" class="long_input" />
						<div id="numCaracter">
							${_(u'write_tags_comma_separated_or_click')}
						</div>
					</div>
					<a href="javascript:void(0);" onclick="new_place();" style="float:right; clear:both; color:white; text-decoration:none;" class="accion">${_(u'save')}</a>
				</div>
			</div>
    <div id="manchaDcha">
      <!--<div id="colDetStreetr">
	  <img src="/images/flechaUp.png" />
	  <div>${_(u'click_on_the_map_to_set_the_position')}</div>
	  <div style="margin-top: 50px;">${_(u'connect_to_other_social_networks')}</div>
	  <div class="a2a_kit a2a_default_style">
	  <a class="a2a_dd" href="http://www.addtoany.com/share_save?linkurl=' + location.href + '&amp;linkname=Streetrs.com">Share</a><span class="a2a_divider"></span><a class="a2a_button_facebook"></a><a class="a2a_button_twitter"></a><a class="a2a_button_email"></a>
	  </div>
	  </div>-->
    </div>
  </div>
</mako:def>
