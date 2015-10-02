# -*- coding: utf-8 -*-
import shutil
import Image

from tedx.lib.base import *
from pylons.i18n import _

import logging
log = logging.getLogger(__name__)

from sqlalchemy import func

class MyAccountController(BaseController):

    def index(self):
        c.bicolor = "gray"
        return render('/my_account.mako')
    
    def save(self):
        email = self.prm('email')
        old_password = self.prm('old_password')
        new_password = self.prm('password')
        nickname = self.prm('nickname')
        latitude = self.prm('latitude')
        longitude = self.prm('longitude')
        description = self.prm('description')
        user_tags = self.prm('user_tags')
        
        if c.user:    
            db_user = meta.Session.query(User).filter_by(id = c.user.id).first()
            if old_password:
                if c.user.password == hashlib.md5(old_password).hexdigest():
                    c.user.password = hashlib.md5(new_password).hexdigest()
                else:
                    return h.toJSON({"status": "NOK", "message": _(u"couldnt_save_profile"), 'error_code': 0})    
            
            c.user.description = description
            c.user.latitude = latitude
            c.user.longitude = longitude
            c.user.nickname = nickname
            
            for tag in c.user.tags:
                c.user.remove_tag(tag)
            if user_tags:
                tags = user_tags.split(' ')
                for tag in tags:
                    db_tag = meta.Session.query(Tag).filter(Tag.name == tag).first()
                    if db_tag is None:
                        Tag(tag)
                        db_tag = meta.Session.query(Tag).filter(Tag.name == tag).first()
                    c.user.add_tag(db_tag)
            
            
            session['user_id'] = c.user.id
            session.save()
            
            meta.Session.add(c.user)
            meta.Session.commit()
            
            return h.toJSON({"status": "OK", "message": _(u"data_successfully_saved")})
        else:
            return h.toJSON({"status": "NOK", "message": _(u"couldnt_save_profile"), 'error_code': 1})
    
    
    def get_details(self):
        if c.user:
            return h.toJSON({"status": "OK", "user_id": c.user.id, "user_nickname": c.user.nickname, "user_description":c.user.description, "user_mail": c.user.email, 'avatar':c.user.avatar, 'latitude': c.user.latitude, 'longitude': c.user.longitude })
        else:
            return h.toJSON({"status": "NOK", "message": _(u"couldnt_get_info"), 'error_code': 1})
    
    def get_stats(self):
        if c.user:
            videos = 0
            images = 0
            links = 0
            visits = 0
            positive_scorings = 0
            negative_scorings = 0
            
            visits = meta.Session.query(func.sum(Place.visits)).filter(Place.user_id == c.user.id).scalar()
            positive_scorings = meta.Session.query(func.sum(Place.positive_scorings.any())).filter(Place.user_id == c.user.id)
            aux = meta.Session.query(func.sum(Comment.positive_scorings.any())).filter(Comment.user_id == c.user.id)
            positive_scorings = aux.scalar() + positive_scorings.scalar();
            places = meta.Session.query(Place).filter(Place.user_id == c.user.id).count()
            comments = meta.Session.query(Comment).filter(Comment.user_id == c.user.id).count()
            return h.toJSON({"status": "OK", "places": places, "comments":comments, 
                             "visits":visits, "positive_scorings":positive_scorings })
            
        else:
            return h.toJSON({"status": "NOK", "message": _(u"couldnt_get_info"), 'error_code': 1})
        
            
    def get_position(self):
        if c.user and c.user.latitude and c.user.longitude:
            return h.toJSON({"status": "OK", 'latitude': c.user.latitude, 'longitude': c.user.longitude})
        else:
            return h.toJSON({"status": "NOK", "message": _(u"couldnt_get_location"), 'error_code': 0})
        
    def report_abuse(self):
        if c.user:
            gmailUser = 'admin@tedx.com'
            gmailPassword = 'tedx.2010'
            
            type = request.params.get('type')
            element_id = request.params.get('id')
            
            if type == "comment":
                db_object = meta.Session.query(Comment).filter_by(id = self.prm('id')).first()
            elif type == "place":
                db_object = meta.Session.query(Place).filter_by(id = self.prm('id')).first()
                
            if db_object is not None:
                # ENVIO DEL EMAIL DE INVITACION
                text = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /><title>mail</title></head>' \
                        + '<body><table width="700" cellspacing="0" cellpadding="0" style="border-color:#db1b1b; border-width:2px;border-style:solid"><tbody><tr bgcolor="#db1b1b" height="45"><td colspan="2" style="color:#FFFFFF;font-size:30px;font-weight: bold;padding-left:20px; background-image:url(''/images/banner50_800.png'');">Streetrs</td></tr>' \
                        + '<tr><td width="300" height="300" align="center" style="padding: 10px; font-size:11px;color:#db1b1b;" >'
    
                                # You can copy the URL from the image below, however.
                #
                if type == "comment":
                    latitude = str(db_object.place.latitude)
                    longitude = str(db_object.place.longitude)
                else:
                    latitude = str(db_object.latitude)
                    longitude = str(db_object.longitude)
                    
                url = 'http://maps.google.com/maps/api/staticmap?center=' + latitude + ',' +longitude +'&zoom=14&size=300x300&maptype=satellite' \
                      + '&markers=icon:http://www.tedx.com/images/red_marker.png|shadow:true|'+ latitude + ',' + longitude +'&sensor=false' 
                
                text = text + '<img src="' + url +  '"></img></b></td>' \
                    + '<td style = "color:#000000; font-size: 11px;"><h3 style="color:#db1b1b;font-size: 14px;">Reporte de abuso</h3>' \
                    
                text = text + '<p style="color:#000000;"><b>' + c.user.nickname + '</b> ha reportado este elemento como spam <b>Streetrs</b> '
                
                if type == "comment":    
                    text = text + '<br/><p><ul><li>T&iacute;tulo: "'+ unicode(db_object.title) + '"</li><li>Contenido: "' + unicode(db_object.content) + '"</li><li>Id: "' + db_object.id +' "</li></ul></p>'
                else:
                    text = text + '<br/><p><ul><li>T&iacute;tulo: "'+ unicode(db_object.name) + '"</li><li>Id: "' + db_object.id +' "</li></ul></p>'    
                
                
                text = text + '</p>' + '<p style="text-align:justify; padding-right:20px;color:#000000"><b>Streetrs</b> es la nueva manera de comunicaci&oacute;n, de hablar sobre un lugar, de dejarle a alguien un mensaje en un sitio concreto, all&iacute; donde os reun&iacute;s todos los fines de semana o simplemente donde &iacute;bais en los viejos tiempos. <p> Sube un v&iacute;deo, una foto o un mensaje para que lo pueda ver paseando por la calle tambi&eacute;n. Para ver el contenido  del mensaje s&oacute;lo tienes que ir al lugar indicado en el mapa.</p>'
                text = text +' <p>Una vez registrado puedes publicar nuevos streetits, votar comentarios y lugares de otros usuarios, pegar las pegatinas en la calle, enviar mensajes a tus amigos, etc.</p></p></td></tr>' \
                            + '<tr> <td colspan="2"><h3 style="color:#db1b1b;font-size: 16px;text-align:center;">&iexcl; &Uacute;nete y Ponte a Streetear!</h3></td></tr></tbody> </table></body></html>'
            
               
                
                msg = MIMEMultipart()
                msg['From'] = gmailUser
                msg['To'] = gmailUser
                msg['Subject'] = 'Reporte de tedx'
                msg.attach(MIMEText(text.encode('utf-8','replace'),'html','charset=utf-8'))
                    
                #for attachmentFilePath in attachmentFilePaths:
                 #   msg.attach(getAttachment(attachmentFilePath))
                       
                mailServer = smtplib.SMTP('smtp.gmail.com', 587)
                mailServer.ehlo()
                mailServer.starttls()
                mailServer.ehlo()
                mailServer.login(gmailUser, gmailPassword)
                mailServer.sendmail(gmailUser, gmailUser, msg.as_string())
                mailServer.close()
                    
                        
                return h.toJSON({'status': 'OK'})
            else:
                return h.toJSON({'status': 'NOK', 'message': 'Error al notificar', 'error_code': 0})
        else:
            return h.toJSON({'status': 'NOK', 'message': _(u'you_must_login'), 'error_code': 1})
    
    def upload_avatar(self):
        file = request.params.get('file')
        if file is not None and file != '':
            name = file.name
            folder = c.user.id.lstrip(os.sep)
            if not os.path.isdir(os.path.join(os.getcwd(), 'tedx/public/avatars/', folder)):
                os.mkdir(os.path.join(os.getcwd(), 'tedx/public/avatars/', folder))
                
            full_path = os.path.join(os.getcwd(), 'tedx/public/avatars/', folder, folder)
            permanent_file = open(full_path, 'w')

            shutil.copyfileobj(file.file, permanent_file)
            file.file.close()
            permanent_file.close()
            c.user.avatar = "/avatars/" + folder + "/" + folder
            
            try:
                im = Image.open(os.path.join(os.getcwd(),'tedx/public/avatars/', folder, folder))
            except Exception, e:
                print e
                os.remove(os.path.join(os.getcwd(),'tedx/public/avatars/', folder, folder))
                return h.toJSON({'status': 'NOK', 'message': _(u'file_selected_is_not_an image'), 'error_code': 0})
            
            im = im.convert('RGB')
            width, height = im.size
            filename = folder + '.png'
            filenamemid = folder + '_mid.png'
            filenamemini = folder + '_small.png'
            out = im
            outmid = im
            outmini = im
            imAspect = float(width)/float(height)
                    
                    # Avatar
            if width >app_globals.default_image_size or height >app_globals.default_image_size:
                if width > height:
                    out = im.resize((app_globals.default_image_size,int(float(app_globals.default_image_size) / imAspect)), Image.ANTIALIAS)
                else:
                    out = im.resize((int(float(app_globals.default_image_size) * imAspect),app_globals.default_image_size), Image.ANTIALIAS)
                    
            # image medio
            if width >app_globals.mid_image_size or height >app_globals.mid_image_size:
                if width > height:
                    outmid = im.resize((app_globals.mid_image_size,int(float(app_globals.mid_image_size) / imAspect)), Image.ANTIALIAS)
                else:
                    outmid = im.resize((int(float(app_globals.mid_image_size) * imAspect),app_globals.mid_image_size), Image.ANTIALIAS)
                    
            # image pequeño
            if width >app_globals.small_image_size or height >app_globals.small_image_size:
                if width > height:
                    outmini = im.resize((app_globals.small_image_size,int(float(app_globals.small_image_size) / imAspect)), Image.ANTIALIAS)
                else:
                    outmini = im.resize((int(float(app_globals.small_image_size) * imAspect),app_globals.small_image_size), Image.ANTIALIAS)
            
            out.save(os.path.join(os.getcwd(),'tedx/public/avatars/', folder, filename.lstrip(os.sep)))
            outmid.save(os.path.join(os.getcwd(),'tedx/public/avatars/', folder, filenamemid.lstrip(os.sep)))
            outmini.save(os.path.join(os.getcwd(),'tedx/public/avatars/', folder, filenamemini.lstrip(os.sep)))
            os.remove(os.path.join(os.getcwd(),'tedx/public/avatars/', folder, folder))
                    
                
            meta.Session.add(c.user)
            meta.Session.commit()
                
            return h.toJSON({'status': 'OK', 'message': 'OK'})
        return h.toJSON({'status': 'NOK', 'message': _(u'error_saving_file'), 'error_code': 0})

    
