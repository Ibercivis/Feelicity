
<div id="buscarMapa" class="left  clear">
    <label for="srch" style="float:left;padding:5px 0px;">
        <input type="text" id="search_string" placeholder="${_(u'Encuentra una muestra')}" onkeydown="if ((event.which && event.which == 13) || (event.keyCode && event.keyCode == 13)) {search_query();}"></input>
    </label>
    <a href="javascript:void(0);" onclick="search_query();" class="left accion bordeSoft">${_(u'search')}</a>
    <a href="javascript:void(0);" onclick="get_current_position(on_position_success, on_position_error);" class="left accion bordeSoft" id="geo">${_(u'geolocation')}</a>
    %if c.user:
        <div class="derecha">
            <a href="/newdata" onclick="get_current_position(on_position_success, on_position_error);" class="left accion bordeSoft" id="geo">${_(u'Nueva Muestra')}</a>
        </div>
    %endif:
</div>
