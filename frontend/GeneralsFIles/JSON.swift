//
//  JSON.swift
//  eventsProject
//
//  Created by Pietro Putelli on 10/11/2018.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import Foundation
import UIKit

class JSON {
    
    class func parseSingleLocal(json: [String:AnyObject]) -> Local {
        var local: Local!
                
        if let id = json["id"] as? String,
            let jsonLocal = json["json_local"] as? String,
            let rating = json["rating"] as? String,
            let owner = json["owner"] as? String,
            let likes = json["likes"] as? String,
            let numberOfReviews = json["reviews"] as? Int {
            
            if let rootJsonObject = jsonLocal.toJSON() as? [String:AnyObject] {
                if let title = rootJsonObject["title"] as? String,
                    let subtitle = rootJsonObject["subtitle"] as? String,
                    let timetable = rootJsonObject["timetable"] as? [String],
                    let address = rootJsonObject["address"] as? String,
                    let city = rootJsonObject["city"] as? String,
                    let details = rootJsonObject["details"] as? String,
                    let quikInfo = rootJsonObject["quickInfo"] as? [Int],
                    let music = rootJsonObject["music"] as? String,
                    let place = rootJsonObject["place"] as? String,
                    let phone = rootJsonObject["phoneNumber"] as? String,
                    let webSite = rootJsonObject["webSite"] as? String,
                    let email = rootJsonObject["email"] as? String,
                    let parkingInfo = rootJsonObject["parkingInfo"] as? String,
                    let ptInfo = rootJsonObject["ptInfo"] as? String,
                    let near = rootJsonObject["nearInfo"] as? String,
                    let moreInfo = rootJsonObject["moreInfo"] as? String
                {
                    let doubleRating = Double(rating)!
                    
                    local = Local(id: Int(id), city: city, title: title, subtitle: subtitle, timetable: timetable, address: address, details: details, music: music, place: place, quickInfo: quikInfo, phoneNumber: phone, webSite: webSite, email: email,likes: Int(likes)!, parkingInfo: parkingInfo, ptInfo: ptInfo, nearInfo: near, moreInfo: moreInfo, rating: Int(doubleRating), owner: owner, numberOfReviews: numberOfReviews)
                }
            }
        }
        return local
    }

    class func parseSingleEvent(json: [String:AnyObject]) -> Event {
        var event: Event!
        
        if let id = json["id"] as? String,
            let localID = json["local_id"] as? String,
            let owner = json["owner"] as? String,
            let going = json["going"] as? String,
            let likes = json["likes"] as? String,
            let jsonEvent = json["json_event"] as? String {
            
            if let rootJsonObject = jsonEvent.toJSON() as? [String:AnyObject] {
                if let title = rootJsonObject["title"] as? String,
                    let place = rootJsonObject["place"] as? String,
                    let city = rootJsonObject["city"] as? String,
                    let details = rootJsonObject["details"] as? String,
                    let setupby = rootJsonObject["setUpBy"] as? String,
                    let music = rootJsonObject["music"] as? String,
                    let vip = rootJsonObject["vip"] as? String,
                    let price = rootJsonObject["price"] as? String,
                    let phone = rootJsonObject["phone"] as? String,
                    let webSite = rootJsonObject["webSite"] as? String,
                    let email = rootJsonObject["email"] as? String,
                    let ticket = rootJsonObject["ticket"] as? String,
                    let parking = rootJsonObject["parking"] as? String,
                    let ptInfo = rootJsonObject["publicTransport"] as? String,
                    let nearInfo = rootJsonObject["near"] as? String,
                    let moreInfo = rootJsonObject["info"] as? String,
                    let address = rootJsonObject["address"] as? String,
                    let fromDate = rootJsonObject["fromDate"] as? String,
                    let toDate = rootJsonObject["toDate"] as? String,
                    let atDate = rootJsonObject["atDate"] as? String {
                    
                    event = Event.init(id: Int(id), local_id: Int(localID)!, owner: owner, title: title, address: address, place: place, city: city, details: details, going: Int(going)!, likes: Int(likes)!, fromDate: fromDate, toDate: toDate, atDate: atDate, setUpBy: setupby, music: music, vip: vip, price: price, phone: phone, webSite: webSite, email: email, ticket: ticket, parking: parking, publicTransport: ptInfo, near: nearInfo, info: moreInfo)
                }
            }
        }
        return event
    }
    
    class func parseArrayLocal(json: [[String:AnyObject]]) -> [Local] {
        var locals = [Local]()

        for localObject in json {
            
            if let id = localObject["id"] as? String,
                let jsonLocal = localObject["json_local"] as? String,
                let rating = localObject["rating"] as? String,
                let owner = localObject["owner"] as? String,
                let likes = localObject["likes"] as? String,
                let numberOfReviews = localObject["reviews"] as? Int {
                
                if let rootJsonObject = jsonLocal.toJSON() as? [String:AnyObject] {
                    if let title = rootJsonObject["title"] as? String,
                        let subtitle = rootJsonObject["subtitle"] as? String,
                        let timetable = rootJsonObject["timetable"] as? [String],
                        let address = rootJsonObject["address"] as? String,
                        let city = rootJsonObject["city"] as? String,
                        let details = rootJsonObject["details"] as? String,
                        let quikInfo = rootJsonObject["quickInfo"] as? [Int],
                        let music = rootJsonObject["music"] as? String,
                        let place = rootJsonObject["place"] as? String,
                        let phone = rootJsonObject["phoneNumber"] as? String,
                        let webSite = rootJsonObject["webSite"] as? String,
                        let email = rootJsonObject["email"] as? String,
                        let parkingInfo = rootJsonObject["parkingInfo"] as? String,
                        let ptInfo = rootJsonObject["ptInfo"] as? String,
                        let near = rootJsonObject["nearInfo"] as? String,
                        let moreInfo = rootJsonObject["moreInfo"] as? String
                    {
                        let doubleRating = Double(rating)!
                        
                        let local = Local(id: Int(id), city: city, title: title, subtitle: subtitle, timetable: timetable, address: address, details: details, music: music, place: place, quickInfo: quikInfo, phoneNumber: phone, webSite: webSite, email: email,likes: Int(likes)!, parkingInfo: parkingInfo, ptInfo: ptInfo, nearInfo: near, moreInfo: moreInfo, rating: Int(doubleRating), owner: owner, numberOfReviews: numberOfReviews)
                        locals.append(local)
                    }
                }
            }
        }
        return locals
    }
    
    class func parseArrayEvent(json: [[String:AnyObject]]) -> [Event] {
        var events = [Event]()
        
        for eventObject in json {
            
            if let id = eventObject["id"] as? String,
                let localID = eventObject["local_id"] as? String,
                let owner = eventObject["owner"] as? String,
                let going = eventObject["going"] as? String,
                let likes = eventObject["likes"] as? String,
                let jsonEvent = eventObject["json_event"] as? String {
                
                if let rootJsonObject = jsonEvent.toJSON() as? [String:AnyObject] {
                    if let title = rootJsonObject["title"] as? String,
                        let place = rootJsonObject["place"] as? String,
                        let city = rootJsonObject["city"] as? String,
                        let details = rootJsonObject["details"] as? String,
                        let setupby = rootJsonObject["setUpBy"] as? String,
                        let music = rootJsonObject["music"] as? String,
                        let vip = rootJsonObject["vip"] as? String,
                        let price = rootJsonObject["price"] as? String,
                        let phone = rootJsonObject["phone"] as? String,
                        let webSite = rootJsonObject["webSite"] as? String,
                        let email = rootJsonObject["email"] as? String,
                        let ticket = rootJsonObject["ticket"] as? String,
                        let parking = rootJsonObject["parking"] as? String,
                        let ptInfo = rootJsonObject["publicTransport"] as? String,
                        let nearInfo = rootJsonObject["near"] as? String,
                        let moreInfo = rootJsonObject["info"] as? String,
                        let address = rootJsonObject["address"] as? String,
                        let fromDate = rootJsonObject["fromDate"] as? String,
                        let toDate = rootJsonObject["toDate"] as? String,
                        let atDate = rootJsonObject["atDate"] as? String {
                        
                        let event = Event.init(id: Int(id), local_id: Int(localID)!, owner: owner, title: title, address: address, place: place, city: city, details: details, going: Int(going)!, likes: Int(likes)!, fromDate: fromDate, toDate: toDate, atDate: atDate, setUpBy: setupby, music: music, vip: vip, price: price, phone: phone, webSite: webSite, email: email, ticket: ticket, parking: parking, publicTransport: ptInfo, near: nearInfo, info: moreInfo)
                        events.append(event)
                    }
                }
            }
        }
        return events
    }
    
    class func parseReview(rootObject: [[String:String]]) -> [Review] {
        var reviews = [Review]()
        
        for json in rootObject {
            if let id = json["id"],
                let username = json["username"],
                let useremail = json["useremail"],
                let rating = json["rating"],
                let date = json["date"],
                let reviewJSONString = json["reviewJSON"] {
                
                if let reviewJSON = reviewJSONString.toJSON() as? [String:AnyObject] {
                    if let title = reviewJSON["title"] as? String,
                        let content = reviewJSON["content"] as? String {
                        
                        let review = Review.init(id: Int(id)!, username: username, email: useremail, title: title, content: content, starsRating: Int(rating)!, date: date)
                        reviews.append(review)
                    }
                }
            }
        }
        return reviews
    }
    
    class func parseDiscussion(rootObject: [[String:String]]) -> [Discussion] {
        var discussions = [Discussion]()
        
        for json in rootObject {
            if let user_name = json["user_name"],
                let user_email = json["user_email"],
                let discussion_json = json["discussion_json"],
                let date = json["date"],
                let id = json["id"] {
                
                if let discussionJSON = discussion_json.toJSON() as? [String:String] {
                    if let title = discussionJSON["title"],
                        let content = discussionJSON["content"] {
                        
                        let discussion = Discussion.init(id: Int(id)!,username: user_name, email: user_email, title: title, content: content, date: date)
                        discussions.append(discussion)
                    }
                }
            }
        }
        return discussions
    }
    
    class func parseSingleDiscussion(json: [String:AnyObject]) -> Discussion {
        var discussion: Discussion!
        if let user_name = json["user_name"] as? String,
            let user_email = json["user_email"] as? String,
            let discussion_json = json["discussion_json"] as? String,
            let id = json["id"] as? Int,
            let date = json["date"] as? String {
            
            if let discussionJSON = discussion_json.toJSON() as? [String:String] {
                if let title = discussionJSON["title"],
                    let content = discussionJSON["content"] {
                    
                    discussion = Discussion.init(id: id,username: user_name, email: user_email, title: title, content: content, date: date)
                }
            }
        }
        return discussion
    }
    
    class func parseArrayFriend(json: [[String:AnyObject]]) -> [Friend] {
        var friends = [Friend]()
        
        for friendObject in json {
            if let id = friendObject["id"] as? String,
                let email = friendObject["email"] as? String,
                let username = friendObject["username"] as? String,
                let followers = friendObject["followers"] as? String,
                let following = friendObject["following"] as? String,
                let status = friendObject["status"] as? String,
                let phone = friendObject["phone"] as? String,
                let businessEmail = friendObject["businessEmail"] as? String,
                let webSite = friendObject["webSite"] as? String
            {
                let friend = Friend(id: Int(id)!, email: email, username: username, followers: followers, following: following, status: status, phone: phone, businessEmail: businessEmail, webSite: webSite)
                friends.append(friend)
            }
        }
        return friends
    }
    
    class func parseFriend(json: [String:AnyObject]) -> Friend {
        var friend: Friend!
        
        if let id = json["id"] as? String,
            let email = json["email"] as? String,
            let username = json["username"] as? String,
            let followers = json["followers"] as? String,
            let following = json["following"] as? String,
            let status = json["status"] as? String,
            let phone = json["phone"] as? String,
            let businessEmail = json["businessEmail"] as? String,
            let webSite = json["webSite"] as? String
        {
            friend = Friend(id: Int(id)!, email: email, username: username, followers: followers, following: following, status: status, phone: phone, businessEmail: businessEmail, webSite: webSite)
        }
        return friend
    }
}

