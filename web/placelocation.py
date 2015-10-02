#! /usr/bin/env python

# -*- coding: utf-8 -*-

import sqlalchemy as sa
from sqlalchemy.ext.serializer import loads, dumps
import os

from tedx import model
from tedx.model import meta, user, place, comment, file, tag, scoring, notification, category
from geopy import geocoders
engine = sa.create_engine("mysql://username:password@localhost:port/tedx?charset=utf8")
model.init_model(engine)
# ... define mappers

# pickle the query
places = meta.Session.query(place.Place).all()

for place in places:
    if place.city is None or place.city == "":
        g = geocoders.Google(domain='maps.google.es')
        point = [place.latitude,place.longitude]
        (new_place,new_point) = g.reverse(point)
        address = new_place.split(',')
        city = address[-2].split(" ")[-1]
        country = address[-1]
        place.city = city
        place.country = country
        meta.Session.add(place)
        meta.Session.commit()

