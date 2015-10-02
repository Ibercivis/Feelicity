"""Helper functions

Consists of functions to typically be used within templates, but also
available to Controllers. This module is available to templates as 'h'.
"""
# Import helpers as desired, or define your own, ie:
#from webhelpers.html.tags import checkbox, password

import simplejson


def toJSON(obj):
    return simplejson.encoder.JSONEncoder(use_decimal=True, sort_keys=True, encoding="utf-8").encode(obj)

def generate_vcard(user, path, size):
    enc = Encoder()
    w = size
    
    vcard_text = "BEGIN:VCARD\n" + \
    "VERSION:3.0\n" + \
    "N:" + user.nickname + "\n" + \
    "EMAIL;TYPE=PREF,INTERNET:" + user.email + "\n"
    
    if user.name or user.surnames:
        vcard_text += "FN:"
        if user.name:
            vcard_text += user.name
        if user.surnames:
            vcard_text += " " + user.surnames
        vcard_text += "\n"
        
    if user.description:
        vcard_text += "NOTE:" + user.description + "\n"
        
    if user.address or user.city or user.country:
        vcard_text += "ADR:"
        if user.address:
            vcard_text += user.address
        if user.city:
            vcard_text += " " + user.city
        if user.country:
            vcard_text += " " + user.country
        vcard_text += "\n"
    
    vcard_text += "END:VCARD"
    
    qr = enc.encode(vcard_text.encode("utf8"), {'width': w, 'mode': 2})
    qr.save(path)
