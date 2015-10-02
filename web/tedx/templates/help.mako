# -*- coding: utf-8 -*-
<mako:inherit file="common.mako"/>
<mako:def name="title()">
    ${_(u'help')}
</mako:def>
<mako:def name="head()">
    <link rel="stylesheet" type="text/css" href="/css/help.css" />
	<script type="text/javascript" src="/js/about.js">
    </script>
</mako:def>
<mako:def name="init()">
</mako:def>
<mako:def name="content()">
        ${_(u'help_mako')|n}
</mako:def>
