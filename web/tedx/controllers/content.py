# -*- coding: utf-8 -*-
import sys
import os
import shutil
import hashlib
import Image
import datetime
import string
import random
import simplejson



from threading import Thread
import subprocess

from tedx.lib.base import *
from pylons.i18n import _

from sqlalchemy import orm, and_, desc, select, func
from geopy import geocoders
from random import choice,uniform

import logging
log = logging.getLogger(__name__)

class ContentController(BaseController):
    requires_auth = True

    def index(self):
        if request.params.get('place'):
            place = meta.Session.query(Place).filter(Place.id==request.params.get('place')).first()
            if place:
                if place.user == c.user:
                    c.place = place
                    return render('/content.mako')
                else:
                    return render('/home.mako')
            else:
                return render('/home.mako')
        c.bicolor = 'gray'
        return render('/content.mako')
    
    
            
    def new_place(self):
        place_name = self.prm('place_name')
        latitude = self.prm('latitude')
        longitude = self.prm('longitude')
        comment_title = self.prm('comment_title')
        comment_content = self.prm('comment_content')
        place_tags = self.prm('place_tags')
        city = self.prm('city')
        country = self.prm('country')
        
        edit_place_id = self.prm('edit_place_id')
        
        if not c.user:
            return h.toJSON({'status': 'NOK', 'message': _(u'you_must_login_to_add_content'), 'error_code': 1})
        
        if edit_place_id:
            place = meta.Session.query(Place).filter(Place.id == edit_place_id).first()
            if not place or place.user != c.user:
                return h.toJSON({'status': 'NOK', 'message': _(u'error'), 'error_code': 1})
            else:
                place.empty = False
                place.name = place_name
                place.latitude = latitude
                place.longitude = longitude
        else:
            if city is None or country is None or city== "" or country == "": 
                g = geocoders.Google(domain='maps.google.es')
                point = [latitude,longitude]
                (new_place,new_point) = g.reverse(point)
                address = new_place.split(',')
                city = address[-2].split(" ")[-1]
                country = address[-1]
            
            place = c.user.add_place(latitude, longitude, city, country, place_name)
        
        
            
        tags = []
        if place_tags is not None:
            tags = place_tags.split(' ')
        if edit_place_id:
            db_comment = meta.Session.query(Comment).filter(Comment.id == place.comments[0].id).one()
            db_comment.content = comment_content
            db_comment.title = comment_title
        else:
            db_comment = place.add_comment(c.user, comment_content, comment_title)
        users = []
        for tag in tags:
            db_tag = meta.Session.query(Tag).filter(Tag.name == tag).first()
            if db_tag is None:
                Tag(tag)
                db_tag = meta.Session.query(Tag).filter(Tag.name == tag).first()
            place.add_tag(db_tag)
            db_comment.add_tag(db_tag)
        
        return h.toJSON({'status': 'OK', 'comment_id': db_comment.id, 'place_id':place.id})
    
    def new_empty_place(self):
        if not c.user:
            return h.toJSON({'status': 'NOK', 'message': _(u'you_must_login_to_add_content'), 'error_code': 1})
        
        place = c.user.add_place(0, 0, "", True)
        db_comment = place.add_comment(c.user, "", "")
        return h.toJSON({'status': 'OK', 'message':place.id })
    
        
    def new_comment(self):
        place_id = self.prm('place_id')
        comment_title = self.prm('comment_title')
        comment_content = self.prm('comment_content')
        comment_tags = self.prm('comment_tags')
        
        if not c.user:
            return h.toJSON({'status': 'NOK', 'message': _(u'you_must_login_to_add_content'), 'error_code': 1})
        
        db_place = meta.Session.query(Place).filter_by(id=place_id).first()
        
        if not db_place:
            return h.toJSON({'status': 'NOK', 'message': _(u'no_place_associated'), 'error_code': 0})
        
        if not comment_content:
            return h.toJSON({'status': 'NOK', 'message': _(u'empty_comment'), 'error_code': 0})
            
        db_comment = db_place.add_comment(c.user, comment_content, comment_title)
        tags = []
        if comment_tags is not None:
            tags = comment_tags.split(' ')
        for tag in tags:
            db_tag = meta.Session.query(Tag).filter(Tag.name == tag).first()
            if db_tag is None:
                Tag(tag)
                db_tag = meta.Session.query(Tag).filter(Tag.name == tag).first()
            db_comment.add_tag(db_tag)
        
        users = []
        
        return h.toJSON({'status': 'OK', 'comment_id': db_comment.id})
        
    def upload_file(self):
        file = request.params.get('file')
        comment_id = self.prm('comment_id')
        type = self.prm('type')
        
        print str(file) + ',' + str(comment_id) + ',' + str(type)
        
        if file is not None and file != '':
            if type != 'youtube':
                name = file.name
                folder = c.user.id.lstrip(os.sep)
                if not os.path.isdir(os.path.join(os.getcwd(), 'tedx/public/files/', folder)):
                    os.mkdir(os.path.join(os.getcwd(), 'tedx/public/files/', folder))
                
            db_comment = meta.Session.query(Comment).filter_by(id=comment_id).first()
            if db_comment:
                if type == 'youtube':
                    db_file = db_comment.add_file(type, "")
                    db_file.path = file
                elif type == 'image':
                    db_file = db_comment.add_file(type, file.filename)
                    full_path = os.path.join(os.getcwd(), 'tedx/public/files/', folder, db_file.id)
                    db_file.path = os.path.join('/files', folder, db_file.id)
                    db_file.size = len(file.value)
                    permanent_file = open(full_path, 'w')
        
                    shutil.copyfileobj(file.file, permanent_file)
                    file.file.close()
                    permanent_file.close()
                    
                    try:
                        im = Image.open(os.path.join(os.getcwd(),'tedx/public/files/', folder, db_file.id.lstrip(os.sep)))
                    except Exception, e:
                        print e
                        os.remove(os.path.join(os.getcwd(),'tedx/public/files/', folder, db_file.id.lstrip(os.sep)))
                        meta.Session.delete(db_file)
                        meta.Session.commit()
                        return h.toJSON({'status': 'NOK', 'message': _(u'file_selected_is_not_an image'), 'error_code': 0})
                    
                    im = im.convert('RGB')
                    width, height = im.size
                    filename = db_file.id + '.jpg'
                    filenamemid = db_file.id + '_mid.jpg'
                    filenamemini = db_file.id + '_small.jpg'
                    out = im
                    outmid = im
                    outmini = im
                    imAspect = float(width)/float(height)
                    
                    # Default
                    if width >app_globals.default_image_size or height >app_globals.default_image_size:
                        if width > height:
                            out = im.resize((app_globals.default_image_size,int(float(app_globals.default_image_size) / imAspect)), Image.ANTIALIAS)
                        else:
                            out = im.resize((int(float(app_globals.default_image_size) * imAspect),app_globals.default_image_size), Image.ANTIALIAS)
                            
                    # image medio
                    if width >app_globals.mid_image_size or height >app_globals.mid_image_size:
                        if width > height:
                            outmid = im.resize((app_globals.mid_image_size,int(float(app_globals.mid_image_size) / imAspect)), Image.ANTIALIAS)
                        else:
                            outmid = im.resize((int(float(app_globals.mid_image_size) * imAspect),app_globals.mid_image_size), Image.ANTIALIAS)
                            
                    # image pequeño
                    if width >app_globals.small_image_size or height >app_globals.small_image_size:
                        if width > height:
                            outmini = im.resize((app_globals.small_image_size,int(float(app_globals.small_image_size) / imAspect)), Image.ANTIALIAS)
                        else:
                            outmini = im.resize((int(float(app_globals.small_image_size) * imAspect),app_globals.small_image_size), Image.ANTIALIAS)
                    
                    out.save(os.path.join(os.getcwd(),'tedx/public/files/', folder, filename.lstrip(os.sep)))
                    outmid.save(os.path.join(os.getcwd(),'tedx/public/files/', folder, filenamemid.lstrip(os.sep)))
                    outmini.save(os.path.join(os.getcwd(),'tedx/public/files/', folder, filenamemini.lstrip(os.sep)))
                    os.remove(os.path.join(os.getcwd(),'tedx/public/files/', folder, db_file.id.lstrip(os.sep)))
                
                meta.Session.add(db_file)
                meta.Session.commit()
                    
                return h.toJSON({'status': 'OK', 'comment_id': db_comment.id})
        return h.toJSON({'status': 'NOK', 'message': _(u'error_saving_file'), 'error_code': 0})

    def remove_comment(self):
        comment_id = self.prm('comment_id')
        
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
            

    # Create new instant from the map form
    def fast_new_instant(self):
        title = self.prm('new-instant-txtName')
        content = self.prm('new-instant-txtDescription')
        longitude = self.prm('new-instant-txtLongitude')
        latitude = self.prm('new-instant-txtLatitude')
        youtube_link = self.prm('new-instant-youtube')
        image_link = request.params.get('new-instant-image')
        city = self.prm('new-instant-city')
        country = self.prm('new-instant-country')

        if not c.user:
            return h.toJSON({'status': 'NOK', 'message': _(u'you_must_login_to_add_content'), 'error_code': 1})

        if city is None or country is None or city== "" or country == "":
            g = geocoders.Google(domain='maps.google.es')
            point = [latitude,longitude]
            (new_place,new_point) = g.reverse(point)
            address = new_place.split(',')
            city = address[-2].split(" ")[-1]
            country = address[-1]
        place = c.user.add_place(latitude, longitude, city,country,title)
        db_comment = place.add_comment(c.user, content, title)


        if (youtube_link != None and youtube_link != ''):
            db_youtube_file = db_comment.add_file('youtube', '')
            db_youtube_file.path = youtube_link
            meta.Session.add(db_youtube_file)
            meta.Session.commit()

        if (image_link != None and image_link != ""):
            name = image_link.name
            folder = c.user.id.lstrip(os.sep)
            if not os.path.isdir(os.path.join(os.getcwd(), 'tedx/public/files/', folder)):
                os.mkdir(os.path.join(os.getcwd(), 'tedx/public/files/', folder))
            
            db_file = db_comment.add_file('image', image_link.filename)
            full_path = os.path.join(os.getcwd(), 'tedx/public/files/', folder, db_file.id)
            db_file.path = os.path.join('/files', folder, db_file.id)
            db_file.size = len(image_link.value)
            permanent_file = open(full_path, 'w')
            
            shutil.copyfileobj(image_link.file, permanent_file)
            image_link.file.close()
            permanent_file.close()
            
            try:
                im = Image.open(os.path.join(os.getcwd(),'tedx/public/files/', folder, db_file.id.lstrip(os.sep)))
            except Exception, e:
                print e
                os.remove(os.path.join(os.getcwd(),'tedx/public/files/', folder, db_file.id.lstrip(os.sep)))
                meta.Session.delete(db_file)
                meta.Session.commit()
                return h.toJSON({'status': 'NOK', 'message': _(u'file_selected_is_not_an image'), 'error_code': 0})
            
            im = im.convert('RGB')
            width, height = im.size
            filename = db_file.id + '.jpg'
            filenamemid = db_file.id + '_mid.jpg'
            filenamemini = db_file.id + '_small.jpg'
            out = im
            outmid = im
            outmini = im
            imAspect = float(width)/float(height)
            
            # Default
            if width > app_globals.default_image_size or height > app_globals.default_image_size:
                if width > height:
                    out = im.resize((app_globals.default_image_size,int(float(app_globals.default_image_size) / imAspect)), Image.ANTIALIAS)
                else:
                    out = im.resize((int(float(app_globals.default_image_size) * imAspect),app_globals.default_image_size), Image.ANTIALIAS)
                    
            # Imagen de tamaño medio
            if width > app_globals.mid_image_size or height > app_globals.mid_image_size:
                if width > height:
                    outmid = im.resize((app_globals.mid_image_size,int(float(app_globals.mid_image_size) / imAspect)), Image.ANTIALIAS)
                else:
                    outmid = im.resize((int(float(app_globals.mid_image_size) * imAspect),app_globals.mid_image_size), Image.ANTIALIAS)
                            
            # Imagen de tamaño pequeño
            if width > app_globals.small_image_size or height > app_globals.small_image_size:
                if width > height:
                    outmini = im.resize((app_globals.small_image_size,int(float(app_globals.small_image_size) / imAspect)), Image.ANTIALIAS)
                else:
                    outmini = im.resize((int(float(app_globals.small_image_size) * imAspect),app_globals.small_image_size), Image.ANTIALIAS)
                    
            out.save(os.path.join(os.getcwd(),'tedx/public/files/', folder, filename.lstrip(os.sep)))
            outmid.save(os.path.join(os.getcwd(),'tedx/public/files/', folder, filenamemid.lstrip(os.sep)))
            outmini.save(os.path.join(os.getcwd(),'tedx/public/files/', folder, filenamemini.lstrip(os.sep)))
            os.remove(os.path.join(os.getcwd(),'tedx/public/files/', folder, db_file.id.lstrip(os.sep)))
                
            meta.Session.add(db_file)
            meta.Session.commit()

        return h.toJSON({'status': 'OK', 'message': _(u'Momento feliz guardado correctamente.'), 'comment_id': db_comment.id, 'place_id': place.id})
