//
//  ObjectModels.swift
//  eventsProject
//
//  Created by Pietro Putelli on 17/09/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

struct Local: Codable {
    
    let id: Int?
    let city: String
    var title: String
    var subtitle: String
    var timetable: [String]
    var address: String
    var details: String
    var music: String?
    var place: String?
    var quickInfo: [Int]
    var phoneNumber: String
    var webSite: String?
    var email: String?
    var likes: Int
    
    var parkingInfo: String?
    var ptInfo: String?
    var nearInfo: String?
    var moreInfo: String?

    var rating: Int
    var owner: String
    var numberOfReviews: Int
}

struct Event: Codable {
    
    var id: Int?
    var local_id: Int
    var owner: String
    
    var title: String
    var address: String
    var place: String?
    var city: String
    var details: String
    
    var going: Int
    var likes: Int
    
    var fromDate: String
    var toDate: String
    var atDate: String
    
    var setUpBy: String
    var music: String
    var vip: String?
    var price: String?
    
    var phone: String
    var webSite: String?
    var email: String?
    var ticket: String?
    
    var parking: String?
    var publicTransport: String?
    var near: String?
    var info: String?
}

struct Friend: Codable {
    
    var id: Int
    var email: String
    var username: String
    var followers: String
    var following: String
    var status: String
    
    var phone: String
    var businessEmail: String
    var webSite: String
}

struct ReviewJSON: Codable {
    var title: String
    var content: String
}

struct Review {
    
    var id: Int
    var username: String
    var email: String
    var title: String
    var content: String
    var starsRating: Int
    var date: String
}

struct Discussion {
    
    var id: Int
    var username: String
    var email: String
    var title: String
    var content: String
    var date: String
}






