# -*- coding: utf-8 -*-
<%inherit file="common.mako"/>
<%def name="title()">${_(u'register')}</%def>

<%def name="head()">
</%def>

<%def name="init()"></%def>

<%def name="content()"></%def>
<%def name="MainContent()">

    <div id="queMapa">

        <div align="right"><a href="/" class="close-icon"></a></div>

        <h2>${_(u'Inicio de sesion')}</h2>

        <form id="form1" method="post" action="/common/form_login" >


            <label for="new-session-txtName">${_(u'Email')}:<br />
                <input type="text"  name="login_email" id="login_email"></input>
            </label><br/>

            <label for="new-session-txtPassword">${_(u'Password')}:<br />
            ${_(u'password')}
            <input type="password" name="login_password" id="login_password" onkeydown="if ((event.which && event.which == 13) || (event.keyCode && event.keyCode == 13)) {$('#form1').submit();}"></input>
            </label><br/>


            </br></br>
            <div class="centerize">
                <a href="#" onclick="$('#form1').submit();"  class="accion bordeSoft">${_(u'log_in')}</a>
            </div>

            </br></br>
            <div class="centerize">
                <a href="/register" class="accion bordeSoft" id="new-instant-btnSend">${_(u'Registrarse')}</a>
            </div> 
            </br></br>
            <div class="centerize">
                <a href="/forgotpassword" class="accion bordeSoft" id="new-instant-btnSend">${_(u'Recuperar contraseña')}</a>
            </div
        </form>


        <div class="clear"></div>
        </div>
</%def>



<%def name="content()">
    <div class="sidebarIzq">
        <h3>${_(u'Información para Profesores')}</h3>
        ${_(u'Queremos repartir kits experimentales a todos los centros de Educación Secundaria que lo deseen, pero nuestro presupuesto es limitado. Mandanos un correo a')} <a href="mailto:info@ibercivis.es">info@ibercivis.es</a> ${_(u'indicando en el asunto AQUA y con los detalles de centro y de la persona de contacto')}.
        <br /><br />
        ${_(u'Fecha límite para recepción de solicitudes de los centros: 22 de Abril de 2014')}.
        <br /><br />
        ${_(u'Nota: en caso de recibir más solicitudes de las que somos capaces de financiar, se dará prioridad a los centros de Zaragoza')}.
    </div>
                                                                  
    <div class="content_center">
        <h3>${_(u'Muestra de Agua Analizadas')}</h3>
        <div id="list"></div>
            <div id="srToolsDown"></div>
        </div>
                                                                    
        <div class="sidebarDer">
            <%include file="datos.mako"/>
        </div>
</%def>
