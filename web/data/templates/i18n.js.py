# -*- encoding:utf-8 -*-
from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
__M_dict_builtin = dict
__M_locals_builtin = locals
_magic_number = 6
_modified_time = 1340618450.8180699
_template_filename='/var/www/feelicity/20120625120040/tedx/templates/i18n.js'
_template_uri='/i18n.js'
_template_cache=cache.Cache(__name__, _modified_time)
_source_encoding='utf-8'
from webhelpers.html import escape
_exports = []


def render_body(context,**pageargs):
    context.caller_stack._push_frame()
    try:
        __M_locals = __M_dict_builtin(pageargs=pageargs)
        _ = context.get('_', UNDEFINED)
        __M_writer = context.writer()
        # SOURCE LINE 1
        __M_writer(u'var dictionary = {\n    "you_are_here": "')
        # SOURCE LINE 2
        __M_writer(escape(_(u"you_are_here")))
        __M_writer(u'",\n    "url_is_not_valid": "')
        # SOURCE LINE 3
        __M_writer(escape(_(u"url_is_not_valid")))
        __M_writer(u'",\n    "place_name_cannot_be_null": "')
        # SOURCE LINE 4
        __M_writer(escape(_(u"place_name_cannot_be_null")))
        __M_writer(u'",\n    "comment_content_cannot_be_null": "')
        # SOURCE LINE 5
        __M_writer(escape(_(u"comment_content_cannot_be_null")))
        __M_writer(u'",\n    "location_cannot_be_null": "')
        # SOURCE LINE 6
        __M_writer(escape(_(u"location_cannot_be_null")))
        __M_writer(u'",\n    "receivers_cannot_be_null": "')
        # SOURCE LINE 7
        __M_writer(escape(_(u"receivers_cannot_be_null")))
        __M_writer(u'",\n    "file_selected_is_not_an image": "')
        # SOURCE LINE 8
        __M_writer(escape(_(u"file_selected_is_not_an image")))
        __M_writer(u'",\n    "file_selected_is_not_a_video": "')
        # SOURCE LINE 9
        __M_writer(escape(_(u"file_selected_is_not_a_video")))
        __M_writer(u'",\n    "image": "')
        # SOURCE LINE 10
        __M_writer(escape(_(u"image")))
        __M_writer(u'",\n    "video": "')
        # SOURCE LINE 11
        __M_writer(escape(_(u"video")))
        __M_writer(u'",\n    "images" : "')
        # SOURCE LINE 12
        __M_writer(escape(_(u"images")))
        __M_writer(u'",\n    "videos": "')
        # SOURCE LINE 13
        __M_writer(escape(_(u"videos")))
        __M_writer(u'",\n    "place_saved": "')
        # SOURCE LINE 14
        __M_writer(escape(_(u"place_saved")))
        __M_writer(u'",\n    "looking_for_results": "')
        # SOURCE LINE 15
        __M_writer(escape(_(u"looking_for_results")))
        __M_writer(u'",\n    "results_found_in_your_streetits": "')
        # SOURCE LINE 16
        __M_writer(escape(_(u"results_found_in_your_streetits")))
        __M_writer(u'",\n    "results_found_for": "')
        # SOURCE LINE 17
        __M_writer(escape(_(u"results_found_for")))
        __M_writer(u'",\n    "results_found_in_this_map_area": "')
        # SOURCE LINE 18
        __M_writer(escape(_(u"results_found_in_this_map_area")))
        __M_writer(u'",\n    "print_them": "')
        # SOURCE LINE 19
        __M_writer(escape(_(u"print_them")))
        __M_writer(u'",\n    "page": "')
        # SOURCE LINE 20
        __M_writer(escape(_(u"page")))
        __M_writer(u'",\n    "of": "')
        # SOURCE LINE 21
        __M_writer(escape(_(u"of")))
        __M_writer(u'",\n    "author": "')
        # SOURCE LINE 22
        __M_writer(escape(_(u"author")))
        __M_writer(u'",\n    "last_update": "')
        # SOURCE LINE 23
        __M_writer(escape(_(u"last_update")))
        __M_writer(u'",\n    "comments": "')
        # SOURCE LINE 24
        __M_writer(escape(_(u"comments")))
        __M_writer(u'",\n    "comment": "')
        # SOURCE LINE 25
        __M_writer(escape(_(u"comment")))
        __M_writer(u'",\n    "visits": "')
        # SOURCE LINE 26
        __M_writer(escape(_(u"visits")))
        __M_writer(u'",\n    "links": "')
        # SOURCE LINE 27
        __M_writer(escape(_(u"links")))
        __M_writer(u'",\n    "link": "')
        # SOURCE LINE 28
        __M_writer(escape(_(u"link")))
        __M_writer(u'",\n    "visit": "')
        # SOURCE LINE 29
        __M_writer(escape(_(u"visit")))
        __M_writer(u'",\n    "scorings": "')
        # SOURCE LINE 30
        __M_writer(escape(_(u"scorings")))
        __M_writer(u'",\n    "scoring" : "')
        # SOURCE LINE 31
        __M_writer(escape(_(u"scoring")))
        __M_writer(u'",\n    "has_uploaded" : "')
        # SOURCE LINE 32
        __M_writer(escape(_(u"has_uploaded")))
        __M_writer(u'",\n    "like" : "')
        # SOURCE LINE 33
        __M_writer(escape(_(u"like")))
        __M_writer(u'",\n    "contents" : "')
        # SOURCE LINE 34
        __M_writer(escape(_(u"contents")))
        __M_writer(u'",\n    "print": "')
        # SOURCE LINE 35
        __M_writer(escape(_(u"print")))
        __M_writer(u'",\n    "follow": "')
        # SOURCE LINE 36
        __M_writer(escape(_(u"follow")))
        __M_writer(u'",\n    "unfollow": "')
        # SOURCE LINE 37
        __M_writer(escape(_(u"unfollow")))
        __M_writer(u'",\n    "you_have_no_streetits": "')
        # SOURCE LINE 38
        __M_writer(escape(_(u"you_have_no_streetits")))
        __M_writer(u'",\n    "no_results_found_for": "')
        # SOURCE LINE 39
        __M_writer(escape(_(u"no_results_found_for")))
        __M_writer(u'",\n    "no_results_found_in_this_map_area": "')
        # SOURCE LINE 40
        __M_writer(escape(_(u"no_results_found_in_this_map_area")))
        __M_writer(u'",\n    "dowload_sticker_truncated": "')
        # SOURCE LINE 41
        __M_writer(escape(_(u"dowload_sticker_truncated")))
        __M_writer(u'",\n    "notification_sent": "')
        # SOURCE LINE 42
        __M_writer(escape(_(u"notification_sent")))
        __M_writer(u'",\n    "couldnt_get_location_click_on_map": "')
        # SOURCE LINE 43
        __M_writer(escape(_(u"couldnt_get_location_click_on_map")))
        __M_writer(u'",\n    "error_changing_password": "')
        # SOURCE LINE 44
        __M_writer(escape(_(u"error_changing_password")))
        __M_writer(u'",\n    "email_cannot_be_null": "')
        # SOURCE LINE 45
        __M_writer(escape(_(u"email_cannot_be_null")))
        __M_writer(u'",\n    "password_cannot_be_null": "')
        # SOURCE LINE 46
        __M_writer(escape(_(u"password_cannot_be_null")))
        __M_writer(u'",\n    "wrong_password_confirmation": "')
        # SOURCE LINE 47
        __M_writer(escape(_(u"wrong_password_confirmation")))
        __M_writer(u'",\n    "nickname_cannot_be_null": "')
        # SOURCE LINE 48
        __M_writer(escape(_(u"nickname_cannot_be_null")))
        __M_writer(u'",\n    "results_found": "')
        # SOURCE LINE 49
        __M_writer(escape(_(u"results_found")))
        __M_writer(u'",\n    "no_results_found": "')
        # SOURCE LINE 50
        __M_writer(escape(_(u"no_results_found")))
        __M_writer(u'",\n    "notify": "')
        # SOURCE LINE 51
        __M_writer(escape(_(u"notify")))
        __M_writer(u'",\n    "download_sticker": "')
        # SOURCE LINE 52
        __M_writer(escape(_(u"download_sticker")))
        __M_writer(u'",\n    "download_video": "')
        # SOURCE LINE 53
        __M_writer(escape(_(u"download_video")))
        __M_writer(u'",\n    "download_empty_places": "')
        # SOURCE LINE 54
        __M_writer(escape(_(u"download_empty_places")))
        __M_writer(u'",\n    "remove": "')
        # SOURCE LINE 55
        __M_writer(escape(_(u"remove")))
        __M_writer(u'",\n    "positive_scorings": "')
        # SOURCE LINE 56
        __M_writer(escape(_(u"positive_scorings")))
        __M_writer(u'",\n    "negative_scorings": "')
        # SOURCE LINE 57
        __M_writer(escape(_(u"negative_scorings")))
        __M_writer(u'",\n    "positive_scoring": "')
        # SOURCE LINE 58
        __M_writer(escape(_(u"positive_scoring")))
        __M_writer(u'",\n    "negative_scoring": "')
        # SOURCE LINE 59
        __M_writer(escape(_(u"negative_scoring")))
        __M_writer(u'",\n    "toggle_position": "')
        # SOURCE LINE 60
        __M_writer(escape(_(u"toggle_position")))
        __M_writer(u'",\n    "comment_removed_on": "')
        # SOURCE LINE 61
        __M_writer(escape(_(u"comment_removed_on")))
        __M_writer(u'",\n    "scoring_successfully_saved": "')
        # SOURCE LINE 62
        __M_writer(escape(_(u"scoring_successfully_saved")))
        __M_writer(u'",\n    "comment_successfully_saved": "')
        # SOURCE LINE 63
        __M_writer(escape(_(u"comment_successfully_saved")))
        __M_writer(u'",\n    "comment_successfully_removed": "')
        # SOURCE LINE 64
        __M_writer(escape(_(u"comment_successfully_removed")))
        __M_writer(u'",\n    "new_place_message": "')
        # SOURCE LINE 65
        __M_writer(escape(_(u"new_place_message")))
        __M_writer(u'",\n    "new_comment_message": "')
        # SOURCE LINE 66
        __M_writer(escape(_(u"new_comment_message")))
        __M_writer(u'",\n    "all_categories": "')
        # SOURCE LINE 67
        __M_writer(escape(_(u"all_categories")))
        __M_writer(u'",\n    "none" : "')
        # SOURCE LINE 68
        __M_writer(escape(_(u"none")))
        __M_writer(u'",\n    "searching_for_results" : "')
        # SOURCE LINE 69
        __M_writer(escape(_(u"searching_for_results")))
        __M_writer(u'",\n    "results_per_page" : "')
        # SOURCE LINE 70
        __M_writer(escape(_(u"results_per_page")))
        __M_writer(u'",\n    "report" : "')
        # SOURCE LINE 71
        __M_writer(escape(_(u"report")))
        __M_writer(u'",\n    "youtube" : "')
        # SOURCE LINE 72
        __M_writer(escape(_(u"youtube")))
        __M_writer(u'",\n    "edit" : "')
        # SOURCE LINE 73
        __M_writer(escape(_(u"edit")))
        __M_writer(u'",\n    "You don\'t have new messages on your inbox":"')
        # SOURCE LINE 74
        __M_writer(escape(_(u"You don't have new messages on your inbox")))
        __M_writer(u'",\n    "You are not currently following anyone":"')
        # SOURCE LINE 75
        __M_writer(escape(_(u"You are not currently following anyone")))
        __M_writer(u'",\n    "You are not currently being followed by anyone":"')
        # SOURCE LINE 76
        __M_writer(escape(_(u"You are not currently being followed by anyone")))
        __M_writer(u'",\n    "There are no pending categories to join":"')
        # SOURCE LINE 77
        __M_writer(escape(_(u"There are no pending categories to join")))
        __M_writer(u'",\n    "There are no pending requests":"')
        # SOURCE LINE 78
        __M_writer(escape(_(u"There are no pending requests")))
        __M_writer(u'",\n    "error_changing_password":"')
        # SOURCE LINE 79
        __M_writer(escape(_(u"error_changing_password")))
        __M_writer(u'",\n    "accept" : "')
        # SOURCE LINE 80
        __M_writer(escape(_(u"accept")))
        __M_writer(u'",\n    "cancel" : "')
        # SOURCE LINE 81
        __M_writer(escape(_(u"cancel")))
        __M_writer(u'",\n    "advanced" : "')
        # SOURCE LINE 82
        __M_writer(escape(_(u"advanced")))
        __M_writer(u'",\n    "reject" : "')
        # SOURCE LINE 83
        __M_writer(escape(_(u"reject")))
        __M_writer(u'",\n    "join_categories" : "')
        # SOURCE LINE 84
        __M_writer(escape(_(u"join_categories")))
        __M_writer(u'",\n    "happy_users" : "')
        # SOURCE LINE 85
        __M_writer(escape(_(u"happy_users")))
        __M_writer(u'",\n    "happy_moments" : "')
        # SOURCE LINE 86
        __M_writer(escape(_(u"happy_moments")))
        __M_writer(u'",\n    "happy_moment" : "')
        # SOURCE LINE 87
        __M_writer(escape(_(u"happy_moment")))
        __M_writer(u'",\n    "happy_cities" : "')
        # SOURCE LINE 88
        __M_writer(escape(_(u"happy_cities")))
        __M_writer(u'",\n    "mobile" : "')
        # SOURCE LINE 89
        __M_writer(escape(_(u"mobile")))
        __M_writer(u'",\n    "follow_us" : "')
        # SOURCE LINE 90
        __M_writer(escape(_(u"follow_us")))
        __M_writer(u'",\n    "change" : "')
        # SOURCE LINE 91
        __M_writer(escape(_(u"change")))
        __M_writer(u'",\n    "add_comment" : "')
        # SOURCE LINE 92
        __M_writer(escape(_(u"add_comment")))
        __M_writer(u'",\n    "happy_map": "')
        # SOURCE LINE 93
        __M_writer(escape(_(u"happy_map")))
        __M_writer(u'",\n    "man": "')
        # SOURCE LINE 94
        __M_writer(escape(_(u"man")))
        __M_writer(u'",\n    "woman": "')
        # SOURCE LINE 95
        __M_writer(escape(_(u"woman")))
        __M_writer(u'",\n    "login_question" : "')
        # SOURCE LINE 96
        __M_writer(escape(_(u"login_question")))
        __M_writer(u'",\n    "what_map" : "')
        # SOURCE LINE 97
        __M_writer(escape(_(u"what_map")))
        __M_writer(u'",\n    "geolocation" : "')
        # SOURCE LINE 98
        __M_writer(escape(_(u"geolocation")))
        __M_writer(u'",\n    "coming_soon" : "')
        # SOURCE LINE 99
        __M_writer(escape(_(u"coming_soon")))
        __M_writer(u'",\n    "has_written" : "')
        # SOURCE LINE 100
        __M_writer(escape(_(u"has_written")))
        __M_writer(u'",\n    "has_received" : "')
        # SOURCE LINE 101
        __M_writer(escape(_(u"has_received")))
        __M_writer(u'",\n    "position" : "')
        # SOURCE LINE 102
        __M_writer(escape(_(u"position")))
        __M_writer(u'",\n    "iphone_application_exists" : "')
        # SOURCE LINE 103
        __M_writer(escape(_(u"iphone_application_exists")))
        __M_writer(u'",\n    "android_application_exists" : "')
        # SOURCE LINE 104
        __M_writer(escape(_(u"android_application_exists")))
        __M_writer(u'",\n    "idea" : "')
        # SOURCE LINE 105
        __M_writer(escape(_(u"idea")))
        __M_writer(u'",\n    "available" : "')
        # SOURCE LINE 106
        __M_writer(escape(_(u"available")))
        __M_writer(u'",\n    "developed" : "')
        # SOURCE LINE 107
        __M_writer(escape(_(u"developed")))
        __M_writer(u'"\n}\n')
        return ''
    finally:
        context.caller_stack._pop_frame()


