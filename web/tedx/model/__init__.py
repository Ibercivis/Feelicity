"""The application's model objects"""
from tedx.model.meta import Session, metadata

from sqlalchemy import orm, and_, desc
from tedx.model import user, place, comment, file, tag, scoring

def init_model(engine):
    """Call me before using any of the tables or classes in the model"""
    Session.configure(bind=engine)
    
    orm.mapper(user.User, user.user_table, properties = {
        "comments": orm.relation(comment.Comment, primaryjoin=user.user_table.c.id==comment.comment_table.c.user_id,  cascade="all, delete, delete-orphan"),
        "places": orm.relation(place.Place, primaryjoin=user.user_table.c.id==place.place_table.c.user_id,  cascade="all, delete, delete-orphan"),
        "tags": orm.relation(tag.Tag, secondary=tag.user_tag_table),
        "tag_relations": orm.relation(tag.User_tag, primaryjoin=user.user_table.c.id==tag.user_tag_table.c.user_id),
        "files": orm.relation(file.File),
        "followers": orm.relation(user.User, secondary=user.followers_table, primaryjoin=user.user_table.c.id==user.followers_table.c.followed, secondaryjoin=user.followers_table.c.follower==user.user_table.c.id, backref='following'),
    })
    
    orm.mapper(comment.Comment, comment.comment_table, properties = {
        "user": orm.relation(user.User),
        "place": orm.relation(place.Place, order_by=desc(place.place_table.c.created_on)),
        "positive_scorings": orm.relation(user.User, secondary=scoring.comment_scoring_table, primaryjoin=and_(comment.comment_table.c.id==scoring.comment_scoring_table.c.comment_id, scoring.comment_scoring_table.c.value==1)),
        "negative_scorings": orm.relation(user.User, secondary=scoring.comment_scoring_table, primaryjoin=and_(comment.comment_table.c.id==scoring.comment_scoring_table.c.comment_id, scoring.comment_scoring_table.c.value==-1)),
        "tags": orm.relation(tag.Tag, secondary=tag.comment_tag_table),
        "tag_relations": orm.relation(tag.Comment_tag, primaryjoin=comment.comment_table.c.id==tag.comment_tag_table.c.comment_id),
        "files": orm.relation(file.File)
    })
    
    orm.mapper(place.Place, place.place_table, properties = {
        "user": orm.relation(user.User),
        "comments": orm.relation(comment.Comment, primaryjoin=place.place_table.c.id==comment.comment_table.c.place_id,  cascade="all, delete, delete-orphan"),
        "positive_scorings": orm.relation(user.User, secondary=scoring.place_scoring_table, primaryjoin=and_(place.place_table.c.id==scoring.place_scoring_table.c.place_id, scoring.place_scoring_table.c.value==1)),
        "negative_scorings": orm.relation(user.User, secondary=scoring.place_scoring_table, primaryjoin=and_(place.place_table.c.id==scoring.place_scoring_table.c.place_id, scoring.place_scoring_table.c.value==-1)),
        "tags": orm.relation(tag.Tag, secondary=tag.place_tag_table),
        "tag_relations": orm.relation(tag.Place_tag, primaryjoin=place.place_table.c.id==tag.place_tag_table.c.place_id),
    })
    
    orm.mapper(tag.Tag, tag.tag_table, properties = {
        "users": orm.relation(user.User, secondary=tag.user_tag_table),
        "places": orm.relation(place.Place, secondary=tag.place_tag_table),
        "comments": orm.relation(comment.Comment, secondary=tag.comment_tag_table)
    })
    
    orm.mapper(tag.User_tag, tag.user_tag_table, properties = {
        "user": orm.relation(user.User),
        "tag": orm.relation(tag.Tag)
    })
    
    orm.mapper(tag.Place_tag, tag.place_tag_table, properties = {
        "place": orm.relation(place.Place),
        "tag": orm.relation(tag.Tag)
    })
    
    orm.mapper(tag.Comment_tag, tag.comment_tag_table, properties = {
        "comment": orm.relation(comment.Comment),
        "tag": orm.relation(tag.Tag)
    })
        
    orm.mapper(scoring.Place_scoring, scoring.place_scoring_table, properties = {
        "place": orm.relation(place.Place),
        "user": orm.relation(user.User)
    })
    
    orm.mapper(scoring.Comment_scoring, scoring.comment_scoring_table, properties = {
        "comment": orm.relation(comment.Comment),
        "user": orm.relation(user.User)
    })
    
    orm.mapper(file.File, file.file_table, properties = {
        "comment": orm.relation(comment.Comment),
        "user": orm.relation(user.User)
    })
      
    orm.mapper(user.Follower, user.followers_table, properties = {
       "follower_user": orm.relation(user.User, primaryjoin=user.followers_table.c.follower==user.user_table.c.id),
       "followed_user": orm.relation(user.User, primaryjoin=user.followers_table.c.followed==user.user_table.c.id)
    })