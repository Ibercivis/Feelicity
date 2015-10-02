#! /usr/bin/env python

# -*- coding: utf-8 -*-

import sqlalchemy as sa
from sqlalchemy.ext.serializer import loads, dumps
import os
import re

from tedx import model
from tedx.model import meta, user, place, comment, file, tag, scoring, notification, category

engine = sa.create_engine("mysql://username:password@localhost:port/tedx?charset=utf8")
model.init_model(engine)
# ... define mappers

# pickle the query
comments = meta.Session.query(comment.Comment).all()

for comment in comments:
    comment_list = re.findall("\[YOUTUBE\][^\[]*\[\/YOUTUBE\]",comment.content)
    if comment_list:
        for link in comment_list:
            link = link.replace('[YOUTUBE]','')
            link = link.replace('[/YOUTUBE]','')
            db_file = comment.add_file('youtube', "")
            db_file.path = link
        comment.content = re.sub("\[YOUTUBE\][^\[]*\[\/YOUTUBE\]","",comment.content)

        
meta.Session.commit()
                    