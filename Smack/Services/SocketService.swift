//
//  SocketService.swift
//  Smack
//
//  Created by abdulrahman on 9/28/18.
//  Copyright © 2018 abdulrahmanAbdou. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {

    static let instance = SocketService()
    
    override init() {
        super.init()
    }
    
    //var socket : SocketIOClient?
    static let manager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
    let socket = manager.defaultSocket
    
    func establishConnection(){
        socket.connect()
    }
    
    func closeConnection(){
        socket.disconnect()
    }
    
    
    //send new channel to the api
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler){
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    
    // will be called in channelVC
    func getChannel(completion: @escaping CompletionHandler){
        socket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else{return}
            guard let channelDescription = dataArray[1] as? String else{return}
            guard let channelId = dataArray[2] as? String else{return}
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDescription, id: channelId)
            MessageService.instance.channels.append(newChannel)
        }
    }
    
    // adding messages to the api
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler){
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody,userId,channelId,user.name,user.avatarName,user.avatarColor)
        completion(true)
    }
    func getChatMessage(completion: @escaping (_ newMessage: Message)-> Void){
        socket.on("messageCreated") { (dataArray, ack) in
            guard let msgBody = dataArray[0] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            guard let userName = dataArray[3] as? String else {return}
            guard let userAvatar = dataArray[4] as? String else {return}
            guard let userAvatarColor = dataArray[5] as? String else {return}
            guard let id = dataArray[6] as? String else {return}
            guard let timeStamp = dataArray[7] as? String else {return}
            
            let newMessage = Message(message: msgBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
            
            completion(newMessage)
//            if channelId == MessageService.instance.selectedChannel?.id && AuthServices.instance.isLoggedIn{
//                let newMessage = Message(message: msgBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
//                MessageService.instance.messages.append(newMessage)
//                completion(true)
//            }else{
//                completion(false)
//            }
        }
    }
    
    
    func getTypingUsers(_ completionHandler: @escaping (_ typingUsers: [String: String])->Void){
        socket.on("userTypingUpdate") { (dataArray,ack) in
            guard let typingUsers = dataArray[0] as? [String: String] else {return}
            completionHandler(typingUsers)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}
