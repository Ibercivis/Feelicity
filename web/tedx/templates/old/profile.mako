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
      <mako:include file="datos.mako"/>
  </div>
  
  % endif
</mako:def>
