# -*- coding: utf-8 -*-
<mako:inherit file="common.mako"/>
<mako:def name="title()">
    Contact
</mako:def>
<mako:def name="head()">
    <link rel="stylesheet" type="text/css" href="/css/view.css" />
	<script type="text/javascript" src="/js/about.js">
    </script>
</mako:def>
<mako:def name="init()">
</mako:def>
<mako:def name="content()">
    
	<h3>Ayuda</h3>
	<hr><br>
	
	<h5 style="height:80px; width:175px;">¿Qué es Streetrs?</h5>
	<div style="margin-left:50px; margin-right: 50px;">
		<i>Streetrs</i> es una aplicación web y móvil que permite a los usuarios subir diferentes contenidos (texto, imágenes, links, videos) y geoposicionarlos en cualquier lugar del mundo. 
		Además de subir el contenido el usuario se puede descargar una imagen identificativa de su post y usarla como pegatina para ponerla directamente en esa ubicación e identificar de esta manera ese lugar.
		<!-- Streetrs is an mobile and web application that allows users to upload different type of contents (text, images, videos, links) and positionate them everywhere around the world.
		The user can also download an identificative image of his post and used it as a sticker putting it directly at the position of the place-->
	</div>
	<div style="margin-left:50px; margin-right: 50px;">
		En el mapa inicial aparecen la posición actual del usuario y las publicaciones que tiene a su alrededor. De esta manera el usuario con su móvil por la calle puede saber en el momento qué publicaciones tiene cerca de su posición, colsultarlas o añadir más datos a la misma.
		<!-- In the home page there is a map with the current position of the user and the posts around it. That way, the user could go down the street with his mobile phone and know exactly what posts are around him, read or add them some data -->
	</div>      
	<br>
	<div class="clear"></div>
	
	<h5 style="height:50px; width:175px;">¿Qué contiene la pegatina?</h5>
	<div style="margin-left:50px; margin-right: 50px;">
		La pegatina contiene el logo de <i>tedx</i> y un código bidimiensional <b>QR</b>. El código QR almacena la información del post que uno mismo ha creado en una matriz de puntos. 
		Así, cualquier persona que va por la calle y dispone de un móvil con un lector de códigos bidimensionales puede acceder de manera directa al post, leerlo, añadir nuevos comentarios, etc.
		<!-- The sticker contains the Streetrs logo and a bidimensional code QR. The QR code stores the created comment and a link to the website in a datamatrix.
		In that way, any person walking down the street and have a mobile phone with a QR reader can access directly to the post, read it, add other contents, etc.-->
	</div>      
	<img src="/images/bidi_help_example.png" style="margin-left:200px;"></img>
	<br><br>
	<div class="clear"></div>
	
	<h5 style="height:750px; width:175px;">¿Cómo puedo leer los códigos QR desde mi móvil?</h5>
	<div style="margin-left:50px; margin-right: 50px;">
		Para leer los QR por la calle necesitarás instalar en tu móvil una aplicación lectora de códigos QR. 
		Según tu tipo de móvil aquí te ponemos varias maneras de obtener una aplicación QR.
		<br>Si no sabes qué Sistema Operativo tiene tu móvil pero tienes Internet y estás viendo esto desde tu navegador móvil <a href="javascript:alert(nameSO())">pincha aquí</a> para saberlo.
		<!-- If you don't know the Operative System of your mobile phone click here to know it--> 
	</div>	
	<br>
	<div style="margin-left:50px; margin-right: 50px;"> 
		<font color="#db1b1b"><u>Android:</u></font>
		<div>
			- Visita desde el navegador de tu móvil alguna de las siguientes páginas:
				<div style="margin-left:240px;">
					- <a target="_blank" href="http://www.i-nigma.mobi/">http://www.i-nigma.mobi/</a><br>					
					- <a target="_blank" href="http://reader.kaywa.com">http://reader.kaywa.com</a><br>
					- <a target="_blank" href="http://www.upc.fi/en/upcode/instructions/download">http://www.upc.fi/en/upcode/instructions/download</a><br>
					- <a target="_blank" href="http://www.quickmark.com.tw/En/basic/index.asp">http://www.quickmark.com.tw/En/basic/index.asp</a><br>					
				</div>
			Detectarán tu modelo de móvil te pedirá que descargues la aplicación adecuada para leer QR-Codes. Acepta, descarga e instala.
			<p>- Otra opción es abrir la aplicación Market de tu Android y busca <i>Barcode Scanner</i>. Selecciónala y descárgatela. Aparecerá como una aplicación más en tu menú.</p>			
		</div>
	</div>   
	<div style="margin-left:50px; margin-right: 50px;">
	 <font color="#db1b1b"><u>iPhone:</u></font>
		<div>
			- Abre la aplicación AppStore de tu iPhone y busca <i>Barcode Scanner</i>. Selecciónala y descárgatela. Aparecerá como una aplicación más en tu menú.
		</div>
	</div>   
	<br>
	<div style="margin-left:50px; margin-right: 50px;">
	 <font color="#db1b1b"><u>Blackberry:</u></font>
		<div>
			- Desde el navegador de tu móvil accede a <a target="_blank" href="http://get.neoreader.com/">http://get.neoreader.com></a> Te detectará el modelo de móvil y tras aceptar las condiciones te instalará la aplicación NeoReader.
		</div>
	</div>
	<br>
	<div style="margin-left:50px; margin-right: 50px;">
	 <font color="#db1b1b"><u>Symbian:</u></font>
		<div>
			- Descarga el <i>barcode reader</i> desde el siguiente link: <a target="_blank" href="http://barcode-reader-s605th.softonic.com/movil/descargar#pathbar">http://barcode-reader-s605th.softonic.com/movil/descargar#pathbar</a>
			<br>
			- Otra opción es que desde el navegador de tu móvil accedas a <a target="_blank" href="http://reader.kaywa.com">http://reader.kaywa.com</a> Te detectará el modelo de móvil y tras aceptar las condiciones te instalará la aplicación NeoReader.
		</div>
	</div>
	<br>
	<div style="margin-left:50px; margin-right: 50px;">
	 <font color="#db1b1b"><u>Otros:</u></font>
		<div>
		 	- Accede a <a target="_blank" href="http://www.i-nigma.mobi/">http://www.i-nigma.mobi/</a> sigue los pasos y descárgate la aplicación. Es un lector muy competitivo para infinidad de dispositivos, fabricantes y gran número de plataformas. 
		</div>
	</div>
	<br>
	<div style="margin-left:50px; margin-right: 50px;">
	 <font color="#db1b1b"><u> No dispongo de ninguno de los anteriores ni de conexión a Internet:</u></font>
		<div>
			Si tu móvil soporta aplicaciones Java puedes descargarte la aplicación a tu ordenador y pasarla de tu ordenador al móvil vía Bluetooth o USB. Para ello entra desde el navegador de tu ordenador 
			en  <a target="_blank" href="http://reader.kaywa.com">http://reader.kaywa.com</a>. Te pedirá que te registres (es un registro rápido y gratuito) y, tras rellenar un formulario, te enviarán un email a la cuenta del registro con un link de activación. 
			En tu correo pulsa ese link y automáticamente te llevará a la página de <i>CONGRATULATIONS</i> de The Kaywa Reader. Pincha en <i>Download</i> y tras aceptar las condiciones de uso se descargará 
			un .zip con los ficheros <i>.jar</i> y <i>.jad</i>.<br>
			A continuación deberás copiarlos a tu móvil como si de un Juego se tratase. En la mayoría de móviles basta con meter el fichero en la carpeta de <i>Juegos</i> o <i>Games</i>.
			Si esto no funciona deberás buscar concretamente cómo instalar aplicaciones java en tu modelo de móvil.
		</div>
		
	</div>
	<br>
	<div style="margin-left:50px; margin-right: 50px;">
		Una vez descargada ábrela para testear si funciona y pon el móvil con la cámara de fotos enfocando al QR que hay en esta misma página. Intenta que el código salga entero y se vea nítido y el programa 
		decodificará directamente el contenido mostrándotelo por pantalla.
	</div>
	<br>
	<div class="clear"></div>
	
	<h5 style="height:50px; width:175px;">¿Qué puedo hacer exactamente en <i>Streetrs</i>?</h5>
	<div>
		Streetrs es como una red social geoposicionada. Esto significa que una persona puede escribir comentarios, subir fotos, vídeos, y asociarlos a una posición del mundo.
		Esto permite desarrollar posts como <i>Ocurrió aquí</i>, <i>Aquí quedo con mis amigos</i>, <i>Aquí voy a dejarle un mensaje a mi chica</i>, <i>Tengo algo que decir sobre este sitio</i>, etc.
	</div>
	<br>
	<div class="clear"></div>
		
	<h5 style="height:50px; width:175px;">¿Es necesario registrarse?</h5>
	<div style="margin-left:50px; margin-right: 50px;">
		No es necesario registrarse para ver los <i>streetits</i> de la gente, pero sí para comentar y añadir cosas a los <i>streetits</i> existentes  o para crear nuevos.
	</div>
	<br>
	<div class="clear"></div>
	
	<h5 style="height:50px; width:175px;">¿Cómo puedo registrarme?</h5>
	<div style="margin-left:50px; margin-right: 50px;">
		En la esquina superior derecha de la página de inicio pulsa en la etiqueta de <i>Regístrate</i> y te llevará directamente a la página de registro.
		Serán obligatorios un email, un password y un nickname. Asimismo se podrá posicionar en el mapa una <i>ubicación preferente</i> desde donde se subirán tus posts en caso de no estar geoposicionado.
	</div>
	<br>
	<div class="clear"></div>
	
	<h5 style="height:70px; width:175px;">¿Cómo puedo subir un nuevo <i>tedx</i>?</h5>
	<div style="margin-left:50px; margin-right: 50px;">
		Una vez registrado aparecerá arriba en la barra de usuario (arriba a la derecha) dicha opción. Pulsa en <i>Nuevo Streetit</i> y te llevará a la página general de subir contenido. 
		Ahí tendrás la opción de ponerle un título, comentarlo, añadir texto, imagen, vídeo, etc y al final subirlo pulsando en <i>Guardar</i>. Se te redirigirá directamente a tu post creado 
		donde podrás descargarlo para imprimirlo pulsando sobre el botón <i>Descargar Sticker</i> o enviar la notificación a algún amigo pulsando en <i>Enviar Notificación</i>. Estas dos últimas opciones también 
		aparecen en el momento de crear el post, pero si no se desean realizar en ese momento siempre están disponibles desde la página de ese <i>streetit</i> en concreto.  
	</div>
	<br>
	<div class="clear"></div>
	
	<h5 style="height:70px; width:175px;">No he imprimido la pegatina, ¿puedo volver a generarla?</h5>
	<div style="margin-left:50px; margin-right: 50px;">
		Por supuesto. En el hilo del lugar que has creado aparece la opción de <i>Descargar Sticker</i> para cada comentario. Así que podrás convertir tus mensajes publicados en pegatinas tantas veces como quieras. 
	</div>
	<br>
	<div class="clear"></div>
	
	<h5 style="height:50px; width:175px;">Problemas con el tamaño de impresión de pegatinas</h5>
	<div style="margin-left:50px; margin-right: 50px;">
		A la hora de imprimir las pegatinas tu puedes ajustar el tamaño para hacerlo a tu gusto. Es posible que tu editor de fotos te ponga ciertos tamaños por defecto que ocupen toda una página o lo contrario, dependerá del visor.
		Por eso desde aquí te recomendamos que si no tienes claro como ajustar el tamaño de impresión abras un nuevo documento de texto y ahí insertes la imagen y la ajustes a tu gusto.
		De esta manera podrás controlar ese tamaño y evitar posibles impresiones de tamaños indeseados.
	</div>
	<br>
	<div class="clear"></div>
	
	<h5 style="height:70px; width:175px;">Me gustaría avisar a unos amigos de mi publicación, ¿es posible?</h5>
	<div style="margin-left:50px; margin-right: 50px;">
		Sí que es posible. En el momento de crear el lugar podrás avisar a tus amigos clickando en <i>Enviar Notificación</i>. Si deseas avisarlos más adelante también tienes la opción en cada publicación de pinchar <i>Notificar</i> y enviársela a quien quieras con mensaje incluido.
	</div>
	<br>
	<div class="clear"></div>
	
	<h5 style="height:50px; width:175px;">¿Cómo funcionan las votaciones?</h5>
	<div style="margin-left:50px; margin-right: 50px;">
		Streetrs permite la votación tanto del lugar como de cada comentario de ese hilo. Tan sólo hay que pinchar en los logos asociados y automáticamente se apuntará tu votación.
		Las votaciones aparecen también en el resumen general de los lugares más cercanos en la página de inicio denotando así la importancia que tiene para el resto de usuarios cada publicación. 
	</div>
	<br>
	<div class="clear"></div>
	
	<h5 style="height:500px; width:175px;"> Ejemplos de uso</h5>
	<div style="margin-left:50px; margin-right: 50px;">
		<b>1. </b>El otro día me imprimí en una hoja varios logotipos de <i>tedx</i> para ir pegando por la calle cuando quiera postear algo. Sin ir más lejos esta mañana he pegado uno. Iba paseando por el casco viejo de mi ciudad y he pasado por mi bar de tapas favorito. Ahí voy con mis amigos
		todos los domingos por la mañana de tapeo a tomar los mejores champiñones del mundo. Y he creído que se lo tenía que hacer saber al resto de la ciudad. Así que me he grabado con mi móvil al lado del bar, opinando sobre el servicio, la calidad y sobretodo de los riquísimos champiñones que 
		allí cocinan. Me he conectado desde mi móvil a la página web, he introducido mi email y contraseña y una vez <i>logueado</i> he pulsado en <i>Nuevo Streetit</i> y he rellenado los campos y he añadido el vídeo. Además como en el mapita de colocación del mensaje el móvil me había geoposicionado bien en el bar no he tenido que cambiar mi posición.
		He pulsado en <i>Guardar</i> y se ha subido correctamente. He sacado de mi bolsillo las pegatinas con el logo de <i>Streetrs</i>, he pegado una y así la gente ya lo verá y sabrá que hay algo colocado. Cuando alguien tenga curiosidad por ver qué hay ahí sólo tendrá que abrir desde su navegador móvil la página web de www.tedx.com
		y en la página de inicio ya le saldrán los mensajes de su alrededor incluyendo el mío. Además, eso podrá verlo todo el mundo, sin necesidad de estar registrado. 
	</div>
	<br>
	<div style="margin-left:50px; margin-right: 50px;">
		<b>2. </b>Hoy me he levantado feliz y contento y he decidido que quiero darle una sorpresa a mi novia.<br>
		Siempre se queja de que no soy detallista pero esta vez la voy a sorprender de verdad. Voy a dejarle un mensaje en la puerta del instituto, donde íbamos juntos a clase y donde evidentemente la conocí.<br>
		Así que lo primero es irme a la página web de <i>Streetrs</i> y en la parte superior derecha pincho en <i>Regístrate</i> para proceder a registrarme. El registro es sencillo, apenas pide un mail, una contraseña y un nickname. 
		En el mapita de al lado pone mi ubicación actual, que más o menos se corresponde con la dirección de mi casa. Dejaré esa ubicación por defecto, aunque si pruebo a moverla me deja posicionarla en cualquier parte del mapa. Pulso guardar y ya estoy listo para <i>streetear.</i><br>
		Como ya estoy registrado me lleva directamente a la página inicial donde puedo ver mi posición actual con los <i>streetits</i> que hay cerca de mi ubicación. En el menú de arriba a la derecha voy a pinchar en <i>Nuevo streetit</i> para crear el mío nuevo, y se me abre una nueva página
		con el texto a rellenar: título del lugar (voy a poner 'Aquí te conocí'), título del comentario (voy a poner 'Desde ese día soy el hombre más feliz del mundo :)') y comentario ( voy a poner 'Espero que te guste mi sorpresa') . Además me he grabado diciéndole unas palabras así que pincho en <i>Attach video</i>, busco en mi directorio y agrego el vídeo.<br>
		También me da la opción de <i>Enviar una Notificación </i> que voy a clickar y a poner el correo de mi novia y un mensajito para convencerla de que lo vaya a ver. Y por supuesto le doy a <i>Imprimir pegatina</i>. Al darle a guardar se guarda mi post, se envía mi notificación, y por supuesto se me descarga un png listo para imprimir.<br>
		Una vez imprimido me cojo el abrigo y me voy a la puerta del instituto. Con mi barra de pegamento pego el stick a la pared (no tenia papel de pegatina) y ya está listo para que lo lea mi novia.  
	</div>
	<br>
	<div class="clear"></div>
	
</mako:def>