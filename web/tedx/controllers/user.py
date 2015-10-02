# -*- coding: utf-8 -*-
import os
from tedx.lib.base import *
from pylons.i18n import _

import logging
log = logging.getLogger(__name__)

class UserController(BaseController):

    def index(self):
        return redirect(url(controller=''))

    def following(self):
        current_user = c.user
        if not current_user:
            return simplejson.dumps({'status': 'NOK', 'message':_(u'you_must_be_logged'), 'error_code': 1})
        
        following = []
        for followed in current_user.following:
            following.append({"id": followed.id, "email": followed.email, "nickname": followed.nickname})
        
        return simplejson.dumps({ "status": "OK", "users": following })
    
    def follow(self):
        current_user = c.user
        if not current_user:
            return simplejson.dumps({'status': 'NOK', 'message':_(u'you_must_be_logged'), 'error_code': 1})
        id = request.params.get('id')

        ## Si no nos han enviado el id, devolvemos un error
        if not id:
            return simplejson.dumps({'status': 'NOK', 'message': _(u'not_id_received'), 'error_code': 0})

        followed_user = meta.Session.query(User).filter_by(id=id).first()
        if followed_user == current_user:
            return simplejson.dumps({'status': 'NOK', 'message': _(u'not_allowed_to_follow'), 'error_code': 0})
        ## Comprobamos que no lo estemos siguiendo ya
        for followed in current_user.following:
            if followed.id == id:
                return simplejson.dumps({'status': 'NOK', 'message': _(u'already_following'), 'error_code': 0})

        current_user.follow(followed_user)
        return simplejson.dumps({"status": "OK", 'message':_(u'now_following') })

    def unfollow(self):
        current_user = c.user
        if not current_user:
            return simplejson.dumps({'status': 'NOK', 'message':_(u'you_must_be_logged'), 'error_code': 1})
        
        id = request.params.get('id')

        ## Si no han enviado el id, devolvemos un error
        if not id:
            return simplejson.dumps({'status': 'NOK', 'message': _(u'not_id_received'), 'error_code': 0})

        ## Comprobamos que lo estamos siguiendo
        boring_user = None
        for followed in current_user.following:
            if followed.id == id:
                boring_user = followed

        if boring_user is None:
            return simplejson.dumps({'status': 'NOK', 'message': _(u'currently_not_following'), 'error_code': 0})

        current_user.unfollow(boring_user)
        return simplejson.dumps({"status": "OK", 'message':_(u'currently_not_following')})

    def search(self):
        q = request.params.get('q')

        if q is None or q == '':
            users = meta.Session.query(User).order_by(User.last_activity).limit(20).all()
        else:
            users = meta.Session.query(User).filter(User.nickname.like('%' + q + '%'))

        results = []
        for user in users:
            results.append({"id": user.id, "email": user.email, "nickname": user.nickname, "avatar": user.avatar})

        return simplejson.dumps({"status": "OK", "results": results})
