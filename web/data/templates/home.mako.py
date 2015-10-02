# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 6
_modified_time = 1394727123.5106449
_template_filename='/var/www/feelicity/current/tedx/templates/home.mako'
_template_uri='/home.mako'
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
        __M_writer(u'\n\n')
        # SOURCE LINE 6
        __M_writer(u'\n\n')
        # SOURCE LINE 17
        __M_writer(u'\n\n')
        # SOURCE LINE 19
        __M_writer(u'\n\n')
        # SOURCE LINE 55
        __M_writer(u'\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_content(context):
    context.caller_stack._push_frame()
    try:
        _ = context.get('_', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 21
        __M_writer(u'\n  <div class="sidebarIzq">\n    <h3>')
        # SOURCE LINE 23
        __M_writer(escape(_(u'happy_users')))
        __M_writer(u'</h3>\n    <div id="users"></div>  \n  </div>\n  \n  <div class="content_center">\n    <h3>')
        # SOURCE LINE 28
        __M_writer(escape(_(u'happy_moments')))
        __M_writer(u'</h3>\n    <div id="list"></div>\n    <div id="srToolsDown"></div>\n  </div>\n  \n  <div class="sidebarDer">\n    <div id="logos">\n      <!--\n      <h3>')
        # SOURCE LINE 36
        __M_writer(escape(_(u'idea')))
        __M_writer(u':</h3>\t\n      <a href="http://tedxzaragoza.com"><img src="/images/TEDx_logo.png" alt="Logo TEDx Zaragoza" /></a>\n      -->\n      <h3>')
        # SOURCE LINE 39
        __M_writer(escape(_(u'developed')))
        __M_writer(u':</h3>\n      <a href="http://www.ibercivis.es"><img src="/images/logo_fundacion.png" alt="Logo Fundaci\xf3n Ibercivis" /></a>\n    </div>\n\n    <h3>')
        # SOURCE LINE 43
        __M_writer(escape(_(u'follow_us')))
        __M_writer(u':</h3>\n    <a href="http://www.facebook.com/Ibercivis" target="_blank"><img src="/images/facebook.png"  class="left social" /></a>\n    <a href="http://www.twitter.com/Ibercivis" target="_blank"><img src="/images/twitter.png" class="left social" /></a>\n    \n    <h3>')
        # SOURCE LINE 47
        __M_writer(escape(_(u'available')))
        __M_writer(u':</h3>\n    <a href="http://itunes.apple.com/app/feelicity/id452958224?mt=8" target="_blank"><img src="/images/imovil.png" class="left" /></a>\n    <a href="https://market.android.com/details?id=com.bifi.feelicity" target="_blank"><img src="/images/androidmovil.png" class="left" /></a>\n\n    <h3>')
        # SOURCE LINE 51
        __M_writer(escape(_(u'happy_cities')))
        __M_writer(u':</h3>\n    <div id="happy_cities"></div>\n  </div>\n\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_head(context):
    context.caller_stack._push_frame()
    try:
        c = context.get('c', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 8
        __M_writer(u'\n  <link rel="stylesheet" type="text/css" href="/css/tablesorterstyle.css" />\n  <link rel="stylesheet" type="text/css" href="/css/home.css" />\n  <script type="text/javascript" src="/js/home.js"></script>\n  <script type="text/javascript" src="/js/jquery.tagcloud.min.js" charset="utf-8"></script>\n  <link rel="stylesheet" type="text/css" href="/css/screen.css" />\t\n  <script type="text/javascript">\n    var user = "')
        # SOURCE LINE 15
        __M_writer(escape(c.user))
        __M_writer(u'";\n  </script>\n')
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
        __M_writer(escape(_(u'home')))
        __M_writer(u'\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


