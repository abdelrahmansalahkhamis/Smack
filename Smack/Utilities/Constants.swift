//
//  Constants.swift
//  Smack
//
//  Created by abdulrahman on 9/18/18.
//  Copyright © 2018 abdulrahmanAbdou. All rights reserved.
//

import Foundation


// because web requests are asynchronous, so we don't know when the response will arrive or whether it success or not , so that we need to use completion handler

//typealias is renaming a type

/*
 let jonny = String
 let x : jonny = "fdgfhgjhn"
 */

typealias CompletionHandler = (_ Success : Bool)->()


// Url Constants

let BASE_URL = "https://abdelrahmanbooody.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"
let URL_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"     // this is used when user loges in to retreive all data
let URL_GET_CHANNELS = "\(BASE_URL)channel/"
let URL_GET_MESSAGES = "\(BASE_URL)message/byChannel/"


// Colors

let smackPurplePlaceholder = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 0.5)


// Notification Constants

let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")
let NOTIF_CHANNELS_LOADED = Notification.Name("channelsLoaded")   // when login again
let NOTIF_CHANNEL_SELECTED = Notification.Name("channelSelected")


//Segues

let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWINED = "unwindToChannel"     // from create accountVC to channelVC
let TO_AVATAR_PICKER = "toAvatarPicker"


// User Defaults

let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"


// Headers
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]

// header that contains authorization token
let BEARER_HEADER = ["Authorization":"Bearer \(AuthServices.instance.authToken)",
    "Content-Type": "application/json; charset=utf-8"
]







