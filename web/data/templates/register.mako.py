# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 6
_modified_time = 1340642769.3372369
_template_filename='/var/www/feelicity/20120625120040/tedx/templates/register.mako'
_template_uri='/register.mako'
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
        __M_writer(u'\n    ')
        # SOURCE LINE 5
        __M_writer(u'\n    ')
        # SOURCE LINE 10
        __M_writer(u'\n    ')
        # SOURCE LINE 12
        __M_writer(u'\n    ')
        # SOURCE LINE 90
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
        # SOURCE LINE 13
        __M_writer(u'\n        <div id="manchaIzda">\n            <div class="register">\n                <table>\n                    <tr>\n                        <td>\n                        ')
        # SOURCE LINE 19
        __M_writer(escape(_(u'email')))
        __M_writer(u'*:\n                        </td>\n                        <td width="250" align="right">\n')
        # SOURCE LINE 22
        if c.user is not None:
            # SOURCE LINE 23
            __M_writer(u'                        ')
            __M_writer(escape(c.user.email))
            __M_writer(u'\n')
            # SOURCE LINE 24
        else:
            # SOURCE LINE 25
            __M_writer(u'                        <input type="text" id="email" maxlength="256" />\n')
            pass
        # SOURCE LINE 27
        __M_writer(u'                        </td>\n                    </tr>\n                    <tr>\n                        <td>\n                        ')
        # SOURCE LINE 31
        __M_writer(escape(_(u'password')))
        __M_writer(u'*:\n                        </td>\n                        <td width="250" align="right">\n                        <input type="password" id="contra" maxlength="32" />\n                        </td>\n                    </tr>\n                    <tr>\n                        <td>\n                        ')
        # SOURCE LINE 39
        __M_writer(escape(_(u'repeat_password')))
        __M_writer(u'*:\n                        </td>\n                        <td width="250" align="right">\n                        <input type="password" id="contra_confirmation" maxlength="32" />\n                        </td>\n                    </tr>\n                    <tr>\n                        <td>\n                        ')
        # SOURCE LINE 47
        __M_writer(escape(_(u'nickname')))
        __M_writer(u'*:\n                        </td>\n                        <td width="250" align="right">\n')
        # SOURCE LINE 50
        if c.user is not None:
            # SOURCE LINE 51
            __M_writer(u'                        <input type="text" id="nickname" maxlength="32" value="')
            __M_writer(escape(c.user.nickname))
            __M_writer(u'" />\n')
            # SOURCE LINE 52
        else:
            # SOURCE LINE 53
            __M_writer(u'                        <input type="text" id="nickname" maxlength="32" />\n')
            pass
        # SOURCE LINE 55
        __M_writer(u'                        </td>\n                    </tr>\n                    <tr>\n                        <td>\n                        ')
        # SOURCE LINE 59
        __M_writer(escape(_(u'sex')))
        __M_writer(u'*:\n                        </td>\n                        <td width="250" align="left">\n')
        # SOURCE LINE 62
        if not c.user:
            # SOURCE LINE 63
            __M_writer(u'\t\t\t\t\t\t<div class="sexcontainer">\n\t\t\t\t\t\t\t<div for="man" class="sex">\n\t\t\t\t\t\t\t\t')
            # SOURCE LINE 65
            __M_writer(escape(_(u'man')))
            __M_writer(u'\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t<input name="sex" type="radio" value="V" style="width:15px;"/>\n\t\t\t\t\t\t\t<div for="woman" class="sex">\n\t\t\t\t\t\t\t\t')
            # SOURCE LINE 69
            __M_writer(escape(_(u'woman')))
            __M_writer(u'\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t<input name="sex" type="radio" value="M" style="width:15px;"/>\n\t\t\t\t\t\t</div>\n')
            pass
        # SOURCE LINE 74
        __M_writer(u'                        </td>\n                    </tr>\n                </table>\n                <a href="javascript:void(0);" style="float:right; margin-top: 20px; color:white; text-decoration:none;" onclick="register();" class="accion">')
        # SOURCE LINE 77
        __M_writer(escape(_(u'save')))
        __M_writer(u'</a>\n                <div class="clear">\n                </div>\n            </div>\n        </div>\n        <div id="manchaDcha">\n            <div id="colDetStreetr">\n                <img src="/images/flechaUp.png" />\n                <div class="estiloNegro">\n                    ')
        # SOURCE LINE 86
        __M_writer(escape(_(u'click_on_the_map_to_set_the_position')))
        __M_writer(u'\n                </div>\n            </div>\n        </div>\n    ')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_head(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 6
        __M_writer(u'\n        <link rel="stylesheet" type="text/css" href="/css/register.css" />\n        <script type="text/javascript" src="/js/register.js">\n        </script>\n    ')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_init(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 11
        __M_writer(u'\n    ')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_title(context):
    context.caller_stack._push_frame()
    try:
        _ = context.get('_', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 3
        __M_writer(u'\n        ')
        # SOURCE LINE 4
        __M_writer(escape(_(u'register')))
        __M_writer(u'\n    ')
        return ''
    finally:
        context.caller_stack._pop_frame()


