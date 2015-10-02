<%inherit file="common.mako"/>

<%def name="title()">
    Pagina home
</%def>

<%def name="MainContent()">

        %if not c.user:
        <div id="queMapa">
            <h2>${_(u'Controla el agua que bebes')}</h2>
            
            <p>${_(u'Si hay algo que merece nuestra atención y cuidado, eso es el agua que bebemos todos los dias. Tanto si vives en un pueblo aislado  o en una ciudad con tramos de tubería muy largos, queremos que nos ayudes a controlar si los niveles de cloro en nuestros grifos son  los adecuados para el consumo. Aquí puedes compartir el resultado de analizar el agua de tu casa, o el de la fuente de tu parque, el que encuentre en tus viajes...')}</p>

            <br><br>
            <div class="centerize">
                <a href='/login' class='accion right bordeSoft' style='text-transform: uppercase:' id='grande'>
                ${_(u'Entrar')}</a>
            </div>

        </div>
     %endif
</%def>

<%def name="head()">
    <link rel="stylesheet" type="text/css" href="/css/tablesorterstyle.css" />
    <link rel="stylesheet" type="text/css" href="/css/home.css" />
    <script type="text/javascript" src="/js/home.js"></script>
    <script type="text/javascript" src="/js/jquery.tagcloud.min.js" charset="utf-8"></script>
    <link rel="stylesheet" type="text/css" href="/css/screen.css" />
    <script type="text/ javascript">
         var user = "${c.user}";
    </script>
</%def>

<%def name="init()"></%def>

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
