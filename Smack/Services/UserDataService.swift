//
//  UserDataService.swift
//  Smack
//
//  Created by abdulrahman on 9/25/18.
//  Copyright © 2018 abdulrahmanAbdou. All rights reserved.
//

import Foundation



// this class is for creating the user after registering and loged in
class UserDataService{
    
    static let instance = UserDataService()
    
    public private(set) var id = ""
    public private(set) var avatarName = ""
    public private(set) var avatarColor = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    
    
    // initializing user data
    
    func setUserData(id: String, avatarName: String, color: String, email: String, name:String){
        self.id = id
        self.avatarName = avatarName
        self.avatarColor = color
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName: String){
        self.avatarName = avatarName
    }
    
    
    // returning the background color of the avatar image from mlab database that was generated while creating account
    func returnUIColor(components: String)->UIColor{
        
        // "[0.847058823529412, 0.952941176470588, 0.0196078431372549, 1]"
        
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ]")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var r,g,b,a : NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        
        let defaultColor = UIColor.lightGray // default color in case we faild
        
        guard let rUnwrapped = r else {return defaultColor}
        guard let gUnwrapped = g else {return defaultColor}
        guard let bUnwrapped = b else {return defaultColor}
        guard let aUnwrapped = a else {return defaultColor}
        
        let rfloat = CGFloat(rUnwrapped.doubleValue)
        let gfloat = CGFloat(gUnwrapped.doubleValue)
        let bfloat = CGFloat(bUnwrapped.doubleValue)
        let afloat = CGFloat(aUnwrapped.doubleValue)
        
        let newUIColor = UIColor(red: rfloat, green: gfloat, blue: bfloat, alpha: afloat)
        
        return newUIColor
    }
    
    func logoutUser(){
        id = ""
        avatarName = ""
        avatarColor = ""
        name = ""
        email = ""
        AuthServices.instance.isLoggedIn = false
        AuthServices.instance.authToken = ""
        AuthServices.instance.userEmail = ""
        
        MessageService.instance.clearChannels()
        MessageService.instance.clearMessages()
    }
    
}

















