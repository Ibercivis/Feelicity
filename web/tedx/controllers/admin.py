# -*- coding: UTF-8 -*-
import sys
import os
import shutil
import hashlib
import Image
import datetime
import string
import simplejson



from threading import Thread
import subprocess

from tedx.lib.base import *
from pylons.i18n import _

from sqlalchemy import orm, and_, desc, select, func

import logging
log = logging.getLogger(__name__)

class AdminController(BaseController):
    requires_admin = True

    def index(self):
        return render('/admin.mako')
    
    def get_tags(self):
        a = select([Comment_tag.tag_id, func.count(Comment_tag.tag_id)], group_by=[Comment_tag.tag_id], order_by = [desc(func.count(Comment_tag.tag_id))])
        a = a.alias('query')
        results = meta.Session.query(a).limit(30)
        tags = []
        for result in results:
            tag = meta.Session.query(Tag).filter_by(id=result.tag_id).one()
            if tag.name != "":
                tags.append({"name": tag.name, "value": result[1], "id": tag.id})
        
        return simplejson.dumps({'status': 'OK', 'tags':tags})
    
    def search(self):
        type = request.params.get('type')
        query = request.params.get('query')
        
        if type == "users":
            if query != "":
                results = meta.Session.query(User).filter(or_(User.nickname.like("%" + query + "%"),User.name.like("%" + query + "%"),User.surnames.like("%" + query + "%"),User.description.like("%" + query + "%"),User.city.like("%" + query + "%"),User.address.like("%" + query + "%"),User.country.like("%" + query + "%"))).all()
            else:
                results = meta.Session.query(User).all()
            users = []
            for user in results:
                latitude = float(0)
                longitude = float(0)
                if user.latitude:
                    latitude = float(user.latitude)
                if user.longitude:
                    longitude = float(user.longitude)
                users.append({"id":user.id, "nickname":user.nickname, "email":user.email, 
                              "avatar":user.avatar, "description":user.description,  "created_on": user.created_on.strftime('%d/%m/%Y %H:%M:%S'),
                              "latitude":latitude, "longitude": longitude})
            return simplejson.dumps({"results":users})
        elif type == "places":
            if query != "":
                results = meta.Session.query(Place).filter(Place.name.like("%" + query + "%")).all()
            else:
                results = meta.Session.query(Place).all()
            places = []
            for place in results:
                places.append({"id":place.id, "name":place.name, "user_id":place.user.id, "user_name": place.user.nickname, "longitude": float(place.longitude),
                               "latitude":float(place.latitude), "city": place.city, "country": place.country, "visits": place.visits, "created_on":place.created_on.strftime('%d/%m/%Y %H:%M:%S')
                               })
            return simplejson.dumps({"results":places})
        else:
            if query != "":
                results = meta.Session.query(Comment).filter(or_(Comment.title.like("%" + query + "%"),Comment.content.like("%" + query + "%"))).all()
            else:
                results = meta.Session.query(Comment).all()
            comments = []
            for comment in results:
                comments.append({"id":comment.id, "place_id":comment.place.id, "user_id":comment.user.id, "longitude":float(comment.place.longitude), "latitude":float(comment.place.latitude),
                                "title":comment.title, "content":comment.content, "created_on":comment.created_on.strftime('%d/%m/%Y %H:%M:%S')})
            return simplejson.dumps({"results":comments})
              
    def delete_entity(self):
        if request.params.get('ids'):
            print 'ja'
            ids = simplejson.loads(self.prm('ids'))
            
            if request.params.get('type') == 'users':
                type = User     
            elif request.params.get('type') == 'places':
                type = Place   
            else:
                type = Comment
                
            for element_id in ids:
                db_object = meta.Session.query(type).filter_by(id=element_id).first()
                if db_object:
                    if type=='users':
                        for place in db_object.places:
                            place_tags = meta.Session.query(Place_tag).filter(Place_tag.place_id == place.id).all()
                            for place_tag in place_tags:
                                meta.Session.delete(place_tag)
                    meta.Session.delete(db_object)
            
            meta.Session.commit()
            return 'OK'
        else:
            return 'NOK'
    
    def update_place(self):
        place = meta.Session.query(Place).filter_by(id=request.params.get('id')).first()
        place.city = request.params.get('city')
        place.country = request.params.get('country')
        meta.Session.add(place)
        meta.Session.commit()
        
    def update_entity(self):
        if request.params.get('type') == 'comments':
            comment = meta.Session.query(Comment).filter_by(id=request.params.get('id')).first()
            if comment:
                comment.latitude = request.params.get('latitude')
                comment.longitude = request.params.get('longitude')
                comment.title = request.params.get('title')
                comment.content = request.params.get('content')
                meta.Session.add(comment)
                meta.Session.commit()
                return 'OK'