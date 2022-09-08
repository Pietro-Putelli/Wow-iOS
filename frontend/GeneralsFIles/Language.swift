//
//  Language.swift
//  eventsProject
//
//  Created by Pietro Putelli on 04/07/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import Foundation
import UIKit

public struct Language {
    
    var id: String!
    var locals: String!
    var events: String!
    var reviews: String!
    var close: String!
    var open: String!
    var w1: String!
    var w2: String!
    var w3: String!
    var w4: String!
    var w5: String!
    var w6: String!
    var w7: String!
    var share: String!
    var like: String!
    var going: String!
    var details: String!
    var event_list: String!
    var local_list: String!
    var contacts: String!
    var place_info: String!
    var get_direction: String!
    var get_direction_map: String!
    var write_review: String!
    var from: String!
    var to: String!
    var at: String!
    var discussions: String!
    var top_area: String!
    var profile: String!
    var followers: String!
    var following: String!
    var my_locals: String!
    var my_events: String!
    var my_friends: String!
    var my_fav: String!
    var settings: String!
    var edit_profile: String!
    var edit_image: String!
    var name: String!
    var status: String!
    var edit_password: String!
    var log_out: String!
    var notifications: String!
    var appearance: String!
    var language: String!
    var measure_unit: String!
    var how_to: String!
    var info_finix: String!
    var notification_1: String!
    var notification_2: String!
    var notification_3: String!
    var notification_4: String!
    var them_type: String!
    var dark: String!
    var dark_blue: String!
    var light: String!
    var km: String!
    var ml: String!
    var area_interest: String!
    var area_interest_text: String!
    var about_wow: String!
    var text_01: String!
    var text_02: String!
    var create_local: String!
    var text_03: String!
    var text_04: String!
    var event_set: String!
    var text_05: String!
    var text_06: String!
    var contact_us: String!
    var text_07: String!
    var follow_in: String!
    var web_site: String!
    var create_new_local: String!
    var photos_album: String!
    var local_timetable: String!
    var title: String!
    var subtitle: String!
    var address: String!
    var city: String!
    var add_details: String!
    var music: String!
    var place: String!
    var quick_info: String!
    var phone: String!
    var web_site_link: String!
    var email: String!
    var parking: String!
    var ptTransport: String!
    var near: String!
    var create_new_event: String!
    var more_info: String!
    var date_time: String!
    var set_up: String!
    var vip: String!
    var price: String!
    var tickets: String!
    var report: String!
    var cancel: String!
    var delete_review: String!
    var locals_notification: String!
    var events_notifications: String!
    var friends_notifications: String!
    var current_password: String!
    var confirm_password: String!
    var new_password: String!
    var pass_error_1: String!
    var pass_error_2: String!
    var pass_error_3: String!
    var pass_error_4: String!
    var error_connection: String!
    var delete_local_event: String!
    var no_locals_1: String!
    var no_locals_2: String!
    var top_button: String!
    var no_events_1: String!
    var no_events_2: String!
    var no_events_3: String!
    var no_friends_1: String!
    var no_friends_2: String!
    var no_friends_3: String!
    var no_fav_1: String!
    var no_fav_2: String!
    var business_info: String!
    var edit_name: String!
    var local_error_1: String!
    var local_error_2: String!
    var local_error_3: String!
    var local_error_4: String!
    var local_error_5: String!
    var local_error_6: String!
    var local_error_7: String!
    var local_error_8: String!
    var local_error_9: String!
    var event_error_1: String!
    var event_error_2: String!
    var join_discussion: String!
    var discussion_title: String!
    var start_discussion: String!
    var view_reply: String!
    var delete: String!
    var answer_to: String!
    var reply: String!
    var search_friends_placeholder: String!
    var follow: String!
    var unfollow: String!
    var view_owner_profile: String!
    var review: String!
    var write_email: String!
    var empty_local: String!
    var empty_event: String!
    var username_exists: String!
    var event_local_error: String!
    var invalid_address: String!
    
    static func languageFromBundle() -> [Language] {
        var languages = [Language]()
        let url = Bundle.main.url(forResource: "LanguageJSON", withExtension: "json")
        
        do {
            let data = try Data(contentsOf: url!)
            
            guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]  else {
                return languages
            }
            
            guard let languageObjects = rootObject["language_array"] as? [[String:String]] else {
                return languages
            }
            
            for json in languageObjects {
                let language = Language.init(id: json["id"], locals: json["locals"], events: json["events"], reviews: json["reviews"], close: json["close"], open: json["open"], w1: json["w1"], w2: json["w2"], w3: json["w3"], w4: json["w4"], w5: json["w5"], w6: json["w6"], w7: json["w7"], share: json["share"], like: json["like"], going: json["going"], details: json["details"], event_list: json["event_list"], local_list: json["local_list"], contacts: json["contacts"], place_info: json["place_info"], get_direction: json["get_direction"], get_direction_map: json["get_direction_map"], write_review: json["write_review"], from: json["from"], to: json["to"], at: json["at"], discussions: json["discussions"], top_area: json["top_area"], profile: json["profile"], followers: json["followers"], following: json["following"], my_locals: json["my_locals"], my_events: json["my_events"], my_friends: json["my_friends"], my_fav: json["my_fav"], settings: json["settings"], edit_profile: json["edit_profile"], edit_image: json["edit_picture"], name: json["name"], status: json["status"], edit_password: json["edit_password"], log_out: json["log_out"], notifications: json["notifications"], appearance: json["appearance"], language: json["language"], measure_unit: json["measure_unit"], how_to: json["how_to"], info_finix: json["info_finix"], notification_1: json["notification_text_1"], notification_2: json["notification_text_2"], notification_3: json["notification_text_3"], notification_4: json["notification_text_4"], them_type: json["them_type"], dark: json["dark"], dark_blue: json["dark_blue"], light: json["light"], km: json["kilometer"], ml: json["mile"], area_interest: json["area_interest"], area_interest_text: json["area_interest_text"], about_wow: json["about_wow"], text_01: json["text_01"], text_02: json["text_02"], create_local: json["create_local"], text_03: json["text_03"], text_04: json["text_04"], event_set: json["event_set"], text_05: json["text_05"], text_06: json["text_06"], contact_us: json["contact_us"], text_07: json["text_07"], follow_in: json["follow_fb"], web_site: json["web_site"], create_new_local: json["create_new_local"], photos_album: json["photos_album"], local_timetable: json["local_timetable"], title: json["title"], subtitle: json["subtitle"], address: json["address"], city: json["city"], add_details: json["add_details"], music: json["music"], place: json["place"], quick_info: json["quick_info"], phone: json["phone"], web_site_link: json["web_site_link"], email: json["email"], parking: json["parking"], ptTransport: json["ptTransport"], near: json["near"], create_new_event: json["create_new_event"], more_info: json["more_info"], date_time: json["date_time"], set_up: json["set_up"], vip: json["vip"], price: json["price"], tickets: json["tickets"],report: json["report"],cancel: json["cancel"],delete_review: json["delete_review"], locals_notification: json["locals_notifications"], events_notifications: json["events_notifications"], friends_notifications: json["friends_notifications"], current_password: json["current_password"], confirm_password: json["confirm_password"], new_password: json["new_password"], pass_error_1: json["error_1"], pass_error_2: json["error_2"], pass_error_3: json["error_3"], pass_error_4: json["error_4"], error_connection: json["error_connection"], delete_local_event: json["delete_local_event"], no_locals_1: json["no_locals_1"], no_locals_2: json["no_locals_2"], top_button: json["top_button_plus"], no_events_1: json["no_events_1"], no_events_2: json["no_events_2"], no_events_3: json["top_button_plus"], no_friends_1: json["no_friends_1"], no_friends_2: json["no_friends_2"], no_friends_3: json["no_friends_3"], no_fav_1: json["no_fav_1"], no_fav_2: json["no_fav_2"], business_info: json["business_info"], edit_name: json["edit_username"], local_error_1: json["local_error_1"], local_error_2: json["local_error_2"], local_error_3: json["local_error_3"], local_error_4: json["local_error_4"], local_error_5: json["local_error_5"], local_error_6: json["local_error_6"], local_error_7: json["local_error_7"], local_error_8: json["local_error_8"], local_error_9: json["local_error_9"], event_error_1: json["event_error_1"], event_error_2: json["event_error_2"], join_discussion: json["join_discussion"], discussion_title: json["discussion_title"], start_discussion: json["start_discussion"], view_reply: json["view_reply"], delete: json["delete"], answer_to: json["answers_to"], reply: json["reply"], search_friends_placeholder: json["search_friends"], follow: json["follow"], unfollow: json["unfollow"], view_owner_profile: json["view_owner_profile"], review: json["review"], write_email: json["write_email"], empty_local: json["empty_local"], empty_event: json["empty_event"], username_exists: json["username_exists"], event_local_error: json["event_local_error"], invalid_address: json["invalid_address"])
                languages.append(language)
            }
        } catch {
            print("JSON-ERROR:\(error.localizedDescription)")
        }
        return languages
    }
}

