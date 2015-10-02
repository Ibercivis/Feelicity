# -*- coding: utf-8 -*-
## home.mako ##
<%inherit file="common.mako"/>

<%def name="title()">${_(u'home')}</%def>

<%def name="head()">
  <link rel="stylesheet" type="text/css" href="/css/tablesorterstyle.css" />
  <link rel="stylesheet" type="text/css" href="/css/home.css" />
  <script type="text/javascript" src="/js/home.js"></script>
  <script type="text/javascript" src="/js/jquery.tagcloud.min.js" charset="utf-8"></script>
  <link rel="stylesheet" type="text/css" href="/css/screen.css" />	
  <script type="text/javascript">
    var user = "${c.user}";
  </script>
</%def>

<%def name="init()"></%def>
<%def name="carlitos()">
    Carlitos
</%def>

<%def name="content()">
    <div class="sidebarIzq">
        <%include file="information_teachers.mako"/>
    </div>
  
    <div class="content_center">
        <h3>${_(u'Muestra de Aguas Analizadas')}</h3>
        <div id="list"></div>
        <div id="srToolsDown"></div>
    </div>
  
    <div class="sidebarDer">
        <%include file="datos.mako"/>
    </div>
</%def>
