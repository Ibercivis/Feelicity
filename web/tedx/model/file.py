import sqlalchemy as sa
import datetime, hashlib
from sqlalchemy.databases import mysql

from tedx.model import meta
from tedx.model.tag import User_tag

from tedx.lib.app_globals import generate_id


file_table = sa.Table("Files",meta.metadata, mysql_engine='MyISAM')
file_table.append_column(sa.Column("id", mysql.MSString(16, collation="utf8_bin"), primary_key=True, default=generate_id))
file_table.append_column(sa.Column("user_id", sa.ForeignKey('Users.id'), nullable=False))
file_table.append_column(sa.Column("comment_id", sa.ForeignKey('Comments.id'), nullable=False))
file_table.append_column(sa.Column("type", sa.types.String(16)))
file_table.append_column(sa.Column("name", sa.types.String(32)))
file_table.append_column(sa.Column("path", sa.types.String(256)))
file_table.append_column(sa.Column("size", sa.types.Integer))
file_table.append_column(sa.Column("created_on", sa.types.DateTime))


class File(object):
    def __init__(self, comment, type, name):
        self.id = generate_id(self)
        while meta.Session.query(File).filter_by(id = self.id).first() != None:
            self.id = generate_id(self)
        self.comment = comment
        self.user = comment.user
        self.type = type
        self.name = name
        self.created_on = datetime.datetime.now()
        
        meta.Session.add(self)
        meta.Session.commit()
