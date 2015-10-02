# -*- coding: utf-8 -*-
<mako:inherit file="common.mako"/>
    <mako:def name="title()">
        ${_(u'register')}
    </mako:def>
    <mako:def name="head()">
        <link rel="stylesheet" type="text/css" href="/css/register.css" />
        <script type="text/javascript" src="/js/register.js">
        </script>
    </mako:def>
    <mako:def name="init()">
    </mako:def>
    <mako:def name="content()">
        <div id="manchaIzda">
            <div class="register">
                <table>
                    <tr>
                        <td>
                        ${_(u'email')}*:
                        </td>
                        <td width="250" align="right">
                        % if c.user is not None:
                        ${c.user.email}
                        % else:
                        <input type="text" id="email" maxlength="256" />
                        % endif
                        </td>
                    </tr>
                    <tr>
                        <td>
                        ${_(u'password')}*:
                        </td>
                        <td width="250" align="right">
                        <input type="password" id="contra" maxlength="32" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                        ${_(u'repeat_password')}*:
                        </td>
                        <td width="250" align="right">
                        <input type="password" id="contra_confirmation" maxlength="32" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                        ${_(u'nickname')}*:
                        </td>
                        <td width="250" align="right">
                        % if c.user is not None:
                        <input type="text" id="nickname" maxlength="32" value="${c.user.nickname}" />
                        % else:
                        <input type="text" id="nickname" maxlength="32" />
                        % endif
                        </td>
                    </tr>
                    <tr>
                        <td>
                        ${_(u'sex')}*:
                        </td>
                        <td width="250" align="left">
                        % if not c.user:
						<div class="sexcontainer">
							<div for="man" class="sex">
								${_(u'man')}
							</div>
							<input name="sex" type="radio" value="V" style="width:15px;"/>
							<div for="woman" class="sex">
								${_(u'woman')}
							</div>
							<input name="sex" type="radio" value="M" style="width:15px;"/>
						</div>
						%endif
                        </td>
                    </tr>
                </table>
                <a href="javascript:void(0);" style="float:right; margin-top: 20px; color:white; text-decoration:none;" onclick="register();" class="accion">${_(u'save')}</a>
                <div class="clear">
                </div>
            </div>
        </div>
        <div id="manchaDcha">
            <div id="colDetStreetr">
                <img src="/images/flechaUp.png" />
                <div class="estiloNegro">
                    ${_(u'click_on_the_map_to_set_the_position')}
                </div>
            </div>
        </div>
    </mako:def>
