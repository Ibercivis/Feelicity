## cabecera.mako ##
<div id="contenedor">
    <div id="cabecera">
        <div id="logotipo" style="float:left; margin; border-style:solid;border-color:#0000ff;">
            <a href="/"><img src="/images/aguagrifo.png" alt="aqua ibercivis"  /></a>
        </div>

        <div id="barra_login">
            %if c.user:
                ${_(u'hello')} <a href="/profile" class="logolink">${c.user.nickname}</a>!
                <a href="javascript:logout();" class="logolink" >${_(u'Logout')}</a>
            %else:
                <a href="/login" class="logolink">${_(u'Login')}</a> |
                <a href="/register" class="logolink">${_(u'Register')}</a>

            %endif:
            &nbsp;
            <a href="javascript: change_language('es')"><img src="images/es.png"></a>
            <a href="javascript: change_language('en')"><img src="images/en.png"></a>
        </div>
        <div id="MenuTop">
	</div>
</div>
