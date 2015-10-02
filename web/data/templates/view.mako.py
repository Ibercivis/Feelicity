# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 6
_modified_time = 1340657714.8183861
_template_filename='/var/www/feelicity/20120625120040/tedx/templates/view.mako'
_template_uri='/view.mako'
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
        # SOURCE LINE 3
        __M_writer(u'\n')
        # SOURCE LINE 6
        __M_writer(u'\n')
        # SOURCE LINE 24
        __M_writer(u'\n\n')
        # SOURCE LINE 26
        __M_writer(u'\n\n')
        # SOURCE LINE 140
        __M_writer(u'\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_content(context):
    context.caller_stack._push_frame()
    try:
        c = context.get('c', UNDEFINED)
        _ = context.get('_', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 28
        __M_writer(u'\n  <div id="loading_div" style="padding-top:20px; display: none">\n    ')
        # SOURCE LINE 30
        __M_writer(escape(_(u'sending_processing_please_wait')))
        __M_writer(u'\n  </div>\n  <div id="new_comment_div" style="padding-top: 10px;">\n    <div class="sidebarIzq">\n      <br />\n    </div>\n\n    <div class="content_center">\n      <h3>')
        # SOURCE LINE 38
        __M_writer(escape(_(u'happy_moments')))
        __M_writer(u'</h3>\n      <div id="list"></div>\n\n      <div id="srToolsDown"></div>\n      <br />\n      <br />\n\n      <div id="add_comment">\n\t<h3>')
        # SOURCE LINE 46
        __M_writer(escape(_(u'add_comment')))
        __M_writer(u'</h3>\n\t<div id="users"></div>\n')
        # SOURCE LINE 48
        if c.user:
            # SOURCE LINE 49
            __M_writer(u'\t<div id="manchaIzda">\n\t  <div class="colDetStreetr">\n\t    <div id="descripcionStreetr">\n\t      <a class="titulo01">')
            # SOURCE LINE 52
            __M_writer(escape(_(u'comment_content')))
            __M_writer(u':</a>\n\t      <br />\n\t      <br />\n\t      <textarea id="comment_content" class="long_textarea"></textarea>\n\t    </div>\n\t    \n\t    <div id="selecImages">\n\t      <a class="titulo01">')
            # SOURCE LINE 59
            __M_writer(escape(_(u'comment_attach')))
            __M_writer(u':</a>\n\t      <div style="clear:both; height:20px; padding-top:10px;">\n\t\t<div id="botonSubirImg">\n\t\t  <a class="estiloAzul" href="javascript:new_attachment(\'image\');">\n\t\t    <img src="/images/iconoFotografia.png" alt="Subir Imagen" longdesc="Click aqui para subir una nueva imagen. Tama\xf1o M\xe1ximo 10x15.Resoluci\xf3n 72 dpi." />\n\t\t    ')
            # SOURCE LINE 64
            __M_writer(escape(_(u'image')))
            __M_writer(u'\n\t\t  </a>\n\t\t</div>\n\t\t<div id="botonYoutube">\n\t\t  <a class="estiloAzul" href="javascript:new_youtube_link();">\n\t\t    <img src="/images/iconoYoutube.png" alt="Enlazar con un video de YouTube." longdesc="Click aqu\xed para enlazar con un video de YouTube." />\n\t\t    ')
            # SOURCE LINE 70
            __M_writer(escape(_(u'youtube')))
            __M_writer(u'\n\t\t  </a>\n\t\t</div>\n\t      </div>\n\t      \n\t      <div id="link" title="link">\n\t\t<form>\n\t\t  <fieldset>\n\t\t    <input type="text" id="youtube_link" name="file">\n\t\t    </input>\n\t\t  </fieldset>\n\t\t</form>\n\t      </div>\n\t      \n\t      <div id="files"></div>\n\t      <iframe style="display:none;" id="file_upload_iframe" name="file_upload_iframe"></iframe>\n\t    </div>\n\n\t    <div id="tags_content">\n\t      <a class="titulo01">')
            # SOURCE LINE 89
            __M_writer(escape(_(u'comment_tags')))
            __M_writer(u':</a>\n\t      <div style="height: 100px; margin-top: 10px; margin-bottom: 10px;">\n\t\t<ul id="cloud" class="xmpl">\n\t\t</ul>\n\t      </div>\n\t      <input type="text" id="comment_tags" class="long_input" />\n\t      <div id="numCaracter">\n\t\t')
            # SOURCE LINE 96
            __M_writer(escape(_(u'write_tags_comma_separated_or_click')))
            __M_writer(u'\n\t      </div>\n\t    </div>\n\t  \n\t    <a href="javascript:void(0);" onclick="new_comment();" style="float:right; clear:both; color:white; text-decoration:none;" class="accion">')
            # SOURCE LINE 100
            __M_writer(escape(_(u'save')))
            __M_writer(u'</a>\n\t  </div>\n\t</div>\n')
            # SOURCE LINE 103
        else:
            # SOURCE LINE 104
            __M_writer(u'\t')
            __M_writer(escape(_(u'login_first_to_comment')))
            __M_writer(u' <!-- Para hacer un comentario hace falta hacer login primero -->\n')
            pass
        # SOURCE LINE 106
        __M_writer(u'      </div>\n    </div>\n\n    <div class="sidebarDer">\n      <div id="logos">\n\t<h3>')
        # SOURCE LINE 111
        __M_writer(escape(_(u'idea')))
        __M_writer(u':</h3>\n\t<a href="http://tedxzaragoza.com"><img src="/images/TEDx_logo.png" alt="Logo TEDx Zaragoza" /></a>\n\t<h3>')
        # SOURCE LINE 113
        __M_writer(escape(_(u'developed')))
        __M_writer(u':</h3>\n\t<a href="http://bifi.es"><img src="/images/BIFI_logo.png" alt="Logo BIFI" /></a>\n\t<a href="http://www.ibercivis.es"><img src="/images/logo_fundacion.png" alt="Logo Fundaci\xf3n Ibercivis" /></a>\n      </div>\n\n      <h3>')
        # SOURCE LINE 118
        __M_writer(escape(_(u'follow_us')))
        __M_writer(u':</h3>\n      <a href="http://www.facebook.com/FeelicityApp" target="_blank">\n\t<img src="/images/facebook.png"  class="left social" />\n      </a>\n      <a href="http://www.twitter.com/FeelicityApp" target="_blank">\n\t<img src="/images/twitter.png" class="left social" />\n      </a>\n\n      <h3>')
        # SOURCE LINE 126
        __M_writer(escape(_(u'available')))
        __M_writer(u':</h3>\n      <a href="http://itunes.apple.com/app/feelicity/id452958224?mt=8" target="_blank">\n\t<img src="/images/imovil.png" class="left" />\n      </a>\n      <a href="https://market.android.com/details?id=com.bifi.feelicity" target="_blank">\n\t<img src="/images/androidmovil.png" class="left" />\n      </a>\n\n      <h3>')
        # SOURCE LINE 134
        __M_writer(escape(_(u'happy_cities')))
        __M_writer(u':</h3>\n      <div id="happy_cities">\n      </div>\n    </div>\n    \n    <div id="attachment_modal" title="Attachment" style="z-index: 9999;"></div>\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_head(context):
    context.caller_stack._push_frame()
    try:
        c = context.get('c', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 7
        __M_writer(u'\n  <link rel="stylesheet" type="text/css" href="/css/view.css" />\n  <script type="text/javascript" src="/js/flowplayer-3.2.4.min.js"></script>\n  <script type="text/javascript" src="/js/jquery.tagcloud.min.js" charset="utf-8"></script>\n  <script type="text/javascript">\n    var user = "')
        # SOURCE LINE 12
        __M_writer(escape(c.user))
        __M_writer(u'";\n    var password = "')
        # SOURCE LINE 13
        __M_writer(escape(c.password))
        __M_writer(u'";\n    var user_id;\n    var place_id;\n')
        # SOURCE LINE 16
        if c.user:
            # SOURCE LINE 17
            __M_writer(u'    var user_id = "')
            __M_writer(escape(c.user.id))
            __M_writer(u'"\n')
            pass
        # SOURCE LINE 19
        if c.place_id:
            # SOURCE LINE 20
            __M_writer(u'    var place_id = "')
            __M_writer(escape(c.place_id))
            __M_writer(u'";\n')
            pass
        # SOURCE LINE 22
        __M_writer(u'  </script >\n  <script type="text/javascript" src="/js/view.js" charset="utf-8"></script>\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_init(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_title(context):
    context.caller_stack._push_frame()
    try:
        _ = context.get('_', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 4
        __M_writer(u'\n  ')
        # SOURCE LINE 5
        __M_writer(escape(_(u'view_place')))
        __M_writer(u'\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


