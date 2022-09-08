//
//  UserKeys.swift
//  eventsProject
//
//  Created by Pietro Putelli on 01/09/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import Foundation
import MapKit

struct FACEBOOK {
    static let PLACEMENT_ID = "2093409034105698_2093487387431196"
}

struct FONTS {
    static let LEIXO = UIFont(name: "LEIXO-Regular", size: 22)!
    static let ACCURATIST = UIFont(name: "Accuratist", size: 22)!
}

class CONST {
    
    static let KM = 6373 
    static let ML = 3961
    static let CONVERT_FACTOR: Float = 0.62
    
    class func getConst(measureUnit: Int) -> Int {
        if measureUnit != 2 {
            return CONST.KM
        } else {
            return CONST.ML
        }
    }
}

struct User {
    static var id = Int()
    static var name = String()
    static var email = String()
    static var password = String()
    static var status = String()
    static var location = CLLocationCoordinate2D()
    static var language_index = Int()
    static var language: Language!
    static var notifications = [Bool]()
    static var business_email = String()
    static var phone = String()
    static var web_site = String()
    static var theme_index: Int!
    static var profile_image: UIImage!
}

struct PHP {
    
    static let DOMAIN = "https://finixapps.com/wow/php/"
    static let USER_DOMAIN = "https://finixapps.com/wow/php/User/"
    static let LOCAL_DOMAIN = "https://finixapps.com/wow/php/Local/"
    static let EVENT_DOMAIN = "https://finixapps.com/wow/php/Event/"
    static let PUSH_NOTIFICATION_DOMAIN = "https://finixapps.com/wow/php/pushNotifications/"
    
    // USER \\
    
    static let USER_LOGGED_SET = "USER_LOGGED_SET.php"
    static let USER_CONFIRM_ACCOUNT = "USER_CONFIRM_ACCOUNT.php"
    static let USER_DATA_GET = "USER_DATA_GET.php"
    static let USER_FRIENDS_GET = "USER_FRIENDS_GET.php"
    static let USER_FRIEND_SET = "USER_FRIEND_SET.php"
    static let USER_CHECK_FOLLOWING = "USER_CHECK_FOLLOWING.php"
    static let USER_IMG_SET = "USER_IMG_SET.php"
    static let USER_LOCATION_SET = "USER_LOCATION_SET.php"
    static let USER_NAME_SET = "USER_NAME_SET.php"
    static let USER_PASSWORD_SET = "USER_PASSWORD_SET.php"
    static let USER_STATUS_SET = "USER_STATUS_SET.php"
    static let SEND_CONFIRM_EMAIL = "SEND_CONFIRM_EMAIL.php"
    static let CHECK_EMAIL_EXISTENCE = "CHECK_EMAIL_EXISTENCE.php"
    static let USER_LOCALS_GET = "USER_LOCALS_GET.php"
    static let USER_EVENTS_GET = "USER_EVENTS_GET.php"
    static let USERS_SEARCH_GET = "USERS_SEARCH_GET.php"
    static let USER_TOKEN_SET = "USER_TOKEN_SET.php"
    static let USER_FRIEND_TOKEN_SET = "USER_FRIEND_TOKEN_SET.php"
    static let USER_LIKE_EVENT_ADD = "USER_LIKE_EVENT_ADD.php"
    static let USER_LIKE_EVENT_REMOVE = "USER_LIKE_EVENT_REMOVE.php"
    static let USER_FRIEND_ADD = "USER_FRIEND_ADD.php"
    static let USER_FRIEND_REMOVE = "USER_FRIEND_REMOVE.php"
    static let USER_REGISTRATION = "USER_REGISTRATION.php"
    static let USER_CHECK_PASSWORD = "USER_CHECK_PASSWORD.php"
    static let USER_RESET_PASSWORD = "USER_RESET_PASSWORD.php"
    static let USER_FOLLOWERS_NUM_GET = "USER_FOLLOWERS_NUM_GET.php"
    static let USER_FOLLOWING_NUM_GET = "USER_FOLLOWING_NUM_GET.php"
    static let USER_BUSINESS_INFO = "USER_BUSINESS_INFO.php"
    static let USER_FOLLOWERS_GET = "USER_FOLLOWERS_GET.php"
    static let FRIEND_BY_EMAIL_GET = "FRIEND_BY_EMAIL_GET.php"
    static let USER_NOTIFICATIONS_SET = "USER_NOTIFICATIONS_SET.php"
    static let USER_NOTIFICATIONS_SETTINGS_GET = "USER_NOTIFICATIONS_SETTINGS_GET.php"
    static let USER_NOTIFICATIONS_SETTINGS_SET = "USER_NOTIFICATIONS_SETTINGS_SET.php"
    static let USER_CHECK_EXISTENCE = "USER_CHECK_EXISTENCE.php"
    static let USER_UNIQUE_NAME = "USER_UNIQUE_NAME.php"
    
    // AREA \\
    
    static let LOCAL_AREA_GET = "LOCAL_AREA_GET.php"
    static let EVENT_AREA_GET = "EVENT_AREA_GET.php"
    
    // LOCALS \\
    
    static let LOCAL_SET = "LOCAL_SET.php"
    static let LOCAL_UPDATE = "LOCAL_UPDATE.php"
    static let FAV_LOCALS_GET = "FAV_LOCALS_GET.php"
    static let FAV_LOCALS_SET = "FAV_LOCALS_SET.php"
    static let REVIEW_IDS_SET = "REVIEW_IDS_SET.php"
    static let FAV_LOCAL_CHECK = "FAV_LOCAL_CHECK.php"
    static let LOCAL_REVIEWS_GET = "LOCAL_REVIEWS_GET.php"
    static let LOCAL_CHECK_REVIEW_EXISTENCE = "LOCAL_CHECK_REVIEW_EXISTENCE.php"
    static let LOCAL_DELETE_REVIEW = "LOCAL_DELETE_REVIEW.php"
    static let LOCAL_REVIEWS_SET = "LOCAL_REVIEWS_SET.php"
    static let LOCAL_TOP_GET = "LOCAL_TOP_GET.php"
    static let LOCAL_IMAGE_IDS_GET = "LOCAL_IMAGE_IDS_GET.php"
    static let LOCAL_IMAGE_IDS_SET = "LOCAL_IMAGE_IDS_SET.php"
    static let LOCAL_BY_ID_GET = "ID_LOCALS_GET.php"
    static let FAV_LOCAL_ADD = "FAV_LOCAL_ADD.php"
    static let FAV_LOCAL_REMOVE = "FAV_LOCAL_REMOVE.php"
    static let DELETE_LOCAL = "DELETE_LOCAL.php"
    static let LOCAL_RATING_GET = "LOCAL_RATING_GET.php"
    static let LOCAL_RATING_ADD = "LOCAL_RATING_ADD.php"
    static let LOCAL_RATING_REMOVE = "LOCAL_RATING_REMOVE.php"
    static let LOCAL_EVENT_GET = "LOCAL_EVENT_GET.php"
    static let LOCAL_LIKES_GET = "LOLAL_LIKES_GET.php"
    
    // EVENTS \\
    
    static let EVENT_SET = "EVENT_SET.php"
    static let LIKED_EVENTS_SET = "LIKED_EVENTS_SET.php"
    static let LIKED_EVENT_IDS_GET = "LIKED_EVENT_IDS_GET.php"
    static let EVENT_TOP_GET = "EVENT_TOP_GET.php"
    static let EVENT_UPDATE = "EVENT_UPDATE.php"
    static let LOCAL_EVENTS_GET = "LOCAL_EVENTS_GET.php"
    static let EVENT_GOING_ADD = "EVENT_GOING_ADD.php"
    static let EVENT_GOING_REMOVE = "EVENT_GOING_REMOVE.php"
    static let DELETE_EVENT = "DELETE_EVENT.php"
    static let FAV_EVENT_REMOVE = "FAV_EVENT_REMOVE.php"
    static let FAV_EVENT_ADD = "FAV_EVENT_ADD.php"
    static let FAV_EVENTS_GET = "FAV_EVENTS_GET.php"
    static let GOING_EVENTS_GET = "GOING_EVENTS_GET.php"
    static let FAV_EVENT_CHECK = "FAV_EVENT_CHECK.php"
    static let GOING_EVENT_CHECK = "GOING_EVENT_CHECK.php"
    static let EVENT_DISCUSSION_SET = "EVENT_DISCUSSION_SET.php"
    static let EVENT_DISCUSSION_GET = "EVENT_DISCUSSION_GET.php"
    static let EVENT_CHECK_DISCUSSION_EXISTENCE = "EVENT_CHECK_DISCUSSION_EXISTENCE.php"
    static let EVENT_DELETE_DISCUSSION = "EVENT_DELETE_DISCUSSION.php"
    static let EVENT_REPLYES_GET = "EVENT_REPLYES_GET.php"
    static let EVENT_REPLY_DELETE = "EVENT_REPLY_DELETE.php"
    static let EVENT_DISCUSSION_REPLY_SET = "EVENT_DISCUSSION_REPLY_SET.php"
    static let EVENT_GOING_LIKE_GET = "EVENT_GOING_LIKE_GET.php"
    
    // Notifications \\
    
    static let LOCAL_NOTIFICATION = "LOCAL_NOTIFICATION.php"
    static let EVENT_NOTIFICATION = "EVENT_NOTIFICATION.php"
    static let FRIEND_EVENT_NOTIFICATION = "FRIEND_EVENT_NOTIFICATION.php"
    static let FOLLOW_NOTIFICATION = "FOLLOW_NOTIFICATION.php"
    static let REPLY_NOTIFICATION = "EVEN_REPLY_NOTIFICATION.php"
    
    static let REPORT = "REPORT.php"
    static let SEND_REPOT_EMAIL = "SEND_REPORT_EMAIL.php"
}

struct USER_KEYS {
    static let ALREADY_REGISTERED = "ALREADY_REGISTERED"
    static let ID = "USER_ID"
    static let NAME = "USER_NAME"
    static let EMAIL = "USER_EMAIL"
    static let PASSWORD = "USER_PASSWORD"
    static let STATUS = "USER_STATUS"
    static let NOTIFICATIONS = "NOTIFICATIONS"
    static let LANGUAGE_INDEX = "LANGUAGE_INDEX"
    static let BUSINESS_EMAIL = "BUSINESS_EMAIL"
    static let PHONE = "PHONE"
    static let WEB_SITE = "WEB_SITE"
    static let TOKEN = "TOKEN"
    static let PROFILE_PICTURE = "USER_PP"
}

struct NOTIFICATION_KEYS {
    static let LOCAL = "NOTIFY_LOCAL"
    static let EVENT = "NOTIFY_EVENT"
    static let FRIEND = "NOTIFY_FRIEND"
    static let FOLLOW = "NOTIFY_FOLLOW"
}
