import sqlalchemy as sa
import datetime, hashlib
from sqlalchemy.databases import mysql
from sqlalchemy import and_

from tedx.model import meta
from tedx.model.place import Place
from tedx.model.tag import User_tag


from tedx.lib.app_globals import generate_id

user_table = sa.Table("Users",meta.metadata, mysql_engine='MyISAM')
user_table.append_column(sa.Column("id", mysql.MSString(16, collation="utf8_bin"), primary_key=True, default=generate_id))
user_table.append_column(sa.Column("email", sa.types.String(256), nullable=False, unique=True))
user_table.append_column(sa.Column("password", sa.types.String(32), nullable=False))
user_table.append_column(sa.Column("nickname", sa.types.String(32)))
user_table.append_column(sa.Column("type", sa.types.String(16)))
user_table.append_column(sa.Column("avatar", sa.types.String(256)))
user_table.append_column(sa.Column("description", sa.types.String(512)))
user_table.append_column(sa.Column("sex", sa.types.Boolean))
user_table.append_column(sa.Column("created_on", sa.types.DateTime))
user_table.append_column(sa.Column("deleted_on", sa.types.DateTime))
user_table.append_column(sa.Column("last_activity", sa.types.DateTime))
user_table.append_column(sa.Column("latitude", sa.types.Numeric(8,6)))
user_table.append_column(sa.Column("longitude", sa.types.Numeric(8,6)))

followers_table = sa.Table('Followers', meta.metadata, mysql_engine='MyISAM')
followers_table.append_column(sa.Column("id", mysql.MSString(16, collation="utf8_bin"), primary_key=True, default=generate_id))
followers_table.append_column(sa.Column("follower", sa.ForeignKey('Users.id'), nullable=False))
followers_table.append_column(sa.Column("followed", sa.ForeignKey('Users.id'), nullable=False))

class User(object):
    def __init__(self, email, password, nickname, sex, type=None, latitude=None, longitude=None):
        self.id = generate_id(self)
        while meta.Session.query(User).filter_by(id = self.id).first() != None:
            self.id = generate_id(self)
        self.email = email
        self.password = hashlib.md5(password).hexdigest()
        self.nickname = nickname
        self.sex = sex
        self.type = type
        self.latitude = latitude
        self.longitude = longitude
        self.created_on = datetime.datetime.now()
        if self.sex:
            self.avatar = "/images/generate/avatar-masc"
        else:
            self.avatar = "/images/generate/avatar-fem"
            
        meta.Session.add(self)
        meta.Session.commit()
        
    def add_place(self, latitude, longitude, city, country, name=None):
        db_place = Place(self, latitude, longitude, city, country, name)
        self.places.append(db_place)
        
        meta.Session.add(self)
        meta.Session.commit()
        return db_place
        
    def add_tag(self, tag):
        db_tag = User_tag(self, tag)
        
        return db_tag
    
    def remove_tag(self,tag):
        db_tag = meta.Session.query(User_tag).filter(User_tag.tag_id == tag.id).first()
        if db_tag:
            meta.Session.delete(db_tag)
            meta.Session.commit()
    
    
    def follow(self, interesting_user):
        follower = Follower(self, interesting_user)
        meta.Session.commit()
        
        return follower

    def unfollow(self, not_so_interesting_user):
        follower = meta.Session.query(Follower).filter_by(follower = self.id, followed = not_so_interesting_user.id).first()
        
        if follower:
            meta.Session.delete(follower)
            meta.Session.commit()
    
        
class Follower(object):
    def __init__(self, follower, followed):
        self.followed_user = followed
        self.follower_user = follower
        
        meta.Session.add(self)
        meta.Session.commit()
