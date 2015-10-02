# -*- coding: utf-8 -*-

from tedx.lib.base import *
from pylons.i18n import _
import simplejson


import math
import simplejson
import logging
import os
import Image
import time

log = logging.getLogger(__name__)

from sqlalchemy import orm, and_, desc, select, func

class HomeController(BaseController):

    def index(self):
        function = 'def index'
        log.debug(function)
        log.debug('%s - city:%s, country:%s' % (function, self.prm('city'), self.prm('country')))
        if self.prm('city') and self.prm('country'):
            c.city = self.prm('city').decode('utf8')
            c.country = self.prm('country').decode('utf8')
        return render('/home.mako')

    def _order_elements_by_date(self, element1, element2):
        function = 'def _order_elements_by_date'
        log.debug('%s - city:%s, country:%s' % (function, self.prm('city'), self.prm('country')))
        if element1.last_update < element2.last_update:
            return 1
        elif element1.last_update == element2.last_update:
            return 0
        else:
            return -1

    def _order_elements_by_scorings(self, element1, element2):
        function = 'def _order_elements_by_scorings'
        log.debug(function)
        if (element1.positive_scorings - element1.negative_scorings) < (element2.positive_scorings - element2.negative_scorings):
            return 1
        elif (element1.positive_scorings - element1.negative_scorings) == (element2.positive_scorings - element2.negative_scorings):
            return 0
        else:
            return -1

    def _order_elements_by_visits(self, element1, element2):
        function = 'def _order_elements_by_visits'
        log.debug(function)
        if element1.visits < element2.visits:
            return 1
        elif element1.visits == element2.visits:
            return 0
        else:
            return -1

    def _order_elements_by_comments(self, element1, element2):
        function = 'def _order_elements_by_comments'
        log.debug(function)
        if len(element1.comments) < len(element2.comments):
            return 1
        elif len(element1.comments) == len(element2.comments):
            return 0
        else:
            return -1

    def _order_elements_by_contents(self, element1, element2):
        function = 'def _order_elements_by_contents'
        log.debug(function)
        if element1['user_contents'] < element2['user_contents']:
            return 1
        elif element1['user_contents'] == element2['user_contents']:
            return 0
        else:
            return -1


    def search(self):
        function = 'def search'
        log.debug(function)

        #date = datetime.datetime.now()
        mode = 'map'
        if self.prm('mode'):
            mode = self.prm('mode')

        search_type = 'places'
        if self.prm('search_type'):
            search_type = self.prm('search_type')

        result_type = 'places'
        if self.prm('result_type'):
            result_type = self.prm('result_type')

        page_size = 20
        if self.prm('page_size'):
            page_size = int(self.prm('page_size'))

        page = 1
        if self.prm('page'):
            page = int(self.prm('page'))


        profile_id = self.prm('profile_id')

        index = 0 + (page - 1) * page_size

        #=======================================================================
        # Cogemos los resultados
        #=======================================================================

        a = select([Place.user_id, func.count(Place.user_id)], group_by=[Place.user_id], order_by = [desc(func.count(Place.user_id))])
        a = a.alias('query')
        results = meta.Session.query(a).limit(10)
        users = []
        for result in results:
            user = meta.Session.query(User).filter_by(id=result.user_id).one()
            users.append({
                "user_name": user.nickname,
                "user_id": user.id,
                "user_avatar":user.avatar,
                "user_description":user.description,
                "user_contents":len(user.places)})
        total_users = meta.Session.query(User).count()
        total_places = meta.Session.query(Place).count()
        db_results = []
        num_results = 0

        log.debug('%s - mode:%s' %(function, mode))

        if mode == 'map':
            ''' Main query for the map '''
            max_latitude = self.prm('max_latitude')
            min_latitude = self.prm('min_latitude')
            max_longitude = self.prm('max_longitude')
            min_longitude = self.prm('min_longitude')

            db_results = meta.Session.query(Place).filter(
                    and_(
                        Place.empty==False,
                        Place.latitude.between(min_latitude, max_latitude),
                        Place.longitude.between(min_longitude, max_longitude))
                    ).order_by(desc(Place.last_update)).limit(page_size).offset(index)

            num_results = meta.Session.query(Place).filter(
                    and_(
                        Place.empty==False,
                        Place.latitude.between(min_latitude, max_latitude),
                        Place.longitude.between(min_longitude, max_longitude))).count()

            log.debug('%s mode:%s' % (function, mode))
            log.debug('%s db:%s' % (function, db_results))
            log.debug('%s db:%s' % (function, num_results))


        '''

        if mode == 'search':
            string = max(self.prm('search_string').split(), key=len)
            latitude = self.prm('latitude')
            longitude = self.prm('longitude')

            if self.prm('range_query') == 'true' and latitude != "" and longitude != "":
                db_results = meta.Session.query(Place).filter(or_(and_(Place.empty==False,Place.name.like("%" + string + "%"),
                    Place.latitude.between(float(latitude) - 0.002, float(latitude) + 0.002),
                    Place.longitude.between(float(longitude)-0.005, float(longitude)+0.005)),
                    Place.tags.any(Tag.name.like("%" + string + "%")),
                    Place.user.has(User.nickname.like("%" + string + "%")))).
                    order_by(desc(Place.last_update)).
                    limit(page_size).offset(index)
                num_results = meta.Session.query(Place).filter(or_(and_(Place.empty==False,Place.name.like("%" + string + "%"),
                    Place.latitude.between(float(latitude) - 0.002, float(latitude) + 0.002),
                    Place.longitude.between(float(longitude)-0.005, float(longitude)+0.005)),
                    Place.tags.any(Tag.name.like("%" + string + "%")), Place.user.has(User.nickname.like("%" + string + "%")))).count()
            else:
                db_results = meta.Session.query(Place).filter(or_(and_(Place.empty==False,Place.name.like("%" + string + "%")),
                    Place.tags.any(Tag.name.like("%" + string + "%")),
                    Place.user.has(User.nickname.like("%" + string + "%")))).
                    order_by(desc(Place.last_update)).
                    limit(page_size).offset(index)
                num_results = meta.Session.query(Place).filter(or_(and_(Place.empty==False,
                    Place.name.like("%" + string + "%")),
                    Place.tags.any(Tag.name.like("%" + string + "%")),
                    Place.user.has(User.nickname.like("%" + string + "%")))).count()

        elif mode == 'map':
            max_latitude = self.prm('max_latitude')
            min_latitude = self.prm('min_latitude')
            max_longitude = self.prm('max_longitude')
            min_longitude = self.prm('min_longitude')

            db_results = meta.Session.query(Place).filter(and_(Place.empty==False,
                Place.latitude.between(min_latitude, max_latitude),
                Place.longitude.between(min_longitude, max_longitude))).
                order_by(desc(Place.last_update)).
                limit(page_size).offset(index)

            num_results = meta.Session.query(Place).filter(and_(Place.empty==False,
                Place.latitude.between(min_latitude, max_latitude),
                Place.longitude.between(min_longitude, max_longitude))).count()
        elif mode == 'profile':
            db_user = meta.Session.query(User).filter(User.id == profile_id).first()
            if db_user:
                if search_type == 'places':
                    db_results = meta.Session.query(Place).filter(Place.user.has(User.id == profile_id)).
                    order_by(desc(Place.last_update)).
                    limit(page_size).offset(index)
                    num_results = meta.Session.query(Place).filter(Place.user.has(User.id == profile_id)).count()
                string = self.prm('search_string')
                if string:
                    db_results = []
                    db_results = meta.Session.query(Place).filter(or_(and_(Place.empty==False,
                        Place.name.like("%" + string + "%")),
                        and_(Place.user.has(User.id == profile_id),Place.tags.any(Tag.name.like("%" + string + "%"))))).
                        order_by(desc(Place.last_update)).limit(page_size)
                    num_results = meta.Session.query(Place).filter(or_(and_(Place.empty==False,
                        Place.name.like("%" + string + "%")),
                        and_(Place.user.has(User.id == profile_id),
                        Place.tags.any(Tag.name.like("%" + string + "%"))))).count()

            else:
                h.toJSON({'status': 'NOK', 'message': _(u"user_not_found"), 'error_code': 0})

        '''
        results = []
        #log.debug('%s - antes de loop' % (function))
        for db_result in db_results:
            log.debug('%s - db_result:%s' % (function, db_result))
            if len(db_result.comments)>0:
                last_updater_name =  db_result.comments[-1].user.nickname
            else:
                last_updater_name = ""

            comment_id = db_result.comments[0].id

            if  db_result.user.deleted_on:
                user_name = _(u"anonymous")
                avatar = "/images/generate/logoForCodeQR_v1"
            else:
                user_name = db_result.user.nickname
                avatar = db_result.user.avatar

            comment_image = None
            for comment_file in db_result.comments[0].files:
                if comment_file.type == "image":
                    comment_image = comment_file.path

            result = {
                    "place_id": db_result.id,
                    "place_name": db_result.name,
                    "comment_id":comment_id,
                    "user_name": user_name,
                    "last_updater_name": last_updater_name,
                    "user_id": db_result.user.id,
                    "avatar": avatar,
                    "latitude": db_result.latitude,
                    "longitude": db_result.longitude,
                    "num_comments": len(db_result.comments)-1,
                    "created_on": db_result.created_on.strftime('%d/%m/%Y %H:%M:%S'),
                    "comment_content": db_result.comments[0].content,
                    "positive_scorings": len(db_result.positive_scorings),
                    "comment_image" : comment_image,
                    "visits": db_result.visits,
                    "ph": db_result.ph,
                    "chlorine": db_result.chlorine,
                    "last_update": db_result.last_update.strftime('%d/%m/%Y %H:%M:%S')}
            if result not in results:
                #log.debug('%s - result:%s' % (function, result))
                results.append(result)
            index += 1
        user_id = ""
        if c.user:
            user_id = c.user.id

        return h.toJSON({
            'status': 'OK',
            'pages': int(math.ceil(float(num_results) / float(page_size))),
            "users":users,
            "total_users":total_users,
            "total_places": total_places,
            'current_page': page,
            'results': results,
            'user_id': user_id,
            'num_results':num_results})


