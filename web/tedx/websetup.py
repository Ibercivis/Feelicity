"""Setup the tedx application"""
import logging

import os, shutil
import random

import pylons.test

from tedx.config.environment import load_environment
from tedx.model.meta import Session, metadata

log = logging.getLogger(__name__)

def setup_app(command, conf, vars):

    from tedx.model import user
    from tedx.model import place
    from tedx.model import comment

    """Place any commands to setup tedx here"""
    # Don't reload the app if it was loaded under the testing environment
    if not pylons.test.pylonsapp:
        load_environment(conf.global_conf, conf.local_conf)

    # Create the tables if they don't already exist
    log.info("Creating tables...")
    metadata.drop_all(bind=Session.bind, checkfirst=True)
    metadata.create_all(bind=Session.bind)
    log.info("Successfully created")

    #===========================================================================
    # log.info("Creating directory tree...")
    # if os.path.isdir(os.path.join(os.getcwd(), 'tedx/public/files')):
    #    shutil.rmtree(os.path.join(os.getcwd(), 'tedx/public/files'))
    # os.mkdir(os.path.join(os.getcwd(), 'tedx/public/files'))
    # if os.path.isdir(os.path.join(os.getcwd(), 'tedx/public/bidis')):
    #    shutil.rmtree(os.path.join(os.getcwd(), 'tedx/public/bidis'))
    # os.mkdir(os.path.join(os.getcwd(), 'tedx/public/bidis'))
    # if os.path.isdir(os.path.join(os.getcwd(), 'tedx/public/avatars')):
    #    shutil.rmtree(os.path.join(os.getcwd(), 'tedx/public/avatars'))
    # os.mkdir(os.path.join(os.getcwd(), 'tedx/public/avatars'))
    # log.info("Successfully created")
    #===========================================================================

    #user.User("admin@tedx.com", "admin", "password", "admin")

    #psoe_user = user.User("infoambar@ambar.es", "ambar", "ambar")
    #psoe_category = category.Category(psoe_user.nickname)
    #psoe_user.add_category(psoe_category,"admin")

    #===========================================================================
    # # Users
    # users = []
    # for i in range(100):
    #    email = "user" + str(i) + "@mail.com"
    #    name = "user" + str(i)
    #    password = "user" + str(i)
    #    nickname = "user" + str(i)
    #    latitude = 41.60 + random.random() * 0.3
    #    longitude = -0.70 - random.random() * 0.25
    #    db_user = user.User(email, password, nickname, latitude, longitude)
    #    users.append(db_user)
    #
    # # Places
    # for j in range(100):
    #    place_name = "place" + str(i) + str(j)
    #    latitude = 41.60 + random.random() * 0.3
    #    longitude = -0.70 - random.random() * 0.25
    #    db_place = db_user.add_place(latitude, longitude, place_name)
    #    db_user = random.choice(users)
    #    db_comment = db_place.add_comment(db_user, latitude, longitude, place_name, place_name)
    #    for k in range(100):
    #        comment_title = "comment" + str(j) + str(k)
    #        db_user = random.choice(users)
    #        db_comment = db_place.add_comment(db_user, latitude, longitude, comment_title, comment_title)
    #===========================================================================


