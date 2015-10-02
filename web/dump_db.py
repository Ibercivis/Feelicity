#! /usr/bin/env python

# -*- coding: utf-8 -*-

import sqlalchemy as sa
from sqlalchemy.ext.serializer import loads, dumps
import os

from tedx import model
from tedx.model import meta, user, place, comment, file, tag, scoring, notification, category

engine = sa.create_engine("mysql://username:password@localhost:port/tedx?charset=utf8")
model.init_model(engine)
# ... define mappers

# pickle the query
results = meta.Session.query(user.User).all()
results.extend(meta.Session.query(user.Follower).all())
results.extend(meta.Session.query(tag.Tag).all())
results.extend(meta.Session.query(tag.User_tag).all())
results.extend(meta.Session.query(place.Place).all())
results.extend(meta.Session.query(tag.Place_tag).all())
results.extend(meta.Session.query(comment.Comment).all())
results.extend(meta.Session.query(file.File).all())
results.extend(meta.Session.query(notification.Notification).all())
results.extend(meta.Session.query(scoring.Place_scoring).all())
results.extend(meta.Session.query(scoring.Comment_scoring).all())
results.extend(meta.Session.query(tag.Comment_tag).all())
results.extend(meta.Session.query(category.Category).all())
results.extend(meta.Session.query(category.User_category).all())
results.extend(meta.Session.query(category.Place_category).all())

dumped_data = dumps(results)

dumped_file = open(os.path.join(os.getcwd(), "dumps"), 'w')
dumped_file.write(dumped_data)
dumped_file.close()