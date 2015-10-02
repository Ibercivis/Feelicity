# -*- coding: utf-8 -*-

from tedx.lib.base import *
from pylons.i18n import _

import logging
log = logging.getLogger(__name__)

class RegisterController(BaseController):

    def index(self):
        c.bicolor = 'gray'
        return render('/register.mako')
    
    def save(self):
        email = self.prm('email')
        password = self.prm('password')
        nickname = self.prm('nickname')
        latitude = self.prm('latitude')
        longitude = self.prm('longitude')
        sex = self.prm('sex') == 'V'
        
        if not email:
            return h.toJSON({"status": "NOK", "message": _(u"email_cannot_be_null"), 'error_code': 0})
        elif not password:
            return h.toJSON({"status": "NOK", "message": _(u"password_cannot_be_null"), 'error_code': 0})
            
        db_user = meta.Session.query(User).filter_by(email=email).first()
        if db_user is not None:
            return h.toJSON({"status": "NOK", "message": _(u"email_already_registered"), 'error_code': 0})
        
        reserved_nicknames = ['about', 'common', 'content', 'error', 'home', 'notification', "my_account",
                              'profile', 'register', 'view', 'bidis', 'css', 'files', 'images', 'js', 'swf']
        db_user = meta.Session.query(User).filter_by(nickname=nickname).first()
        if db_user is not None or nickname in reserved_nicknames:
            return h.toJSON({"status": "NOK", "message": _(u"nickname_already_registered"), 'error_code': 0})
            
        c.user = User(email, password, nickname, sex, None, latitude, longitude)
        
        session['user_id'] = c.user.id
        session.save()
        
        return h.toJSON({"status": "OK", "message": _(u"successfully_registered")})
        
