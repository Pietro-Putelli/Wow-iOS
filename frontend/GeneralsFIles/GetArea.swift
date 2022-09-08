//
//  GetArea.swift
//  eventsProject
//
//  Created by Pietro Putelli on 14/09/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class GetArea {
    
    func getLocalsFromDB(latitudeFrom: Double, longitudeFrom: Double, maxDistance: Double) {
        
        let url = PHP.DOMAIN + PHP.LOCAL_AREA_GET
        var rootObject = [[String:AnyObject]]()
        
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "latitudeFrom=" + String(latitudeFrom) + "&longitudeFrom=" + String(longitudeFrom) + "&maxDistance=" + String(maxDistance)
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            do {
                
                if data != nil {
                    rootObject = (try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String:AnyObject]])!
                }
                
                for localObject in rootObject {
                    
                    if let id = localObject["id"] as? String,
                        let jsonLocal = localObject["json_local"] as? String {
                        
                        if let rootJsonObject = jsonLocal.toJSON() as? [String:AnyObject] {
                                
                        }
                    }
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}




