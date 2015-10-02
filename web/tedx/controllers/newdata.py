# -*- coding: utf-8 -*-

from tedx.lib.base import *
from pylons.i18n import _

import logging
log = logging.getLogger(__name__)

class NewdataController(BaseController):

    def index(self):
        c.bicolor = 'gray'
        return render('/newdata.mako')

