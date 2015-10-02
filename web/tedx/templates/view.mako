# -*- coding: utf-8 -*-
<%inherit file="common.mako">
</%inherit>
<%def name="title()">
    ${_(u'view_place')}
</%def>
<%def name="head()">
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

<%def name="init()"></%def>
<%def name="MainContent()">

    <div id="queMapa">

        <div align="right"><a href="/" class="close-icon"></a></div>

        <h2>${_(u'Muestra')}</h2>

        <label for="new-instant-txtName">${_(u'Lugar de la muestra')}:<br />


        <label for="new-instant-txtValuePH">${_(u'pH')}:<br />

        <label for="new-instant-txtValueCloro">${_(u'Cloro')}:<br />

        <label for="new-instant-txtDescription">${_(u'description')}:</br>
        <div class="clear"></div>
        <br/><br/>
    </div>
</%def>


<%def name="content()">
  <div id="loading_div" style="padding-top:20px; display: none">
    ${_(u'sending_processing_please_wait')}
    </div>

  <div id="new_comment_div" style="padding-top: 10px;">
    <div class="sidebarIzq">
        <%include file="information_teachers.mako"/>
    </div>

    <div class="content_center">
        <h3>${_(u'happy_moments')}</h3>
        <div id="list"></div>
        <div id="add_comment">

            <h3><br>${_(u'add_comment')}</h3>
            %if not c.user:
                ${_(u'login_first_to_comment')} <!-- Para hacer un comentario hace falta hacer login primero --i
                <!--  Faltaria un enlace al login -->
            %else:
                <div id="manchaIzda">

                <div class="colDetStreetr">
	                <div id="descripcionStreetr">
	                    <a class="titulo01">${_(u'comment_content')}:</a>
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

	            </div>
	  
                <a href="javascript:void(0);" onclick="new_comment();" class="accion bordeSoft">${_(u'save')}</a>
	  </div>
	</div>
	% endif
</div>
    </div>

    <div class="sidebarDer">
        <%include file="datos.mako"/>
    </div>
    
    <div id="attachment_modal" title="Attachment" style="z-index: 9999;"></div>
</mako:def>
