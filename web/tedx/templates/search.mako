# -*- coding: utf-8 -*-
<mako:inherit file="common.mako"/>
<mako:def name="title()">
  ${_(u'home')}
</mako:def>
<mako:def name="head()">
  <link rel="stylesheet" type="text/css" href="/css/tablesorterstyle.css" />
  <link rel="stylesheet" type="text/css" href="/css/home.css" />
  <script type="text/javascript" src="/js/search.js">
  </script>
  <script type="text/javascript" src="/js/jquery.tablesorter.min.js">
  </script>
  <script type="text/javascript" src="/js/json.js">
  </script>
  <script type="text/javascript">
    var user = "${c.user}";
    search_string = "${c.search_string}";
    range_query = "${c.is_range_query}";
    latitude = "${c.new_latitude}";
    longitude = "${c.new_longitude}";
  </script>
</mako:def>
<mako:def name="init()">
</mako:def>
<mako:def name="content()">
  
  <div class="sidebarIzq">
    <h3>${_(u'happy_users')}</h3>
    <div id="users">
    </div>
  </div>
  
  <div class="content_center">
    <h3>${_(u'happy_moments')}</h3>
    <div id="list">
    </div>
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
</mako:def>
