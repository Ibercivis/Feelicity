# -*- coding: utf-8 -*-

from tedx.lib.base import *
from pylons.i18n import _
import simplejson


import math
import simplejson
import logging
import os
import Image
log = logging.getLogger(__name__)

class SearchController(BaseController):

    def index(self):
        if self.prm('search_string'):
            c.search_string = self.prm('search_string').decode('utf8')
        else:
            c.search_string = ""
        c.range_query = self.prm('range_query')
        c.latitude = self.prm('latitude')
        c.longitude = self.prm('longitude')
        return render('/search.mako')