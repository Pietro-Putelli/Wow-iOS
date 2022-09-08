//
//  UploadDeviceToken.swift
//  eventsProject
//
//  Created by Pietro Putelli on 08/10/2018.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit

class Database {
    
    class func checkEmailExistence(email: String, completionHandler: @escaping (_ result: Bool) -> ()) {
        
        let downloadURL = PHP.DOMAIN + PHP.CHECK_EMAIL_EXISTENCE
        
        let requestURL = NSURL(string: downloadURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "email="+email
        
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            do {
                if let data = data {
                    guard let responseJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Bool] else { return }
                    
                    if let response = responseJSON["response"] {
                        completionHandler(response)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    class func uploadUserRegisterData(username: String, email: String, password: String) {
        
        let uploadURL = PHP.DOMAIN + PHP.USER_REGISTRATION
        
        let requestURL = NSURL(string: uploadURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "username="+username+"&email="+email+"&password="+password
        
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
        }
        UserDefaults.standard.set(false, forKey: "ALLREADY_REGISTER")
        task.resume()
    }
    
    class func downloadUserData(email: String, password: String, completionHandler: @escaping (_ result: [String:AnyObject]) -> ()) {
        
        let downloadURL = PHP.DOMAIN + PHP.USER_DATA_GET
        
        let requestURL = NSURL(string: downloadURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "email="+email+"&password="+password
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject] else { return }
                    completionHandler(rootObject)
                }
            } catch {
                print(error.localizedDescription)
                completionHandler([:])
            }
        }
        task.resume()
    }

    class func handleEventArray(email: String, url: String, completion: @escaping ([Int]) -> ()) {
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "email=\(email)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:String] else { return }
                    
                    let stringArray = rootObject["ids_array"]
                    guard let idsArray = try stringArray?.fromJSON() else { return }
                    completion(idsArray)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    class func getFavouriteLocalsArray(email: String, completion: @escaping ([[String:AnyObject]])-> ()) {
        
        let downloadURL = PHP.DOMAIN + PHP.FAV_LOCALS_GET
        let requestURL = NSURL(string: downloadURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_id="+email
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:AnyObject]] else { return }
                    completion(rootObject)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    static let cache = NSCache<NSString, UIImage>()
    
    class func downloadImage(withURL url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, responseURL, error) in
            
            var downloadedImage: UIImage?
            
            if let data = data  {
                downloadedImage = UIImage(data: data)
            }
            
            if downloadedImage != nil {
                cache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
        }
        dataTask.resume()
    }
    
    class func getImage(withURL url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image)
        } else {
            downloadImage(withURL: url, completion: completion)
        }
    }
    
    class func imageUploadRequest(imageView: UIImageView, uploadUrl: NSURL, parameters: [String:String]?, imgName: String, completion: @escaping (Bool) -> ()) {
        
        let boundary = generateBoundaryString()
        
        var request = URLRequest(url: uploadUrl as URL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(imageView.image!, 1.0)
        
        request.httpBody = createBodyWithParameters(parameters: parameters, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary, imgName: imgName) as Data
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            
            do {
                guard let responseJSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject] else { return }
                
                if let responseValue = responseJSON["uploaded"] as? Int {
                    completion(Bool(truncating: responseValue as NSNumber))
                }
                
            } catch { print(error.localizedDescription) }
        })
        task.resume()
    }
    
    class func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String, imgName: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "\(imgName).jpg"
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    class func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    class func getImagesID(id: Int, completion: @escaping ([String]) -> ()) {
        
        let url = PHP.DOMAIN + PHP.LOCAL_IMAGE_IDS_GET
        
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "id=" + String(id)
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:[String]] else { return }
                    completion(rootObject["imageIDs"]!)
                    
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    class func deleteImgae(id: Int, index: Int, email: String) {
        
        let url = PHP.DOMAIN + PHP.LOCAL_IMAGE_IDS_SET
        
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "id=" + String(id) + "&index=" + String(index) + "&email=" + email
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
        }
        task.resume()
    }
    
    class func downloadLocalsByID(id: Int, completion: @escaping ([String:AnyObject]) -> ()) {
        
        let uploadURL = PHP.DOMAIN + PHP.LOCAL_EVENT_GET
        
        let requestURL = NSURL(string: uploadURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "id=" + String(id)
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] else { return }
                    completion(rootObject)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }

    class func uploadSelectedFriendToken(userEmail: String, friendEmail: String, addElement: Int) {
        
        let uploadURL = PHP.DOMAIN + PHP.USER_FRIEND_TOKEN_SET
        
        let requestURL = NSURL(string: uploadURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "email=" + userEmail + "&friendEmail=" + friendEmail + "&addElement" + String(addElement)
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
        }
        task.resume()
    }
    
    class func uploadUserDeviceToken(email: String, deviceToken: String) {
        
        let uploadURL = PHP.PUSH_NOTIFICATION_DOMAIN + PHP.USER_TOKEN_SET
        
        let requestURL = NSURL(string: uploadURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "email="+email+"&deviceToken="+deviceToken
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
        }
        task.resume()
    }
    
    class func setFollow(email: String, friendID: Int, addElement: Int) {
        
        let uploadURL = PHP.DOMAIN + PHP.USER_FRIEND_SET
        
        let requestURL = NSURL(string: uploadURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "email=" + email + "&friendID=" + String(friendID) + "&addElement=" + String(addElement)
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        print(postParameters)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
        }
        task.resume()
    }
    
    class func sendConfirmEmail(email:String) {
        
        let uploadURL = PHP.DOMAIN + PHP.SEND_CONFIRM_EMAIL
        let requestURL = NSURL(string: uploadURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "email="+email
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
        }
        task.resume()
    }
    
    class func getLocalsByOwner(owner: String, completionHandler: @escaping (_ result: [[String:AnyObject]]) -> ()) {
        
        let url = PHP.DOMAIN + PHP.USER_LOCALS_GET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "owner=" + String(owner)
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:AnyObject]] else { return }
                    completionHandler(rootObject)
                }
        } catch {
            }
        }
        task.resume()
    }
    
    class func getEventsByOwner(owner: String, completionHandler: @escaping (_ result: [[String:AnyObject]]) ->()) {
        
        let url = PHP.DOMAIN + PHP.USER_EVENTS_GET
        
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "owner=" + owner
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:AnyObject]] else { return }
                    completionHandler(rootObject)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    class func getTopLocals(latitudeFrom: Double, longitudeFrom: Double, const: Int, completion: @escaping ([[String:AnyObject]]) -> ()) {
        
        let url = PHP.DOMAIN + PHP.LOCAL_TOP_GET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "latitudeFrom=" + String(latitudeFrom) + "&longitudeFrom=" + String(longitudeFrom) + "&const=" + String(const)
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:AnyObject]] else { return }
                    completion(rootObject)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    class func getTopEvents(latitudeFrom: Double, longitudeFrom: Double, const: Int, completion: @escaping ([[String:AnyObject]]) -> ()) {
        
        let url = PHP.DOMAIN + PHP.EVENT_TOP_GET
        
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "latitudeFrom=" + String(latitudeFrom) + "&longitudeFrom=" + String(longitudeFrom) + "&const=" + String(const)
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:AnyObject]] else { return }
                    completion(rootObject)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    class func getLocalsByCoordinate(latitudeFrom: Double, longitudeFrom: Double, maxDistance: Double, const: Int, completion: @escaping ([[String:AnyObject]]) -> ()) {
        let url = PHP.DOMAIN + PHP.LOCAL_AREA_GET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "latitudeFrom=\(String(latitudeFrom))&longitudeFrom=\(String(longitudeFrom))&maxDistance=\(String(maxDistance))&const=\(String(const))"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let date = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: date, options: .allowFragments) as? [[String:AnyObject]] else { return }
                    completion(rootObject)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    class func getEventsByCoordinate(latitudeFrom: Double, longitudeFrom: Double, maxDistance: Double, const: Int, completion: @escaping ([[String:AnyObject]]) -> ()) {
        let url = PHP.DOMAIN + PHP.EVENT_AREA_GET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "latitudeFrom=\(String(latitudeFrom))&longitudeFrom=\(String(longitudeFrom))&maxDistance=\(String(maxDistance))&const=\(String(const))"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:AnyObject]] else { return }
                    completion(rootObject)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    class func getLocalReviews(id: Int, completion: @escaping ([[String:String]]) -> ()) {

        let url = PHP.DOMAIN + PHP.LOCAL_REVIEWS_GET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "id=" + String(id)
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:String]] else { return }
                    completion(rootObject)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    class func getLocalEvents(id: Int, completion: @escaping ([[String:AnyObject]]) -> ()) {
        let url = PHP.DOMAIN + PHP.LOCAL_EVENTS_GET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "id=" + String(id)
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:AnyObject]] else { return }
                    completion(rootObject)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    class func handleEventGoing(user_id: String, event_id: Int, url: String) {
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_id=" + user_id + "&event_id=" + String(event_id)
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func handleFavLocals(user_id: String, local_id: Int, url: String) {
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_id=" + user_id + "&local_id=" + String(local_id)
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func handleFavEvents(user_id: String, event_id: Int, url: String) {
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_id=" + user_id + "&event_id=" + String(event_id)
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func getUserFriends(email: String, completion: @escaping ([[String:AnyObject]]) -> ()) {
        let url = PHP.DOMAIN + PHP.USER_FRIENDS_GET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_id=" + email
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:AnyObject]] else { return }
                    completion(rootObject)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    class func getUserFollowers(friend_id: Int, completion: @escaping ([[String:AnyObject]]) -> ()) {
        let url = PHP.DOMAIN + PHP.USER_FOLLOWERS_GET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "friend_id=\(friend_id)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:AnyObject]] else { return }
                    completion(rootObject)
                }
            } catch {
                print("FOLLOWERS\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func getFriends(for search: String, user_email: String, completion: @escaping ([[String:AnyObject]]) -> ()) {
        let uploadURL = PHP.DOMAIN + PHP.USERS_SEARCH_GET
        let requestURL = NSURL(string: uploadURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "searchText=\(search)&user_email=\(user_email)"
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:AnyObject]] else { return }
                    completion(rootObject)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    class func setUserFriend(user_email: String, friend_id: Int, url: String) {
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_email=" + user_email + "&friend_id=" + String(friend_id)
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func checkUserFollowing(user_email: String, friend_id: Int, completion: @escaping (Bool) -> ()) {
        let requestURL = NSURL(string: PHP.DOMAIN + PHP.USER_CHECK_FOLLOWING)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_email=" + user_email + "&friend_id=" + String(friend_id)
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] else { return }
                    
                    if let isFollowing = json["following"] as? Bool {
                        completion(isFollowing)
                    }
                }
            } catch {
                print("CFOLLOWING-\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func checkFavLocal(user_email: String, local_id: Int, completion: @escaping (Bool) -> ()) {
        let requestURL = NSURL(string: PHP.DOMAIN + PHP.FAV_LOCAL_CHECK)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_id=" + user_email + "&local_id=" + String(local_id)
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] else { return }
                    
                    if let isFavourite = json["favourite"] as? Bool {
                        completion(isFavourite)
                    }
                }
            } catch {
                print("CFAVOURITE-\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func checkLikeGoingEvent(user_id: String, event_id: Int, url: String, completion: @escaping (Bool) -> ()) {
        let requestURL = NSURL(string: PHP.DOMAIN + url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_id=" + user_id + "&event_id=" + String(event_id)
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] else { return }
                    
                    if let isFavourite = json["bool"] as? Bool {
                        completion(isFavourite)
                    }
                }
            } catch {
                print("LGEVENT-\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func delete(id: Int, url: String) {
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "id=" + String(id)
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func uploadLocal(latitude: Double, longitude: Double, owner: String, json: String, completion: @escaping (Int) -> ()) {
        
        let uploadURL = PHP.DOMAIN + PHP.LOCAL_SET
        let requestURL = NSURL(string: uploadURL)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "latitude=\(String(latitude))&longitude=\(String(longitude))&owner=\(owner)&json=\(json)"
        print(postParameters)
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in

            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] else { return }
                    if let id = rootObject["id"] as? String {
                        completion(Int(id)!)
                    }
                }
            } catch {
                print("INSERT:\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func updateLocal(latitude: Double, longitude: Double, owner: String, id: Int, json: String) {
        
        let url = PHP.DOMAIN + PHP.LOCAL_UPDATE
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "latitude=\(String(latitude))&longitude=\(String(longitude))&owner=\(owner)&id=\(id)&json=\(json)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func uploadEvent(latitude: Double, longitude: Double, owner: String, id: Int, to_date: String, json: String, completion: @escaping (Int) -> ()) {
        let url = PHP.DOMAIN + PHP.EVENT_SET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "latitude=\(String(latitude))&longitude=\(String(longitude))&setupby=\(owner)&id=\(id)&to_date=\(to_date)&json=\(json)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] else { return }
                    if let id = rootObject["id"] as? String {
                        completion(Int(id)!)
                        print(id)
                    }
                }
            } catch {
                print("UPLOAD-E\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func updateEvent(latitude: Double, longitude: Double, owner: String, id: Int, local_id: Int, to_date: String, json: String) {
        let url = PHP.DOMAIN + PHP.EVENT_UPDATE
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "latitude=\(String(latitude))&longitude=\(String(longitude))&owner=\(owner)&id=\(id)&local_id=\(local_id)&to_date=\(to_date)&json=\(json)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func getLocals(user_email: String, completion: @escaping ([LocalObject]) -> ()) {
        
        var locals = [LocalObject]()
        let url = PHP.DOMAIN + PHP.USER_LOCALS_GET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "owner=\(user_email)"
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:AnyObject]] else { return }
                    
                    for json in rootObject {
                        
                        if let id = json["id"] as? String,
                            let json = json["json_local"] as? String {
                            
                            if let json = json.toJSON() as? [String:AnyObject] {
                                if let title = json["title"] as? String {
                                    let local = LocalObject(id: Int(id)!, title: title)
                                    locals.append(local)
                                }
                            }
                        }
                    }
                    completion(locals)
                }
            } catch {
                print("GET-LOCALS\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func uploadReview(local_id: Int, rating: Int, user_name: String, user_email: String, date: String, review_json: String) {
        let url = PHP.DOMAIN + PHP.LOCAL_REVIEWS_SET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
    
        let postParametes = "user_name=\(user_name)&user_email=\(user_email)&local_id=\(local_id)&rating=\(rating)&date=\(date)&json_data=\(review_json)"
        request.httpBody = postParametes.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func checkReviewExistence(user_email: String, local_id: Int, completion: @escaping (Bool) -> ()) {
        let url = PHP.DOMAIN + PHP.LOCAL_CHECK_REVIEW_EXISTENCE
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_email=\(user_email)&local_id=\(local_id)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Int] else { return }
                    let isReviewExiste = Bool(truncating: rootObject["reviewExiste"]! as NSNumber)
                    completion(isReviewExiste)
                }
            } catch {
                print("EMAIL-EXISTENCE\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func checkDiscussionExistence(user_email: String, event_id: Int, completion: @escaping (Bool) -> ()) {
        let url = PHP.DOMAIN + PHP.EVENT_CHECK_DISCUSSION_EXISTENCE
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_email=\(user_email)&event_id=\(event_id)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Int] else { return }
                    let isDiscussionExiste = Bool(truncating: rootObject["discussionExiste"]! as NSNumber)
                    completion(isDiscussionExiste)
                }
            } catch {
                print("C-DISCUSSIONS\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func deleteReview(user_email: String, local_id: Int, rating: Int) {
        let url = PHP.DOMAIN + PHP.LOCAL_DELETE_REVIEW
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_email=\(user_email)&local_id=\(local_id)&rating=\(rating)"
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
        }
        task.resume()
    }
    
    class func getLocalRating(local_id: Int, completion: @escaping (Int) -> ()) {
        let url = PHP.DOMAIN + PHP.LOCAL_RATING_GET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "local_id=\(local_id)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] else { return }
                    
                    if let rating = rootObject["rating"] as? Double {
                        completion(Int(rating))
                    }
                }
            } catch {
                print("LOCAL-RATING\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func setLocalRating(url: String, local_id: Int, rating: Int) {
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "local_id=\(local_id)&rating=\(rating)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func resetPassword(user_email: String) {
        let url = PHP.DOMAIN + PHP.USER_RESET_PASSWORD
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "email=\(user_email)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func uploadUsername(user_name: String, user_email: String) {
        let url = PHP.DOMAIN + PHP.USER_NAME_SET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParamters = "username=\(user_name)&email=\(user_email)"
        request.httpBody = postParamters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func uploadUserStatus(user_status: String, user_email: String) {
        let url = PHP.DOMAIN + PHP.USER_STATUS_SET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParamters = "status=\(user_status)&email=\(user_email)"
        request.httpBody = postParamters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func uploadUserPassword(user_password: String, user_email: String) {
        let url = PHP.DOMAIN + PHP.USER_PASSWORD_SET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParamters = "password=\(user_password)&email=\(user_email)"
        request.httpBody = postParamters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func checkUserPassword(user_email: String, user_password: String, new_password: String, completion: @escaping (Bool) -> ()) {
        let url = PHP.DOMAIN + PHP.USER_CHECK_PASSWORD
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_email=\(user_email)&new_password=\(new_password)&user_password=\(user_password)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let responseJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Bool] else { return }
                    
                    if let response = responseJSON["response"] {
                        completion(response)
                    }
                }
            } catch {
                print("CHECKPASS\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func uploadBuisnessData(user_email: String, buisness_phone: String, buisness_web: String, buisness_email: String) {
        let url = PHP.DOMAIN + PHP.USER_PASSWORD_SET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParamters = "password=\(resetPassword)&email=\(user_email)"
        request.httpBody = postParamters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func sendEventGoingNotification(user_id: String, event_id: Int, message_content: String) {
        let url = PHP.PUSH_NOTIFICATION_DOMAIN + PHP.FRIEND_EVENT_NOTIFICATION
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParamters = "user_id=\(user_id)&event_id=\(event_id)&content=\(message_content)"
        request.httpBody = postParamters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func sendFollowNotification(user_id: String, message_content: String, target: Int) {
        let url = PHP.PUSH_NOTIFICATION_DOMAIN + PHP.FOLLOW_NOTIFICATION
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParamters = "user_id=\(user_id)&content=\(message_content)&target=\(target)"
        request.httpBody = postParamters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func sendReplyNotification(target_id: String, event_id: Int, discussion_id: Int, message_content: String) {
        let url = PHP.PUSH_NOTIFICATION_DOMAIN + PHP.REPLY_NOTIFICATION
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "target_id=\(target_id)&event_id=\(event_id)&discussion_id=\(discussion_id)&content=\(message_content)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func sendNewEventNotification(local_id: Int, event_id: Int, message_content: String) {
        let url = PHP.PUSH_NOTIFICATION_DOMAIN + PHP.EVENT_NOTIFICATION
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "local_id=\(local_id)&event_id=\(event_id)&content=\(message_content)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func getUserFollowersNumber(friend_id: Int, completion: @escaping (Int) -> ()) {
        let url = PHP.DOMAIN + PHP.USER_FOLLOWERS_NUM_GET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "friend_id=\(friend_id)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] else { return }
                    
                    if let followers = rootObject["followers"] as? String {
                        let followers_int = Int(followers)!
                        completion(followers_int)
                    }
                }
            } catch {
                print("FOLLOWERS\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func getuserFollowingNumber(user_id: String, completion: @escaping (Int) -> ()) {
        let url = PHP.DOMAIN + PHP.USER_FOLLOWING_NUM_GET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_id=\(user_id)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] else { return }
                    
                    if let following = rootObject["following"] as? String {
                        let following_int = Int(following)!
                        completion(following_int)
                    }
                }
            } catch {
                print("FOLLOWING\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func uploadBusinessInfo(user_id: String, email: String, web_site: String, phone_number: String) {
        let url = PHP.DOMAIN + PHP.USER_BUSINESS_INFO
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParamters = "user_id=\(user_id)&email=\(email)&web_site=\(web_site)&phone_number=\(phone_number)"
        request.httpBody = postParamters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func uploadEventDiscussion(user_name: String, user_email: String, event_id: Int, date: String, discussion_json: String) {
        let url = PHP.DOMAIN + PHP.EVENT_DISCUSSION_SET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_name=\(user_name)&user_email=\(user_email)&event_id=\(event_id)&date=\(date)&discussion_json=\(discussion_json)"
        print(postParameters)
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func uploadEventDiscussionAnswer(discussion_id: Int, user_name: String, user_email: String, date: String, answer_json: String) {
        let url = PHP.DOMAIN + PHP.EVENT_DISCUSSION_REPLY_SET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParamters = "discussion_id=\(discussion_id)&user_name=\(user_name)&user_email=\(user_email)&date=\(date)&answer_json=\(answer_json)"
        request.httpBody = postParamters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }

    class func downloadEventDiscussion(event_id: Int, completion: @escaping ([[String:String]]) -> ()) {
        let url = PHP.DOMAIN + PHP.EVENT_DISCUSSION_GET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "event_id=\(event_id)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:String]] else { return }
                    completion(rootObject)
                }
            } catch {
                print("D-DISCUSSIONS\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func deleteDiscussion(discussion_id: Int) {
        let url = PHP.DOMAIN + PHP.EVENT_DELETE_DISCUSSION
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "discussion_id=\(discussion_id)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func downloadEventDiscussionAnswer(discussion_id: Int, completion: @escaping ([[String:String]]) -> ()) {
        let url = PHP.DOMAIN + PHP.EVENT_REPLYES_GET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "discussion_id=\(discussion_id)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:String]] else { return }
                    completion(rootObject)
                }
            } catch {
                print("ANSWER-\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func deleteEventDiscussionReply(user_email: String, discussion_id: Int, answer_id: Int) {
        let url = PHP.DOMAIN + PHP.EVENT_REPLY_DELETE
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_email=\(user_email)&discussion_id=\(discussion_id)&answer_id=\(answer_id)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func getLocalLikes(local_id: Int, completion: @escaping (Int) -> ()) {
        let url = PHP.DOMAIN + PHP.LOCAL_LIKES_GET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "local_id=\(local_id)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:String] else { return }
                    completion(Int(rootObject["likes"]!)!)
                }
            } catch {
                print("LIKES-D\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func getEventLikesGoing(event_id: Int, completion: @escaping ([Int]) -> ()) {
        let url = PHP.DOMAIN + PHP.EVENT_GOING_LIKE_GET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "event_id=\(event_id)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:String] else { return }
                    let going_int = Int(rootObject["going"]!)!
                    let likes_int = Int(rootObject["likes"]!)!
                    let completion_array = [going_int,likes_int]
                    completion(completion_array)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    class func getFriendByEmail(user_email: String, completion: @escaping ([String:AnyObject]) -> ()) {
        let url = PHP.DOMAIN + PHP.FRIEND_BY_EMAIL_GET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_email=\(user_email)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] else { return }
                    completion(rootObject)
                }
            } catch {
                print("FRIEND-BY-EMAIL\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func setUserLogged(user_email: String, user_logged: Int) {
        let url = PHP.DOMAIN + PHP.USER_LOGGED_SET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_email=\(user_email)&user_logged=\(user_logged)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func setNotification(user_email: String, type: Int) {
        let url = PHP.DOMAIN + PHP.USER_NOTIFICATIONS_SET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParamters = "user_email=\(user_email)&type=\(type)"
        request.httpBody = postParamters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func report(target_id: Int, type: Int) {
        let url = PHP.DOMAIN + PHP.REPORT
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "target_id=\(target_id)&type=\(type)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func getNotificationSettings(user_email: String, completion: @escaping ([Bool]) -> ()) {
        var responses = [Bool]()
        let url = PHP.DOMAIN + PHP.USER_NOTIFICATIONS_SETTINGS_GET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_email=\(user_email)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] else { return }
                    
                    let array = rootObject["notification_settings"] as! [Int]
                    
                    for integer in array {
                        let boolValue = Bool(truncating: integer as NSNumber)
                        responses.append(boolValue)
                    }
                    completion(responses)
                }
            } catch {
                print("NOTIFICATIONS_SETTINGS\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func setNotificationSettings(user_email: String, notification_settings: [Int]) {
        let url = PHP.DOMAIN + PHP.USER_NOTIFICATIONS_SETTINGS_SET
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
            
        let postParameters = "user_email=\(user_email)&n1=\(notification_settings.first!)&n2=\(notification_settings[1])&n3=\(notification_settings[2])&n4=\(notification_settings.last!)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func sendReportEmail(id: Int, type: Int) {
        let url = PHP.DOMAIN + PHP.SEND_REPOT_EMAIL
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "id=\(id)&type=\(type)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
        }
        task.resume()
    }
    
    class func checkUserExistence(user_email: String, completion: @escaping (Bool) -> ()) {
        let url = PHP.DOMAIN + PHP.USER_CHECK_EXISTENCE
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_email=\(user_email)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Bool] else { return }
                    completion(json["response"]!)
                }
            } catch {
                print("UCEXISTENCE\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    class func checkUserUniqueName(user_name: String, completion: @escaping (Bool) -> ()) {
        let url = PHP.DOMAIN + PHP.USER_UNIQUE_NAME
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "POST"
        
        let postParameters = "user_name=\(user_name)"
        request.httpBody = postParameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            do {
                if let data = data {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Bool] else { return }
                    completion(json["response"]!)
                }
            } catch {
                print("UU\(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
