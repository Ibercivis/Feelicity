# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 6
_modified_time = 1343315893.761508
_template_filename='/var/www/feelicity/20120625120040/tedx/templates/content.mako'
_template_uri='/content.mako'
_template_cache=cache.Cache(__name__, _modified_time)
_source_encoding='utf-8'
from webhelpers.html import escape
_exports = ['content', 'head', 'init', 'title']


def _mako_get_namespace(context, name):
    try:
        return context.namespaces[(__name__, name)]
    except KeyError:
        _mako_generate_namespaces(context)
        return context.namespaces[(__name__, name)]
def _mako_generate_namespaces(context):
    pass
def _mako_inherit(template, context):
    _mako_generate_namespaces(context)
    return runtime._inherit_from(context, u'common.mako', _template_uri)
def render_body(context,**pageargs):
    context.caller_stack._push_frame()
    try:
        __M_locals = __M_dict_builtin(pageargs=pageargs)
        __M_writer = context.writer()
        # SOURCE LINE 2
        __M_writer(u'\n')
        # SOURCE LINE 5
        __M_writer(u'\n')
        # SOURCE LINE 27
        __M_writer(u'\n')
        # SOURCE LINE 29
        __M_writer(u'\n')
        # SOURCE LINE 114
        __M_writer(u'\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_content(context):
    context.caller_stack._push_frame()
    try:
        _ = context.get('_', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 30
        __M_writer(u'\n  <div id="loading_div" style="padding-top:20px; display: none">\n    ')
        # SOURCE LINE 32
        __M_writer(escape(_(u'sending_processing_please_wait')))
        __M_writer(u'\n  </div>\n  <div id="new_place_div" style="padding-top: 10px;">\n    <div id="manchaIzda">\n\t\t\t\t<div id="colDetStreetr">\n\t\t\t\t\t<div id="nombreStreetr">\n\t\t\t\t\t\t<a class="titulo01">')
        # SOURCE LINE 38
        __M_writer(escape(_(u'streetit_name')))
        __M_writer(u':</a>\n\t\t\t\t\t\t<br />\n\t\t\t\t\t\t<br />\n\t\t\t\t\t\t<input type="text" id="place_name" class="long_input" />\n\t\t\t\t\t\t<input type="hidden" id="city"/>\n\t\t\t\t\t\t<input type="hidden" id="country"/>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div id="descripcionStreetr">\n\t\t\t\t\t\t<a  class="titulo01">')
        # SOURCE LINE 46
        __M_writer(escape(_(u'comment_content')))
        __M_writer(u':</a>\n\t\t\t\t\t\t<br />\n\t\t\t\t\t\t<br />\n\t\t\t\t\t\t<textarea id="comment_content" class="long_textarea"></textarea>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div id="posicionMomento">\n\t\t\t\t\t\t<a class="titulo01">')
        # SOURCE LINE 52
        __M_writer(escape(_(u'position')))
        __M_writer(u':</a>\n\t\t\t\t\t\t<br />\n\t\t\t\t\t\t<br />\n\t\t\t\t\t\t<input type="text" id="position_text" style="float:left;margin-top:5px;" onkeydown="if ((event.which && event.which == 13) || (event.keyCode && event.keyCode == 13)) {search_address();}" class="long_input"/>\n\t\t\t\t\t\t<a href="javascript:void(0);" onclick="search_address();" style="float:right;  color:white; text-decoration:none;" class="accion">')
        # SOURCE LINE 56
        __M_writer(escape(_(u'search')))
        __M_writer(u'</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div id="selecImages">\n\t\t\t\t\t\t<a class="titulo01">')
        # SOURCE LINE 59
        __M_writer(escape(_(u'comment_attach')))
        __M_writer(u':</a>\n\t\t\t\t\t\t<div style=" height:20px; ">\n\t\t\t\t\t\t\t<div id="botonSubirImg">\n\t\t\t\t\t\t\t\t<a class="estiloAzul" href="javascript:new_attachment(\'image\');">\n\t\t\t\t\t\t\t\t<img src="/images/iconoFotografia.png" alt="Subir Imagen" longdesc="Click aqui para subir una nueva imagen. Tama\xf1o M\xe1ximo 10x15.Resoluci\xf3n 72 dpi." />\n\t\t\t\t\t\t\t\t')
        # SOURCE LINE 64
        __M_writer(escape(_(u'image')))
        __M_writer(u'\n\t\t\t\t\t\t\t\t</a>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t<div id="botonYoutube">\n\t\t\t\t\t\t\t\t<a class="estiloAzul" href="javascript:new_youtube_link();">\n\t\t\t\t\t\t\t\t<img src="/images/iconoYoutube.png" alt="Enlazar con un video de YouTube." longdesc="Click aqu\xed para enlazar con un video de YouTube." />\n\t\t\t\t\t\t\t\t')
        # SOURCE LINE 70
        __M_writer(escape(_(u'youtube')))
        __M_writer(u'\n\t\t\t\t\t\t\t\t</a>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t\t<div id="link" title="link">\n\t\t\t\t\t\t\t<form>\n\t\t\t\t\t\t\t\t<fieldset>\n\t\t\t\t\t\t\t\t\t<input type="text" id="youtube_link" name="file">\n\t\t\t\t\t\t\t\t\t</input>\n\t\t\t\t\t\t\t\t</fieldset>\n\t\t\t\t\t\t\t</form>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t\t<form id="attachment_form" enctype="multipart/form-data" name="attachment_form" method="post" action="/content/upload_file" target="file_upload_iframe">\n\t\t\t\t\t\t</form>\n\t\t\t\t\t\t<div id="files">\n\t\t\t\t\t\t</div>\n\t\t\t\t\t\t<iframe name="file_upload_iframe" id="file_upload_iframe" style="display:none;" >\n\t\t\t\t\t\t</iframe>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div id="tags_content">\n\t\t\t\t\t\t<a class="titulo01">')
        # SOURCE LINE 90
        __M_writer(escape(_(u'comment_tags')))
        __M_writer(u':</a>\n\t\t\t\t\t\t<div style="height: 100px; margin-top: 10px; margin-bottom: 10px;">\n\t\t\t\t\t\t\t<ul id="cloud" class="xmpl">\n\t\t\t\t\t\t\t</ul>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t\t<input type="text" id="place_tags" class="long_input" />\n\t\t\t\t\t\t<div id="numCaracter">\n\t\t\t\t\t\t\t')
        # SOURCE LINE 97
        __M_writer(escape(_(u'write_tags_comma_separated_or_click')))
        __M_writer(u'\n\t\t\t\t\t\t</div>\n\t\t\t\t\t</div>\n\t\t\t\t\t<a href="javascript:void(0);" onclick="new_place();" style="float:right; clear:both; color:white; text-decoration:none;" class="accion">')
        # SOURCE LINE 100
        __M_writer(escape(_(u'save')))
        __M_writer(u'</a>\n\t\t\t\t</div>\n\t\t\t</div>\n    <div id="manchaDcha">\n      <!--<div id="colDetStreetr">\n\t  <img src="/images/flechaUp.png" />\n\t  <div>')
        # SOURCE LINE 106
        __M_writer(escape(_(u'click_on_the_map_to_set_the_position')))
        __M_writer(u'</div>\n\t  <div style="margin-top: 50px;">')
        # SOURCE LINE 107
        __M_writer(escape(_(u'connect_to_other_social_networks')))
        __M_writer(u'</div>\n\t  <div class="a2a_kit a2a_default_style">\n\t  <a class="a2a_dd" href="http://www.addtoany.com/share_save?linkurl=\' + location.href + \'&amp;linkname=Streetrs.com">Share</a><span class="a2a_divider"></span><a class="a2a_button_facebook"></a><a class="a2a_button_twitter"></a><a class="a2a_button_email"></a>\n\t  </div>\n\t  </div>-->\n    </div>\n  </div>\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_head(context):
    context.caller_stack._push_frame()
    try:
        c = context.get('c', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 6
        __M_writer(u'\n  <script type="text/javascript" src="/js/content.js" charset="utf-8">\n  </script>\n  <script type="text/javascript" src="/js/jquery.tagcloud.min.js" charset="utf-8">\n  </script>\n  <link rel="stylesheet" type="text/css" href="/css/content.css" />\n</script>\n<script type="text/javascript">\n')
        # SOURCE LINE 14
        if c.place:
            # SOURCE LINE 15
            __M_writer(u'  var edit_place_id = "')
            __M_writer(escape(c.place.id))
            __M_writer(u'";\n')
            # SOURCE LINE 16
        else:
            # SOURCE LINE 17
            __M_writer(u'  var edit_place_id = "";\n')
            pass
        # SOURCE LINE 19
        __M_writer(u'</script>\n<script type="text/javascript">\n  var a2a_config = a2a_config || {};\n  a2a_config.linkname = "Streetrs.com";\n  a2a_config.linkurl = "\' + location.href + \'";\n</script>\n<script type="text/javascript" src="http://static.addtoany.com/menu/page.js">\n</script>\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_init(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 28
        __M_writer(u'\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_title(context):
    context.caller_stack._push_frame()
    try:
        _ = context.get('_', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 3
        __M_writer(u'\n  ')
        # SOURCE LINE 4
        __M_writer(escape(_(u'new_streetit')))
        __M_writer(u'\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


