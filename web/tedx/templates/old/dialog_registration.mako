## registration.mako
<div id="dialog-registration" title="${_(u'Registro de usuario')}">
    <label for="dialog-registration-txtEmail" class="form-label">${_(u'email')}*:</label><br />
    <input type="text" id="dialog-registration-txtEmail" maxlength="256" class="form-input" /><br />
	
    <label for="dialog-registration-txtContra" class="form-label">${_(u'password')}*:</label><br />
	<input type="password" id="dialog-registration-txtContra" maxlength="32" class="form-input" /><br />
	
	<label for="dialog-registration-txtContraConfirmation" class="form-label">${_(u'repeat_password')}*:</label><br />
    <input type="password" id="dialog-registration-txtContraConfirmation" maxlength="32" class="form-input" /><br />
	
    <label for="dialog-registration-txtNickname" class="form-label">${_(u'nickname')}*:</label><br />
	<input type="text" id="dialog-registration-txtNickname" maxlength="32" class="form-input" /><br />
	
    <img id="dialog-registration-imgLoading" src="/images/loading.gif" alt="Loading image" style="height: 100px; width: 100px;" />
	<button id="dialog-registration-btnAccept">${_(u'accept')}</button>
	<button id="dialog-registration-btnCancel">${_(u'cancel')}</button>
</div>
