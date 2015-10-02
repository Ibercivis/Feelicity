# -*- coding: utf-8 -*-
<mako:inherit file="common.mako"/>
<mako:def name="title()">
  ${_(u'profile')}
</mako:def>
<mako:def name="head()">
  <link rel="stylesheet" type="text/css" href="/css/my_account.css" />
  <script type="text/javascript" src="/js/profile.js">
  </script>
  <script type="text/javascript">
    % if c.db_user:
    user_id = "${c.db_user.id}";
    % else:
    user_id = "";
    % endif
  </script>
</mako:def>
<mako:def name="init()">
</mako:def>
<mako:def name="content()">
  % if not c.db_user:
  <h3 style="margin:10px;padding:10px;">${_(u'the_user_doesnt_exist')}</h3>
  % else:
  <!--<h3 style="margin:10px;padding:10px;">${_(u'profile')} ${_(u'of')} ${c.db_user.nickname}</h3>-->
  
  <div class="sidebarIzq">
    <h3>${_(u'profile')}</h3>
    <div id="details" class="item left">
      <div  id="avatarPerfil" style="float:left;"></div>
      <div class="clear"></div>
      <div style="float:left;">${_(u'nickname')}:</div><div  id="nickname_profile" style="float:left;padding-left:5px;" ></div>
      <div class="clear"></div>
      <div style="float:left;">${_(u'description')}:</div><div  id="description" style="float:left;padding-left:5px;"></div>
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
      <a href="http://tedxzaragoza.com"><img src="/images/TEDx_logo.png" alt="Logo TEDx Zaragoza" /></a>
      <h3>${_(u'developed')}:</h3>
      <a href="http://bifi.es"><img src="/images/BIFI_logo.png" alt="Logo BIFI" /></a>
      <a href="http://www.ibercivis.es"><img src="/images/logo_fundacion.png" alt="Logo Fundación Ibercivis" /></a>
    </div>

    <h3>${_(u'follow_us')}:</h3>
    <a href="http://www.facebook.com/FeelicityApp" target="_blank"><img src="/images/facebook.png"  class="left social" /></a>
    <a href="http://www.twitter.com/FeelicityApp" target="_blank"><img src="/images/twitter.png" class="left social" /></a>

    <h3>${_(u'available')}:</h3>
    <a href="http://itunes.apple.com/app/feelicity/id452958224?mt=8" target="_blank"><img src="/images/imovil.png" class="left" /></a>
    <a href="https://market.android.com/details?id=com.bifi.feelicity" target="_blank"><img src="/images/androidmovil.png" class="left" /></a>

    <h3>${_(u'happy_cities')}:</h3>
    <div id="happy_cities"></div>
  </div>
  
  % endif
</mako:def>
