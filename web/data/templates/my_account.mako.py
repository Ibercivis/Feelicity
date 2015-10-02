# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 6
_modified_time = 1342469731.236793
_template_filename='/var/www/feelicity/20120625120040/tedx/templates/my_account.mako'
_template_uri='/my_account.mako'
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
        # SOURCE LINE 20
        __M_writer(u'\n    ')
        # SOURCE LINE 22
        __M_writer(u'\n    ')
        # SOURCE LINE 142
        __M_writer(u'\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_content(context):
    context.caller_stack._push_frame()
    try:
        _ = context.get('_', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 23
        __M_writer(u'\n        <iframe style="display:none;" id="stickers_download_iframe" name="logo_download_iframe">\n        </iframe>\n        \n        <div class="sidebarIzq">\n        \t<h3>')
        # SOURCE LINE 28
        __M_writer(escape(_(u'profile')))
        __M_writer(u'</h3>\n        \t<div id="details" class="item left">\n\t            <div  id="avatarPerfil" style="float:left;"></div>\n\t            <div  id="nickname_profile" style="clear:both;"></div>\n\t            <div  style="clear:both;" class="edit"><div class="acordion"><a href="javascript:void(0);" onclick="$(\'#details2\').toggle(\'blind\');$(this).parent().toggleClass(\'acordion_active\');" class="edit">Editar</a></div></div>\n\t            <div class="account_container">\n                    <div id="details2" style="display:none;">\n                        <div style="position: relative; width: 150px; text-align: center; ">\n                            <div style="margin-bottom: 10px; margin-top:10px; float:left;">\n                                <a href="javascript:void(0);" onclick="$(\'#avatar_file_div\').show(\'blind\')" >')
        # SOURCE LINE 37
        __M_writer(escape(_(u'change')))
        __M_writer(u'</a>\n                                <a href="javascript:void(0);" >')
        # SOURCE LINE 38
        __M_writer(escape(_(u'remove')))
        __M_writer(u'</a>\n                            </div>\n                            <div id="avatar_file_div" style="margin-bottom: 10px; display:none;">\n                                <form id="form_avatar" enctype="multipart/form-data" target="file_upload_avatar" method="post" action="/my_account/upload_avatar">\n                                    <input type="file" id="avatar" value="" size="14" name="file" accept=""></input>\n                                    <input type="hidden" name="type" value=""></input>\n                                    <iframe id="file_upload_avatar" name="file_upload_avatar" style="display:none;">\n                                    </iframe>\n                                </form>\n                            </div>\n                        </div>\n                        <div class="clear">\n                        </div>\n                        \n                        <div id="change_password_div">\n                            <div class="detail_title">\n                                <span class="titulo01">')
        # SOURCE LINE 54
        __M_writer(escape(_(u'password')))
        __M_writer(u':</span>\n                            </div>\n                            <div class="detail_value">\n                                <a  href="javascript:void(0);" onclick="change_password();">')
        # SOURCE LINE 57
        __M_writer(escape(_(u'change password')))
        __M_writer(u'</a>\n                            </div>\n                            <div class="clear">\n                            </div>\n                        </div>\n                        <div id="new_password_div" style="display: none;">\n                            <div class="detail_title">\n                                <span class="titulo01">')
        # SOURCE LINE 64
        __M_writer(escape(_(u'old_password')))
        __M_writer(u':</span>\n                            </div>\n                            <div class="detail_value">\n                                <input type="password" id="password1" maxlength="32" class="long_input" />\n                            </div>\n                            <div class="clear">\n                            </div>\n                            <div class="detail_title">\n                                <span class="titulo01">')
        # SOURCE LINE 72
        __M_writer(escape(_(u'new_password')))
        __M_writer(u':</span>\n                            </div>\n                            <div class="detail_value">\n                                <input type="password" id="password2" maxlength="32" class="long_input" />\n                            </div>\n                            <div class="clear">\n                            </div>\n                        </div>\n\t\t\t\t\t\t<div class="detail_title">\n                            <span class="titulo01">')
        # SOURCE LINE 81
        __M_writer(escape(_(u'nickname')))
        __M_writer(u':</span>\n                        </div>\n                        <div class="detail_value">\n                            <input type="text" id="nickname" maxlength="32" class="long_input" />\n                        </div>\n                        <div class="clear">\n                        </div>\n                        <div class="detail_title">\n                            <span class="titulo01">')
        # SOURCE LINE 89
        __M_writer(escape(_(u'description')))
        __M_writer(u':</span>\n                        </div>\n                        <div class="detail_value">\n                            <input type="text" id="description" maxlength="32" class="long_input" />\n                        </div>\n                        <div class="clear">\n                        </div>\n\t\t\t\t\t\t<div style="margin-top:50px;"><a class="accion" style="float:right;color:white;" href="javascript:void(0)" onclick="save()" id="print_Stickers_button">')
        # SOURCE LINE 96
        __M_writer(escape(_(u'save')))
        __M_writer(u'</a></div>\n                    </div>\n                </div>\n\t            <ul class="clear">\n\t            \t<li><a id="comments" href="#"></a></li>\n\t            \t<li><a id="likes" href="#"></a></li>\n\t            \t<li><a id="visits" href="#"></a></li>\n\t            </ul>\n\t        </div>\n\t        \n                \n        </div>\n        <div class="content_center">\n        \t<h3>')
        # SOURCE LINE 109
        __M_writer(escape(_(u'happy_moments')))
        __M_writer(u'</h3>\n        \t<div id="list"></div>\n        \t<div id="srToolsDown">\n            </div>\n        </div>\n        \t\n\n\t<div class="sidebarDer">\n    \t  <div id="logos">\n\t    <h3>')
        # SOURCE LINE 118
        __M_writer(escape(_(u'idea')))
        __M_writer(u':</h3>\n\t    <a href="http://tedxzaragoza.com">\n\t      <img src="/images/TEDx_logo.png" alt="Logo TEDx Zaragoza" />\n\t    </a>\n\t    <h3>')
        # SOURCE LINE 122
        __M_writer(escape(_(u'developed')))
        __M_writer(u':</h3>\n\t    <a href="http://bifi.es"><img src="/images/BIFI_logo.png" alt="Logo BIFI" /></a>\n\t    <a href="http://www.ibercivis.es"><img src="/images/logo_fundacion.png" alt="Logo Fundaci\xf3n Ibercivis" /></a>\n\t  </div>\n\n\t  <h3>')
        # SOURCE LINE 127
        __M_writer(escape(_(u'follow_us')))
        __M_writer(u':</h3>\n\t  <a href="http://www.facebook.com/FeelicityApp" target="_blank">\n\t    <img src="/images/facebook.png"  class="left social" />\n\t  </a>\n\t  <a href="http://www.twitter.com/FeelicityApp" target="_blank">\n\t    <img src="/images/twitter.png" class="left social" />\n\t  </a>\n\n\t  <h3>')
        # SOURCE LINE 135
        __M_writer(escape(_(u'available')))
        __M_writer(u':</h3>\n    \t  <a href="http://itunes.apple.com/app/feelicity/id452958224?mt=8" target="_blank"><img src="/images/imovil.png" class="left" /></a>\n    \t  <a href="https://market.android.com/details?id=com.bifi.feelicity" target="_blank"><img src="/images/androidmovil.png" class="left" /></a>\n\n\t  <h3>')
        # SOURCE LINE 139
        __M_writer(escape(_(u'happy_cities')))
        __M_writer(u':</h3>\n\t  <div id="happy_cities"></div>\n\t</div>\n    ')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_head(context):
    context.caller_stack._push_frame()
    try:
        c = context.get('c', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 6
        __M_writer(u'\n        <link rel="stylesheet" type="text/css" href="/css/common.css" />\n        <link rel="stylesheet" type="text/css" href="/css/my_account.css" />\n        <script type="text/javascript" src="/js/my_account.js">\n        </script>\n        <script type="text/javascript">\n')
        # SOURCE LINE 12
        if c.user.latitude and c.user.longitude:
            # SOURCE LINE 13
            __M_writer(u'            latitude = "')
            __M_writer(escape(c.user.latitude))
            __M_writer(u'"\n            longitude = "')
            # SOURCE LINE 14
            __M_writer(escape(c.user.longitude))
            __M_writer(u'"\n')
            pass
        # SOURCE LINE 16
        if c.user:
            # SOURCE LINE 17
            __M_writer(u'            user_id = "')
            __M_writer(escape(c.user.id))
            __M_writer(u'";\n')
            pass
        # SOURCE LINE 19
        __M_writer(u'        </script>\n    ')
        return ''
    finally:
        context.caller_stack._pop_frame()


def render_init(context):
    context.caller_stack._push_frame()
    try:
        __M_writer = context.writer()
        # SOURCE LINE 21
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
        __M_writer(escape(_(u'my_account')))
        __M_writer(u'\n    ')
        return ''
    finally:
        context.caller_stack._pop_frame()


