#! /usr/bin/env python

# -*- coding: utf-8 -*-

import sqlalchemy as sa
from sqlalchemy.ext.serializer import loads, dumps
import os

from tedx import model
from tedx.model import meta, user, place, comment, file, tag, scoring, notification, category

engine = sa.create_engine("mysql://username:password@localhost:port/tedx?charset=utf8")
model.init_model(engine)

dumped_file = open(os.path.join(os.getcwd(), "dumps"), 'r')
dumped_data = dumped_file.read()
dumped_file.close()

query = loads(dumped_data, meta.metadata, meta.Session)

for object in query:
    meta.Session.merge(object)
    
meta.Session.commit()