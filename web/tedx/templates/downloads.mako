# -*- coding: utf-8 -*-
<mako:inherit file="common.mako"/>
<mako:def name="title()">
    ${_(u'downloads')}
</mako:def>
<mako:def name="head()">
    <link rel="stylesheet" type="text/css" href="/css/view.css" />
	<script type="text/javascript" src="/js/about.js">
    </script>
</mako:def>
<mako:def name="init()">
</mako:def>
<mako:def name="content()">
    ${_(u'download_mako')|n}
</mako:def>
