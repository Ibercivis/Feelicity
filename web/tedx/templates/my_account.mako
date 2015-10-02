# -*- coding: utf-8 -*-
<mako:inherit file="common.mako"/>
    <mako:def name="title()">
        ${_(u'my_account')}
    </mako:def>
    <mako:def name="head()">
        <link rel="stylesheet" type="text/css" href="/css/common.css" />
        <link rel="stylesheet" type="text/css" href="/css/my_account.css" />
        <script type="text/javascript" src="/js/my_account.js">
        </script>
        <script type="text/javascript">
            % if c.user.latitude and c.user.longitude:
            latitude = "${c.user.latitude}"
            longitude = "${c.user.longitude}"
            % endif
            % if c.user:
            user_id = "${c.user.id}";
            % endif
        </script>
    </mako:def>
    <mako:def name="init()">
    </mako:def>
    <mako:def name="content()">
        <iframe style="display:none;" id="stickers_download_iframe" name="logo_download_iframe">
        </iframe>
        
        <div class="sidebarIzq">
        	<h3>${_(u'profile')}</h3>
        	<div id="details" class="item left">
	            <div  id="avatarPerfil" style="float:left;"></div>
	            <div  id="nickname_profile" style="clear:both;"></div>
	            <div  style="clear:both;" class="edit"><div class="acordion"><a href="javascript:void(0);" onclick="$('#details2').toggle('blind');$(this).parent().toggleClass('acordion_active');" class="edit">Editar</a></div></div>
	            <div class="account_container">
                    <div id="details2" style="display:none;">
                        <div style="position: relative; width: 150px; text-align: center; ">
                            <div style="margin-bottom: 10px; margin-top:10px; float:left;">
                                <a href="javascript:void(0);" onclick="$('#avatar_file_div').show('blind')" >${_(u'change')}</a>
                                <a href="javascript:void(0);" >${_(u'remove')}</a>
                            </div>
                            <div id="avatar_file_div" style="margin-bottom: 10px; display:none;">
                                <form id="form_avatar" enctype="multipart/form-data" target="file_upload_avatar" method="post" action="/my_account/upload_avatar">
                                    <input type="file" id="avatar" value="" size="14" name="file" accept=""></input>
                                    <input type="hidden" name="type" value=""></input>
                                    <iframe id="file_upload_avatar" name="file_upload_avatar" style="display:none;">
                                    </iframe>
                                </form>
                            </div>
                        </div>
                        <div class="clear">
                        </div>
                        
                        <div id="change_password_div">
                            <div class="detail_title">
                                <span class="titulo01">${_(u'password')}:</span>
                            </div>
                            <div class="detail_value">
                                <a  href="javascript:void(0);" onclick="change_password();">${_(u'change password')}</a>
                            </div>
                            <div class="clear">
                            </div>
                        </div>
                        <div id="new_password_div" style="display: none;">
                            <div class="detail_title">
                                <span class="titulo01">${_(u'old_password')}:</span>
                            </div>
                            <div class="detail_value">
                                <input type="password" id="password1" maxlength="32" class="long_input" />
                            </div>
                            <div class="clear">
                            </div>
                            <div class="detail_title">
                                <span class="titulo01">${_(u'new_password')}:</span>
                            </div>
                            <div class="detail_value">
                                <input type="password" id="password2" maxlength="32" class="long_input" />
                            </div>
                            <div class="clear">
                            </div>
                        </div>
						<div class="detail_title">
                            <span class="titulo01">${_(u'nickname')}:</span>
                        </div>
                        <div class="detail_value">
                            <input type="text" id="nickname" maxlength="32" class="long_input" />
                        </div>
                        <div class="clear">
                        </div>
                        <div class="detail_title">
                            <span class="titulo01">${_(u'description')}:</span>
                        </div>
                        <div class="detail_value">
                            <input type="text" id="description" maxlength="32" class="long_input" />
                        </div>
                        <div class="clear">
                        </div>
						<div style="margin-top:50px;"><a class="accion" style="float:right;color:white;" href="javascript:void(0)" onclick="save()" id="print_Stickers_button">${_(u'save')}</a></div>
                    </div>
                </div>
	            <ul class="clear">
	            	<li><a id="comments" href="#"></a></li>
	            	<li><a id="likes" href="#"></a></li>
	            	<li><a id="visits" href="#"></a></li>
	            </ul>
	        </div>
	        
                
        </div>
        <div class="content_center">
        	<h3>${_(u'happy_moments')}</h3>
        	<div id="list"></div>
        	<div id="srToolsDown">
            </div>
        </div>
        	

	<div class="sidebarDer">
    	  <div id="logos">
	    <h3>${_(u'idea')}:</h3>
	    <a href="http://tedxzaragoza.com">
	      <img src="/images/TEDx_logo.png" alt="Logo TEDx Zaragoza" />
	    </a>
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
    	  <a href="http://itunes.apple.com/app/feelicity/id452958224?mt=8" target="_blank"><img src="/images/imovil.png" class="left" /></a>
    	  <a href="https://market.android.com/details?id=com.bifi.feelicity" target="_blank"><img src="/images/androidmovil.png" class="left" /></a>

	  <h3>${_(u'happy_cities')}:</h3>
	  <div id="happy_cities"></div>
	</div>
    </mako:def>
