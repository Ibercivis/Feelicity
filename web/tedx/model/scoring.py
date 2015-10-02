import sqlalchemy as sa
import datetime
from sqlalchemy.databases import mysql

from tedx.model import meta

from tedx.lib.app_globals import generate_id

place_scoring_table = sa.Table("Place_scorings",meta.metadata, mysql_engine='MyISAM')
place_scoring_table.append_column(sa.Column("id", mysql.MSString(16, collation="utf8_bin"), primary_key=True, default=generate_id))
place_scoring_table.append_column(sa.Column("place_id", sa.ForeignKey('Places.id'), nullable=False))
place_scoring_table.append_column(sa.Column("user_id", sa.ForeignKey('Users.id'), nullable=False))
place_scoring_table.append_column(sa.Column("value", sa.types.Integer))
place_scoring_table.append_column(sa.Column("created_on", sa.types.DateTime))

comment_scoring_table = sa.Table("Comment_scorings",meta.metadata, mysql_engine='MyISAM')
comment_scoring_table.append_column(sa.Column("id", mysql.MSString(16, collation="utf8_bin"), primary_key=True, default=generate_id))
comment_scoring_table.append_column(sa.Column("comment_id", sa.ForeignKey('Comments.id'), nullable=False))
comment_scoring_table.append_column(sa.Column("user_id", sa.ForeignKey('Users.id'), nullable=False))
comment_scoring_table.append_column(sa.Column("value", sa.types.Integer))
comment_scoring_table.append_column(sa.Column("created_on", sa.types.DateTime))

class Place_scoring(object):
    def __init__(self, place, user, value):
        self.id = generate_id(self)
        while meta.Session.query(Place_scoring).filter_by(id = self.id).first() != None:
            self.id = generate_id(self)
        self.place = place
        self.user = user
        self.value = value
        self.created_on = datetime.datetime.now()
        
        meta.Session.add(self)
        meta.Session.commit()
        
class Comment_scoring(object):
    def __init__(self, comment, user, value):
        self.id = generate_id(self)
        while meta.Session.query(Comment_scoring).filter_by(id = self.id).first() != None:
            self.id = generate_id(self)
        self.comment = comment
        self.user = user
        self.value = value
        self.created_on = datetime.datetime.now()
        
        meta.Session.add(self)
        meta.Session.commit()
        
    
