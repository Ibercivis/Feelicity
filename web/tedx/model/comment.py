import sqlalchemy as sa
import datetime
from sqlalchemy.databases import mysql

from tedx.model import meta
from tedx.model.scoring import Comment_scoring
from tedx.model.file import File

from tedx.model.tag import Comment_tag

from tedx.lib.app_globals import generate_id
from sqlalchemy import and_

comment_table = sa.Table("Comments",meta.metadata, mysql_engine='MyISAM')
comment_table.append_column(sa.Column("id", mysql.MSString(16, collation="utf8_bin"), primary_key=True, default=generate_id))
comment_table.append_column(sa.Column("place_id", sa.ForeignKey('Places.id'), nullable=False))
comment_table.append_column(sa.Column("user_id", sa.ForeignKey('Users.id'), nullable=False))
comment_table.append_column(sa.Column("title", sa.types.String(256)))
comment_table.append_column(sa.Column("content", sa.types.Text))
comment_table.append_column(sa.Column("created_on", sa.types.DateTime))
comment_table.append_column(sa.Column("deleted_on", sa.types.DateTime))
comment_table.append_column(sa.Column("last_update", sa.types.DateTime))

class Comment(object):
    def __init__(self, place, user, content, title=None):
        self.id = generate_id(self)
        while meta.Session.query(Comment).filter_by(id = self.id).first() != None:
            self.id = generate_id(self)
        self.place = place
        self.user = user
        self.content = content
        self.title = title
        self.created_on = datetime.datetime.now()
        self.last_update = datetime.datetime.now()
        
        
        
    pass

    def add_scoring(self, user, value):
        existing_score = meta.Session.query(Comment_scoring).filter(and_(Comment_scoring.comment_id == self.id,Comment_scoring.user_id == user.id)).first()
        if not existing_score:
            db_scoring = Comment_scoring(self, user, value)
        
            return db_scoring
        else:
            return None 
        
    def add_file(self, type, name):
        file = File(self, type, name)
        
        meta.Session.add(self)
        meta.Session.commit()
        
        return file

        
    def add_tag(self, tag):
        db_tag = Comment_tag(self, tag)
        
        return db_tag
    
