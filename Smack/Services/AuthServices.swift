//
//  AuthServices.swift
//  Smack
//
//  Created by abdulrahman on 9/23/18.
//  Copyright © 2018 abdulrahmanAbdou. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// this class is going to handle all services : login, create account, as well as some other variables

class AuthServices{
    
    static let instance = AuthServices()   // singleton , one instance at atime
    
    let defaults = UserDefaults.standard  // for saving local data in the app
    
    
    
    // 3 Auth service variables
    
    var isLoggedIn : Bool{
        get{
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set{
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken : String{
        get{
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set{
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String{
        get{
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set{
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    
    /* ---------------------  registering user function   -----------------------  */
    
    func registerUser(email: String, password : String, completion: @escaping CompletionHandler){
        let lowerCaseEmail = email.lowercased()
        
        
        
        // json object of the body like in postman
        let body: [String : Any] = [
            "email" : lowerCaseEmail,
            "password" : password
        ]
        
        //  Creating the request
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            if response.result.error == nil{
                completion(true)
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    
    /* -----------------------    login user function  ---------------------------- */
    
    func loginUser(email: String, password: String, completion : @escaping CompletionHandler){
        let lowerCaseEmail = email.lowercased()
        
        
        // json object of the body like in postman
        let body: [String : Any] = [
            "email" : lowerCaseEmail,
            "password" : password
        ]
        
        
        //creating the request
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil{
                
//                if let json = response.result.value as? Dictionary<String, Any>{
//                    if let email = json["email"] as? String{
//                        self.userEmail = email
//                    }
//                    if let token = json["token"] as? String{
//                        self.authToken = token
//                    }
//
//                }
                
                // Using SwiftyJSON
                
                guard let data = response.data else {return}
                do{
                    let json = try JSON(data: data)
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                }catch {return}
                
                
                completion(true)
                self.isLoggedIn = true
            }
                else{
                completion(false)
                debugPrint("error from login user method")
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    /* -----------------------    Create user function  ---------------------------- */
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler){
        
        
        let lowerCaseEmail = email.lowercased()
        
        // json object of the body like in postman
        let body: [String : Any] = [
            "name" : name,
            "email" : lowerCaseEmail,
            "avatarName" : avatarName,
            "avatarColor" : avatarColor
        ]
        
        
        
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                
                guard let data = response.data else {return}
                
                self.setUserInfo(data: data)    
                
                completion(true)
                
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    
    // used when user loges in, in order to retreive the user's data
    
    func findUserByEmail(completion : @escaping CompletionHandler){
        Alamofire.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil{
                
                guard let data = response.data else {return}
                
                self.setUserInfo(data: data)
                
                completion(true)
                
            }else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func setUserInfo(data: Data){
        do{
            let json = try JSON(data: data)
            
            let id = json["_id"].stringValue
            let color = json["avatarColor"].stringValue
            let avatarName = json["avatarName"].stringValue
            let email = json["email"].stringValue
            let name = json["name"].stringValue
            
            UserDataService.instance.setUserData(id: id, avatarName: avatarName, color: color, email: email, name: name)
        }catch{return}
    
    }

}




