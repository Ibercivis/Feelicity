## dialog_start.mako
<div id="dialog-start" title="${_(u'Inicio de Sesion')}">

    <br>
    <label for="dialog-start-txtEmail" class="form-label">${_(u'email')}*:</label><br />
    <input type="text" id="dialog-start-txtEmail" maxlength="256" class="form-input" /><br />
	
    <label for="dialog-start-txtContra" class="form-label">${_(u'password')}*:</label><br />
    <input type="password" id="dialog-start-txtContra" maxlength="32" class="form-input" /><br />
    
    <button id="dialog-start-btnAccept">${_(u'accept')}</button>
    <button id="dialog-start-btnCancel">${_(u'cancel')}</button>
</div>
