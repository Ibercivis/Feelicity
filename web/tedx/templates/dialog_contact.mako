## dialog_contact ##
<div id="dialog-contact" title="${_(u'Contacta con el equipo de AQUA')}">
    <label for="dialog-contact-txtName" class="form-label">${_(u'Nombre')}:</label><br />
	<input type="text" id="dialog-contact-txtName" class="form-input" /><br />
	
	<label for="dialog-contact-txtEmail" class="form-label">${_(u'email')}*:</label><br />
    <input type="text" id="dialog-contact-txtEmail" maxlength="256" class="form-input" /><br />
	
	<label for="dialog-contact-txtContent" class="form-label">${_(u'Contenido')}*:</label><br />
	 <textarea id="dialog-contact-txtContent" class="form-label"></textarea><br /><br />
	 <img id="dialog-contact-imgLoading" src="/images/loading.gif" alt="Loading image" style="height: 100px; width: 100px;" />
	 <button id="dialog-contact-btnAccept">${_(u'accept')}</button>
	 <button id="dialog-contact-btnCancel">${_(u'cancel')}
	 </button>
</div>
