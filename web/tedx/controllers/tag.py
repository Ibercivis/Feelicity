# -*- coding: utf-8 -*-
import os
from tedx.lib.base import *
from pylons.i18n import _

import logging
log = logging.getLogger(__name__)

class TagController(BaseController):

    def index(self):
        return redirect(url(controller=''))

    def search(self):
        q = request.params.get('q')

        if q is None or q == '':
            return simplejson.dumps({'status': 'NOK', 'message': _(u'empty_search'), 'error_code': 0})

        tags_query = meta.Session.query(Tag).filter(Tag.name.like('%' + q + '%'))
        tags = []
        for tag in tags_query:
            tags.append({"id": tag.id, "name": tag.name})

        return simplejson.dumps({"status": "OK", "results": results})

    def all(self):
        tags_query = meta.Session.query(Tag)
        tags = []
        for tag in tags_query:
            tags.append({"id": tag.id, "name": tag.name})

        return simplejson.dumps({"status": "OK", "tags": tags})
