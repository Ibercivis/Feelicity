import sqlalchemy as sa
import datetime
from sqlalchemy.databases import mysql

from tedx.model import meta

from tedx.lib.app_globals import generate_id

tag_table = sa.Table("Tags",meta.metadata, mysql_engine='MyISAM')
tag_table.append_column(sa.Column("id", mysql.MSString(16, collation="utf8_bin"), primary_key=True, default=generate_id))
tag_table.append_column(sa.Column("name", sa.types.String(64), unique=True))
tag_table.append_column(sa.Column("created_on", sa.types.DateTime))

user_tag_table = sa.Table("User_tags",meta.metadata, mysql_engine='MyISAM')
user_tag_table.append_column(sa.Column("id", mysql.MSString(16, collation="utf8_bin"), primary_key=True, default=generate_id))
user_tag_table.append_column(sa.Column("user_id", sa.ForeignKey('Users.id'), nullable=False))
user_tag_table.append_column(sa.Column("tag_id", sa.ForeignKey('Tags.id'), nullable=False))
user_tag_table.append_column(sa.Column("created_on", sa.types.DateTime))

place_tag_table = sa.Table("Place_tags",meta.metadata, mysql_engine='MyISAM')
place_tag_table.append_column(sa.Column("id", mysql.MSString(16, collation="utf8_bin"), primary_key=True, default=generate_id))
place_tag_table.append_column(sa.Column("place_id", sa.ForeignKey('Places.id'), nullable=False))
place_tag_table.append_column(sa.Column("tag_id", sa.ForeignKey('Tags.id'), nullable=False))
place_tag_table.append_column(sa.Column("created_on", sa.types.DateTime))

comment_tag_table = sa.Table("Comment_tags",meta.metadata, mysql_engine='MyISAM')
comment_tag_table.append_column(sa.Column("id", mysql.MSString(16, collation="utf8_bin"), primary_key=True, default=generate_id))
comment_tag_table.append_column(sa.Column("comment_id", sa.ForeignKey('Comments.id'), nullable=False))
comment_tag_table.append_column(sa.Column("tag_id", sa.ForeignKey('Tags.id'), nullable=False))
comment_tag_table.append_column(sa.Column("created_on", sa.types.DateTime))

class Tag(object):
    def __init__(self, name):
        self.id = generate_id(self)
        while meta.Session.query(Tag).filter_by(id = self.id).first() != None:
            self.id = generate_id(self)
        self.name = name
        self.created_on = datetime.datetime.now()
        
        meta.Session.add(self)
        meta.Session.commit()
        
class User_tag(object):
    def __init__(self, user, tag):
        self.id = generate_id(self)
        while meta.Session.query(User_tag).filter_by(id = self.id).first() != None:
            self.id = generate_id(self)
        self.user = user
        self.tag = tag
        self.created_on = datetime.datetime.now()
        
        meta.Session.add(self)
        meta.Session.commit()
        
class Place_tag(object):
    def __init__(self, place, tag):
        self.id = generate_id(self)
        while meta.Session.query(Place_tag).filter_by(id = self.id).first() != None:
            self.id = generate_id(self)
        self.place = place
        self.tag = tag
        self.created_on = datetime.datetime.now()
        
        meta.Session.add(self)
        meta.Session.commit()
        
class Comment_tag(object):
    def __init__(self, comment, tag):
        self.id = generate_id(self)
        while meta.Session.query(Comment_tag).filter_by(id = self.id).first() != None:
            self.id = generate_id(self)
        self.comment = comment
        self.tag = tag
        self.created_on = datetime.datetime.now()
        
        meta.Session.add(self)
        meta.Session.commit()
