## Dialog New Data
<h2 class="mom">${_(u'new_place')}</h2>	    
    <form id="new-instant-form" action="/content/fast_new_instant" enctype="multipart/form-data">
        <label for="new-instant-txtName">${_(u'Lugar de la muestra')}:<br /> 
        <input type="text" id="new-instant-txtName" name="new-instant-txtName" placeholder="${_(u'Nombre')}"></input></label><br />

        <label for="new-instant-txtValuePH">${_(u'pH')}:<br />
        <input type="text" id="new-instant-txtValuePH" name="new-instant-txtValuePH" placeholder="${_(u'pH')}"></input></label><br />

        <label for="new-instant-txtValueCloro">${_(u'Cloro')}:<br />
        <input type="text" id="new-instant-txtValueCloro" name="new-instant-txtValueChlorine" placeholder="${_(u'Cloro')}"></input></label><br />

        <label for="new-instant-txtDescription">${_(u'description')}:</br>
        <textarea id="new-instant-txtDescription" name="new-instant-txtDescription" placeholder="${_(u'Descripción')}"></textarea></label>
        <div class="clear"></div>
	    <br />
		<div>
		    <img src="/images/iconoFotografia.png" alt="Añadir imagen" /> <label>${_(u'image')}:</label>
		    <input size="12" type="file" id="new-instant-image" name="new-instant-image" /> 
		</div>
		<br />
		<input type="hidden" id="new-instant-txtLatitude" name="new-instant-txtLatitude" />
		<input type="hidden" id="new-instant-txtLongitude" name="new-instant-txtLongitude" />
		<input type="hidden" id="new-instant-city" name="new-instant-city"/>
		<input type="hidden" id="new-instant-country" name="new-instant-country"/>
	</form>
	<br /><br />
    <a href="javascript: new_happy_instant();" class="registro bordeSoft" id="new-instant-btnSend">${_(u'Enviar datos')}</a>
