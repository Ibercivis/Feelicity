from tedx.lib.base import *
from pylons.i18n import _

import logging
log = logging.getLogger(__name__)

class AboutController(BaseController):

    def index(self):
        type = self.prm('type')
        if type == 'legal_warning':
            return render('/legalwarning.mako')
        elif type == 'contact':
            return render('/contact.mako')
        elif type == 'privacy_policy':
            return render('/privacy.mako')
        elif type == 'downloads':
            return render('/downloads.mako')
        elif type == 'help':
            return render('/help.mako')