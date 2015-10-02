# -*- coding: utf-8 -*-
import os

from tedx.lib.base import *
from pylons.i18n import _

import math, cgi

import logging
log = logging.getLogger(__name__)

from sqlalchemy import and_

class ViewController(BaseController):

    def index(self):
        c.mode = 'list'
        c.latitude = self.prm('latitude')
        c.longitude = self.prm('longitude')
        c.password = self.prm('password')
        return redirect(url(controller=''))
    
    def place(self):
        c.mode = 'place'
        c.place_id = self.prm('id')
        c.latitude = self.prm('latitude')
        c.longitude = self.prm('longitude')
        c.password = self.prm('password')
        
        db_place = meta.Session.query(Place).filter_by(id=c.place_id).first()
        
                
        c.bicolor = 'gray'
        return render('/view.mako')
    
    def comment(self):
        c.mode = 'comment'
        c.comment_id = self.prm('id')
        c.latitude = self.prm('latitude')
        c.longitude = self.prm('longitude')
        c.password = self.prm('password')
        
        c.bicolor = 'gray'
        return render('/view.mako')
    
    def get_place_data(self):
        id = self.prm('id')
        password = self.prm('password')
        latitude = self.prm('latitude')
        longitude = self.prm('longitude')
        
        page = 1
        if self.prm('page'):
            page = int(self.prm('page'))
            
        page_size = 10
        if self.prm('page_size'):
            page_size = int(self.prm('page_size'))
        
        if not id:
            return h.toJSON({'status': 'NOK', 'message': _(u'not_id_received'), 'error_code': 0})
        
        db_place = meta.Session.query(Place).filter_by(id=id).first()
        
        if not db_place:
            return h.toJSON({'status': 'NOK', 'message': _(u'place_doesnt_exist'), 'error_code': 0})
            
        if page == 1:
            db_place.add_visit()
        
        comment_image = None
        for comment_file in db_place.comments[0].files:
            if comment_file.type == "image":
                comment_image = comment_file.path
    
        place = {"place_id": db_place.id, "place_name": db_place.name, "user_name": db_place.user.nickname, "user_avatar": db_place.user.avatar,
                  "user_id": db_place.user.id, "latitude": float(db_place.latitude), "longitude": float(db_place.longitude),
                  "num_comments": len(db_place.comments), "created_on": db_place.created_on.strftime('%d/%m/%Y %H:%M:%S'),
                  "positive_scorings": len(db_place.positive_scorings), "visits": db_place.visits, "comment_image" : comment_image,
                  "last_update": db_place.last_update.strftime('%d/%m/%Y %H:%M:%S'), "last_updater_name":db_place.comments[-1].user.nickname}
        
        db_comments = db_place.comments
        
        comments = []
        index = 0 + (page - 1) * page_size

        while len(comments) < page_size and index < len(db_place.comments):
            editable = False
            if c.user and db_comments[index].user == c.user:
                editable = True
            
            files = []
            for file in db_comments[index].files:
                files.append({"id": file.id, "name": file.name, "path": file.path, "type":file.type, "size": file.size})
            
            if db_comments[index].deleted_on:
                comment = {"comment_id": db_comments[index].id, 
                           "user_name": db_comments[index].user.nickname, 
                           "user_id": db_comments[index].user.id, 
                           "user_avatar":db_comments[index].user.avatar,
                           "created_on": db_comments[index].created_on.strftime('%d/%m/%Y %H:%M:%S'), 
                           "deleted_on": db_comments[index].deleted_on.strftime('%d/%m/%Y %H:%M:%S'),
                           "comment_number": index + 1}
            else:
                comment = {"comment_id": db_comments[index].id, 
                           "comment_title": db_comments[index].title, 
                           "comment_content": db_comments[index].content, 
                           "user_avatar":db_comments[index].user.avatar,
                           "user_name": db_comments[index].user.nickname, 
                           "user_id": db_comments[index].user.id,
                           "positive_scorings": len(db_comments[index].positive_scorings), 
                           "negative_scorings": len(db_comments[index].negative_scorings),
                           "bidi_title": db_comments[index].content[:500],
                           "last_update": db_comments[index].last_update.strftime('%d/%m/%Y %H:%M:%S'),
                           "created_on": db_comments[index].created_on.strftime('%d/%m/%Y %H:%M:%S'), 
                           "files": files, 
                           "comment_number": index + 1, 
                           "editable": editable}
            comments.append(comment)
            index += 1
            
        return h.toJSON({'status': 'OK', 'place': place, 'comments': comments, 'pages': int(math.ceil(float(len(db_place.comments)) / float(page_size))), 'current_page': page})
    
    def get_comment_data(self):
        id = self.prm('id')
        
        if not id:
            return h.toJSON({'status': 'NOK', 'message': _(u'not_id_received'), 'error_code': 0})
        
        db_comment = meta.Session.query(Comment).filter_by(id=id).first()
        
        if not db_comment:
            return h.toJSON({'status': 'NOK', 'message': _(u'comment_doesnt_exist'), 'error_code': 0})
        
        files = []
        for file in db_comment.files:
            files.append({"id": file.id, 
                          "name": file.name, 
                          "path": file.path, 
                          "type":file.type, 
                          "size": file.size})
        
        comment = {"comment_id": db_comment.id, 
                   "comment_title": db_comment.title, 
                   "comment_content": db_comment.content, 
                   "user_name": db_comment.user.nickname,
                   "user_id": db_comment.user.id, 
                   "user_avatar": db_comment.user.avatar, 
                   "latitude": float(db_comment.place.latitude), 
                   "longitude": float(db_comment.place.longitude), 
                   "place_id": db_comment.place.id,
                   "place_name": db_comment.place.name, 
                   "place_creator_name": db_comment.place.creator.name, 
                   "place_creator_id": db_comment.place.creator.id,
                   "created_on": db_comment.created_on.strftime('%d/%m/%Y %H:%M:%S'), 
                   "positive_scorings": len(db_comment.positive_scorings), 
                   "negative_scorings": len(db_comment.negative_scorings),
                   "last_update": db_comment.last_update.strftime('%d/%m/%Y %H:%M:%S'), 
                   "files":files}
        
        return h.toJSON({'status': 'OK', 'comment': comment})
    
    def delete_place(self):
        db_place = meta.Session.query(Place).filter_by(id=request.params.get('id')).first()
        if not c.user or c.user.id != db_place.user.id:
            return h.toJSON({"status":"NOK", "message":_(u'error')})
        
        place_tags = meta.Session.query(Place_tag).filter(Place_tag.place_id == db_place.id).all()
        for place_tag in place_tags:
            meta.Session.delete(place_tag)
            meta.Session.commit()
        for comment in db_place.comments:
            comment_tags = meta.Session.query(Comment_tag).filter(Comment_tag.comment_id == comment.id).all()
            for comment_tag in comment_tags:
                meta.Session.delete(comment_tag)
                meta.Session.commit()
        meta.Session.delete(db_place)
        meta.Session.commit()
        return h.toJSON({"status":"OK"})
    
    def delete_comment(self):
        comment_id = self.prm('id')
        
        db_comment = meta.Session.query(Comment).filter_by(id=comment_id).first()
        
        if not db_comment:
            return h.toJSON({'status': 'NOK', 'message': _(u'comment_doesnt_exist'), 'error_code': 0})
            
        if c.user != None:
            if c.user.id == db_comment.user.id:
                db_comment.deleted_on = datetime.datetime.now()
            else:
                return h.toJSON({'status': 'NOK', 'error_code': 0})
        else:
            return h.toJSON({'status': 'NOK', 'error_code': 1})
        
        meta.Session.commit()

        return h.toJSON({'status': 'OK'})
        
    def add_place_scoring(self):
        id = self.prm('place_id')
        db_place = meta.Session.query(Place).filter_by(id=id).first()
        
        if not c.user:
            return h.toJSON({'status': 'NOK', 'message': _(u'you_must_login_to_vote'), 'error_code': 1})

        if not db_place:
            return h.toJSON({'status': 'NOK', 'message': _(u'not_id_received'), 'error_code': 0})
        
        success = db_place.add_scoring(c.user, self.prm('value'))
        if not success:
            return h.toJSON({'status': 'NOK', 'message': _(u'you_have_already_voted_this_place'), 'error_code': 0})
        else:
            return h.toJSON({'status': 'OK' })
    
    def add_comment_scoring(self):
        id = self.prm('comment_id')
        db_comment = meta.Session.query(Comment).filter_by(id=id).first()
        
        if not c.user:
            return h.toJSON({'status': 'NOK', 'message': _(u'you_must_login_to_vote'), 'error_code': 1})

        if not db_comment:
            return h.toJSON({'status': 'NOK', 'message': _(u'not_id_received'), 'error_code': 0})
                
        success = db_comment.add_scoring(c.user, self.prm('value'))
        if not success:
            return h.toJSON({'status': 'NOK', 'message': _(u'you_have_already_voted_this_comment'), 'error_code': 0})
        else:
            return h.toJSON({'status': 'OK' })
