# -*- coding: utf-8 -*-
"""The application's Globals object"""

from beaker.cache import CacheManager
from beaker.util import parse_cache_config_options

import string
from random import choice

def generate_id(self, max=16, chars=string.letters + string.digits):
    new_string = ''
    for i in range(max):
        new_string = new_string + choice(chars)
    return new_string

class Globals(object):

    """Globals acts as a container for objects available throughout the
    life of the application

    """
    
    languages = { 'es': u'Español', 'en': u'English' }
    default_image_size = 640
    mid_image_size = 190
    small_image_size = 64
    
    def __init__(self, config):
        """One instance of Globals is created during application
        initialization and is available during requests via the
        'app_globals' variable

        """
        self.cache = CacheManager(**parse_cache_config_options(config))
