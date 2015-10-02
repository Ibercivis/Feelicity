# -*- coding: utf-8 -*-
<mako:inherit file="common.mako"/>
<mako:def name="title()">
    ${_(u'notify')}
</mako:def>
<mako:def name="head()">
   <link rel="stylesheet" type="text/css" href="/css/register.css" />
   <script type="text/javascript" src="/js/notification.js"></script>	
</mako:def>
<mako:def name="init()">
</mako:def>
<mako:def name="content()">
    <h3>${_(u'send_notification')}</h3>
	<hr size="1"  color="#50ACB0">
    <div id="loading_div" style="display: none">
    	<img src="/images/loading.gif" />
    </div>
	<div id="register_div">  	
		<div class="register">
	    	<input type="hidden" id="element_id" name="element_id" value="${c.element_id}"/>
			<table>
	    		<tbody>
	    			<tr>
	    				<td>
	    					${_(u'to')}:
	    				</td>
						<td>
							<input type="text" size="29" id="receivers" maxlength="128"/>
						</td>
	    			</tr>
					<tr>
	    				<td style="vertical-align:top;">
	    					${_(u'message')}:
	    				</td>
						<td>
							<textarea cols="30" rows="3" id="message" maxlength="128"></textarea>
						</td>
	    			</tr>
	    		</tbody>
	    	</table>
	    </div>
		
		<a class="saveRegister" href="javascript:void(0);" onclick="notify();">${_(u'notify')}</a>
	</div>
</mako:def>
