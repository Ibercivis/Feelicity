"""The base Controller API

Provides the BaseController class for subclassing.
"""
from pylons import tmpl_context as c, cache, config, request, response, session, url, app_globals
from pylons.controllers import WSGIController
from pylons.templating import render_mako as render
from pylons.controllers.util import abort, etag_cache, redirect
from pylons.i18n import get_lang, set_lang, ugettext, _

from tedx.lib import helpers as h
from tedx.model import meta
from tedx.model.meta import Session
from tedx.model.comment import *
from tedx.model.place import *
from tedx.model.scoring import *
from tedx.model.tag import *
from tedx.model.user import *

from sqlalchemy import and_, or_, not_, desc

from email.MIMEText import MIMEText
from email.MIMEMultipart import MIMEMultipart
import smtplib, simplejson, cgi, os

class BaseController(WSGIController):
    requires_auth = False
    requires_admin = False
    
    def __before__(self, controller, action):        
        if 'lang' not in session:
            session['lang'] = 'es'
            #user_agent_language = request.languages[0][0:2]
            #if user_agent_language in app_globals.languages:
            #    session['lang'] = user_agent_language
            session.save()
        
        set_lang(session['lang'])
        
        c.user = None
        if 'user_id' in session:
            c.user = meta.Session.query(User).filter_by(id = session['user_id']).first()
            
        if self.requires_auth and not c.user:
            return redirect(url(controller=''))
            
        if self.requires_admin and (not c.user or c.user.type != "admin"):
            return redirect(url(controller=''))
            
    def prm(self, param):
        if request.params.get(param) != None:
            return unicode(cgi.escape(request.params.get(param))).encode('utf8')
        return None

    def __call__(self, environ, start_response):
        """Invoke the Controller"""
        # WSGIController.__call__ dispatches to the Controller method
        # the request is routed to. This routing information is
        # available in environ['pylons.routes_dict']
        try:
            return WSGIController.__call__(self, environ, start_response)
        finally:
            Session.remove()
