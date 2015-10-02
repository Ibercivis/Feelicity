# -*- coding: utf-8 -*-
import shutil
import Image

from tedx.lib.base import *
from pylons.i18n import _

import logging
log = logging.getLogger(__name__)

class ProfileController(BaseController):

    def index(self):
        c.db_user = c.user
        return render('/profile.mako')
    
    def view(self, nickname):
        c.db_user = meta.Session.query(User).filter(and_(User.nickname==nickname,User.deleted_on==None)).first()
        return render('/profile.mako')
        
    def get_profile_data(self):
        user_id = self.prm("user_id")
        
        db_user = meta.Session.query(User).filter_by(id=user_id).first()
        if db_user:
            
            return h.toJSON({"status": "OK", "id": db_user.id, "nickname": db_user.nickname, "email": db_user.email,
                                      'description': db_user.description,
                                     'latitude': db_user.latitude, 'longitude': db_user.longitude, "avatar": db_user.avatar})
        else:
            return h.toJSON({"status": "NOK", "message": _(u"couldnt_get_info"), 'error_code': 0})
        
    def following(self):
        current_user = meta.Session.query(User).filter(User.id == self.prm("user_id")).first()
        if not current_user:
            return simplejson.dumps({'status': 'NOK', 'message':_(u'you_must_be_logged'), 'error_code': 1})
        
        following = []
        for followed in current_user.following:
            following.append({"id": followed.id, "email": followed.email, "nickname": followed.nickname})
        
        return simplejson.dumps({ "status": "OK", "users": following })
    
    def get_relations(self):
        current_user = meta.Session.query(User).filter(User.id == self.prm("user_id")).first()
        if current_user:
            following = []
            for followed in current_user.following:
                if not followed.deleted_on:
                    following.append({"id": followed.id, "email": followed.email, "nickname": followed.nickname, "avatar":followed.avatar})
            followers = []
            for follower in current_user.followers:
                if not follower.deleted_on:
                    followers.append({"id": follower.id, "email": follower.email, "nickname": follower.nickname, "avatar":follower.avatar})
            return h.toJSON({"status": "OK", "following":following, "followers":followers})
        else:
            return h.toJSON({"status": "NOK", "message": _(u"couldnt_get_info"), 'error_code': 1})

    
