import sqlalchemy as sa
import datetime
import string
from random import choice, uniform
from sqlalchemy.databases import mysql

from tedx.model import meta
from tedx.model.comment import Comment
from tedx.model.tag import Place_tag
from tedx.model.scoring import Place_scoring

from tedx.lib.app_globals import generate_id
from sqlalchemy import and_

place_table = sa.Table("Places",meta.metadata, mysql_engine='MyISAM')
place_table.append_column(sa.Column("id", mysql.MSString(16, collation="utf8_bin"), primary_key=True, default=generate_id))
place_table.append_column(sa.Column("user_id", sa.ForeignKey('Users.id'), nullable=False))
place_table.append_column(sa.Column("longitude", sa.types.Numeric(9,6)))
place_table.append_column(sa.Column("latitude", sa.types.Numeric(8,6)))
place_table.append_column(sa.Column("name", sa.types.String(64)))
place_table.append_column(sa.Column("visits", sa.types.Integer))
place_table.append_column(sa.Column("empty", sa.types.Boolean, default=False))
place_table.append_column(sa.Column("created_on", sa.types.DateTime))
place_table.append_column(sa.Column("deleted_on", sa.types.DateTime))
place_table.append_column(sa.Column("city", sa.types.String(128)))
place_table.append_column(sa.Column("country", sa.types.String(128)))
place_table.append_column(sa.Column("last_update", sa.types.DateTime))
place_table.append_column(sa.Column("ph", sa.types.Numeric(2,1)))
place_table.append_column(sa.Column("chlorine", sa.types.Numeric(3,1)))

class Place(object):
    def __init__(self, user, latitude, longitude, city, country, name=None):
        self.id = generate_id(self)
        while meta.Session.query(Place).filter_by(id = self.id).first() != None:
            self.id = generate_id(self)
        self.user = user
        self.latitude = round(float(latitude),6)
        self.longitude = round(float(longitude),6)
        self.name = name
        self.visits = 0
        self.city = city
        if country:
            if len(country.split(" ")) > 1:
                self.country = country.split(" ")[1]
            else:
                self.country = country
        self.created_on = datetime.datetime.now()
        self.last_update = datetime.datetime.now()

    def generate_password(self, max=16, chars=string.letters + string.digits):
        new_string = ''
        for i in range(max):
            new_string = new_string + choice(chars)
        return new_string

    def add_comment(self, user, content, title=None):
        db_comment = Comment(self, user, content, title)
        self.last_update = datetime.datetime.now()
        self.comments.append(db_comment)
        user.comments.append(db_comment)
        meta.Session.add(self)
        meta.Session.commit()
        return db_comment

    def add_scoring(self, user, value):
        existing_score = meta.Session.query(Place_scoring).filter(and_(Place_scoring.place_id == self.id,Place_scoring.user_id == user.id)).first()
        if not existing_score:
            db_scoring = Place_scoring(self, user, value)
            return db_scoring
        else:
            return None

    def add_tag(self, tag):
        db_tag = Place_tag(self, tag)
        return db_tag

    def add_visit(self):
        self.visits += 1
        meta.Session.commit()

    def add_water(self, ph, chlorine):
        self.ph = ph
        self.chlorine = chlorine
        meta.Session.commit()
