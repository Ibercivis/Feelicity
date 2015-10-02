# -*- coding: utf-8 -*-
import os
from tedx.lib.base import *
from pylons.i18n import _
import Image
import smtplib
from smtplib import SMTPRecipientsRefused
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
import string
import random
import shutil
from random import choice


import logging
log = logging.getLogger(__name__)

from sqlalchemy import orm, and_, or_, desc, select, func

class CommonController(BaseController):

    def index(self):
        return redirect(url(controller=''))

    def login(self):
        function = 'form_login'
        email = self.prm('login_email')
        password = self.prm('login_password')

        db_user = meta.Session.query(User).filter(or_(User.email==email, User.nickname==email)).first()

        if db_user is None or db_user.password != hashlib.md5(password).hexdigest():
            return h.toJSON({"status": "NOK", "message": _(u"login_error"), "error_code": 0})
        else:
            session['user_id'] = db_user.id
            session.save()
            return h.toJSON({"status": "OK"})

    def form_login(self):
        ''' Formulario de login '''
        function = 'form_login'

        email = self.prm('login_email')
        password = self.prm('login_password')

        db_user = meta.Session.query(User).filter(or_(User.email==email, User.nickname==email)).first()

        if db_user is None or db_user.password != hashlib.md5(password).hexdigest():
            c.message = _(u"login_error")
            return render("/login.mako")
        else:
            session['user_id'] = db_user.id
            session.save()
            return redirect(url(controller=''))

    def form_register(self):
        ''' Formulario de registro de nuevo usuario'''
        function = 'form_register'
        log.debug(function)

        email = self.prm('email')
        password = self.prm('password')
        password2 = self.prm('password1')
        nickname = self.prm('nickname')
        latitude = self.prm('latitude')
        longitude = self.prm('longitude')

        log.debug('%s - email:%s password:%s' % (function, email, password))

        if not email:
            c.message = _(u"email_cannot_be_null")
            return render("/register.mako")
        elif not password:
            c.message = _(u"password_cannot_be_null")
            return render("/register.mako")

        if password != password2:
            c.message = _(u"Confirm your password")
            return render("/register.mako")

        db_user = meta.Session.query(User).filter_by(email=email).first()
        if db_user is not None:
            c.message = _(u"email_already_registered")
            return render("/register.mako")

        reserved_nicknames = ['about', 'common', 'content', 'error', 'home', 'notification', "my_account",
                              'profile', 'register', 'view', 'bidis', 'css', 'files', 'images', 'js', 'swf']
        db_user = meta.Session.query(User).filter_by(nickname=nickname).first()
        if db_user is not None or nickname in reserved_nicknames:
            c.message = _(u"nickname_already_registered")
            return render("/register.mako")

        c.user = User(email, password, nickname, latitude, longitude)

        session['user_id'] = c.user.id
        session.save()

        return redirect(url(controller=''))

    def logout(self):
        if 'user_id' in session:
            del session['user_id']
            session.save()

            return h.toJSON({"status": "OK"})
        else:
            return h.toJSON({"status": "NOK", "error_code": 1})


    def translate(self):
        return _(self.prm('message'))

    def translation(self):
        return render('/i18n.js')


    def get_tags(self):
        a = select([Comment_tag.tag_id, func.count(Comment_tag.tag_id)], group_by=[Comment_tag.tag_id], order_by = [desc(func.count(Comment_tag.tag_id))])
        a = a.alias('query')
        results = meta.Session.query(a).limit(20)
        tags = []
        for result in results:
            tag = meta.Session.query(Tag).filter_by(id=result.tag_id).one()
            if tag.name != "":
                tags.append({"name": tag.name, "value": result[1], "id": tag.id})

        return h.toJSON({'status': 'OK', 'tags':tags})

    def change_language(self):
        session['lang'] = self.prm('selected_lang')
        session.save()
        set_lang(session['lang'])

        return h.toJSON({ 'status': 'OK' })

    def form_forgotten_password(self):
        email = self.prm('email')
        db_user = meta.Session.query(User).filter(User.email==email).first()
        if (db_user is None):
            c.message = _(u'No se ha encontrado un usuario con ese correo electrónico.')
            return render("/forgotpassword.mako")
        else:
            # Create and save the new password
            size = 9
            new_password = ''.join([choice(string.letters + string.digits) for i in range(size)])
            db_user.password = hashlib.md5(new_password).hexdigest()
            meta.Session.commit()

            # Send the email
            try:
                gmail_user = 'smile@feelicity.es' # REFACTOR: [JUANJO] Moverlo a algun sitio de configuracion
                gmail_pwd = '9G*rY2Vrr'

                msg = MIMEMultipart()
                msg['From'] = gmail_user
                msg['To'] = db_user.email
                msg['Subject'] = _(u'Nueva contraseña de AQUA')
                msg.attach(MIMEText(_(u'Nuevo password: ') + unicode(new_password, 'utf-8')))

                mailServer = smtplib.SMTP('smtp.gmail.com', 587)
                mailServer.ehlo()
                mailServer.starttls()
                mailServer.ehlo()
                mailServer.login(gmail_user, gmail_pwd)
                mailServer.sendmail(gmail_user, db_user.email, msg.as_string())
                mailServer.close()
            except SMTPRecipientsRefused:
                c.message = _(u'No se ha podido enviar el correo electrónico a la dirección indicada. Intentelo de nuevo más tarde.')

            return render("/home.mako")

    def forgotten_password(self):
        email = self.prm('email')
        db_user = meta.Session.query(User).filter(User.email==email).first()
        if (db_user is None):
            return h.toJSON({ 'status': 'NOK', 'message': _(u'No se ha encontrado un usuario con ese correo electrónico.') })
        else:
            # Create and save the new password
            size = 9
            new_password = ''.join([choice(string.letters + string.digits) for i in range(size)])
            db_user.password = hashlib.md5(new_password).hexdigest()
            meta.Session.commit()

            # Send the email
            try:
                gmail_user = 'smile@feelicity.es' # REFACTOR: [JUANJO] Moverlo a algun sitio de configuracion
                gmail_pwd = '9G*rY2Vrr'

                msg = MIMEMultipart()
                msg['From'] = gmail_user
                msg['To'] = db_user.email
                msg['Subject'] = _(u'Nueva contraseña de AQUA')
                msg.attach(MIMEText(_(u'Nuevo password: ') + unicode(new_password, 'utf-8')))

                mailServer = smtplib.SMTP('smtp.gmail.com', 587)
                mailServer.ehlo()
                mailServer.starttls()
                mailServer.ehlo()
                mailServer.login(gmail_user, gmail_pwd)
                mailServer.sendmail(gmail_user, db_user.email, msg.as_string())
                mailServer.close()
            except SMTPRecipientsRefused:
                return h.toJSON( { 'status': 'NOK', 'message': _(u'No se ha podido enviar el correo electrónico a la dirección indicada. Intentelo de nuevo más tarde.') } )

            return h.toJSON({ 'status': 'OK'})

    def get_happy_cities(self):
        db_query = select([Place.city, Place.country, func.count(Place.id)], group_by=[Place.city,Place.country], order_by = [desc(func.count(Place.id))])
        cities = []
        db_query = db_query.alias('query')
        results = meta.Session.query(db_query).limit(10)
        for result in results:
            if result[0] is not None:
                cities.append({"city":result[0], "country": result[1], "number": result[2]})
        return h.toJSON({'status':'OK', "cities": cities})

    def contact(self):
        email = self.prm('email')
        name = self.prm('name')
        content = self.prm('content')

        try:
            gmail_user = 'smile@feelicity.es' # REFACTOR: [JUANJO] Moverlo a algun sitio de configuracion
            gmail_pwd = '9G*rY2Vrr'

            msg = MIMEMultipart()
            msg['From'] = email
            msg['To'] = gmail_user
            msg['Subject'] = name + '<' + email + '>'
            msg.attach(MIMEText(content))

            mailServer = smtplib.SMTP('smtp.gmail.com', 587)
            mailServer.ehlo()
            mailServer.starttls()
            mailServer.ehlo()
            mailServer.login(gmail_user, gmail_pwd)
            mailServer.sendmail(email, gmail_user, msg.as_string())
            mailServer.close()
        except SMTPRecipientsRefused:
            return h.toJSON( { 'status': 'NOK', 'message': _(u'No se ha podido enviar el mensaje correctamente. Intentelo de nuevo más tarde.') } )

        return h.toJSON({ 'status': 'OK', 'message': _(u'Mensaje enviado correctamente. Nos pondremos en contacto contigo lo antes posible.') })
