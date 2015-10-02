# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 6
_modified_time = 1340685405.072722
_template_filename='/var/www/feelicity/20120625120040/tedx/templates/search.mako'
_template_uri='/search.mako'
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
        # SOURCE LINE 22
        __M_writer(u'\n')
        # SOURCE LINE 24
        __M_writer(u'\n')
        # SOURCE LINE 61
        __M_writer(u'\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_content(context):
    context.caller_stack._push_frame()
    try:
        _ = context.get('_', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 25
        __M_writer(u'\n  \n  <div class="sidebarIzq">\n    <h3>')
        # SOURCE LINE 28
        __M_writer(escape(_(u'happy_users')))
        __M_writer(u'</h3>\n    <div id="users">\n    </div>\n  </div>\n  \n  <div class="content_center">\n    <h3>')
        # SOURCE LINE 34
        __M_writer(escape(_(u'happy_moments')))
        __M_writer(u'</h3>\n    <div id="list">\n    </div>\n    <div id="srToolsDown">\n    </div>\n  </div>\n  \n  <div class="sidebarDer">\n    <div id="logos">\n      <h3>')
        # SOURCE LINE 43
        __M_writer(escape(_(u'idea')))
        __M_writer(u':</h3>\t\n      <a href="http://tedxzaragoza.com"><img src="/images/TEDx_logo.png" alt="Logo TEDx Zaragoza" /></a>\n      <h3>')
        # SOURCE LINE 45
        __M_writer(escape(_(u'developed')))
        __M_writer(u':</h3>\n      <a href="http://bifi.es"><img src="/images/BIFI_logo.png" alt="Logo BIFI" /></a>\n      <a href="http://www.ibercivis.es"><img src="/images/logo_fundacion.png" alt="Logo Fundaci\xf3n Ibercivis" /></a>\n    </div>\n\n    <h3>')
        # SOURCE LINE 50
        __M_writer(escape(_(u'follow_us')))
        __M_writer(u':</h3>\n    <a href="http://www.facebook.com/FeelicityApp" target="_blank"><img src="/images/facebook.png"  class="left social" /></a>\n    <a href="http://www.twitter.com/FeelicityApp" target="_blank"><img src="/images/twitter.png" class="left social" /></a>\n\n    <h3>')
        # SOURCE LINE 54
        __M_writer(escape(_(u'available')))
        __M_writer(u':</h3>\n    <a href="http://itunes.apple.com/app/feelicity/id452958224?mt=8" target="_blank"><img src="/images/imovil.png" class="left" /></a>\n    <a href="https://market.android.com/details?id=com.bifi.feelicity" target="_blank"><img src="/images/androidmovil.png" class="left" /></a>\n\n    <h3>')
        # SOURCE LINE 58
        __M_writer(escape(_(u'happy_cities')))
        __M_writer(u':</h3>\n    <div id="happy_cities"></div>\n  </div>\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_head(context):
    context.caller_stack._push_frame()
    try:
        c = context.get('c', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 6
        __M_writer(u'\n  <link rel="stylesheet" type="text/css" href="/css/tablesorterstyle.css" />\n  <link rel="stylesheet" type="text/css" href="/css/home.css" />\n  <script type="text/javascript" src="/js/search.js">\n  </script>\n  <script type="text/javascript" src="/js/jquery.tablesorter.min.js">\n  </script>\n  <script type="text/javascript" src="/js/json.js">\n  </script>\n  <script type="text/javascript">\n    var user = "')
        # SOURCE LINE 16
        __M_writer(escape(c.user))
        __M_writer(u'";\n    search_string = "')
        # SOURCE LINE 17
        __M_writer(escape(c.search_string))
        __M_writer(u'";\n    range_query = "')
        # SOURCE LINE 18
        __M_writer(escape(c.is_range_query))
        __M_writer(u'";\n    latitude = "')
        # SOURCE LINE 19
        __M_writer(escape(c.new_latitude))
        __M_writer(u'";\n    longitude = "')
        # SOURCE LINE 20
        __M_writer(escape(c.new_longitude))
        __M_writer(u'";\n  </script>\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_init(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 23
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
        __M_writer(escape(_(u'home')))
        __M_writer(u'\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


