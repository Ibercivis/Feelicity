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
      <mako:include file="datos.mako"/>
  </div>
</mako:def>
