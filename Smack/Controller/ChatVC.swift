//
//  ChatVC.swift
//  Smack
//
//  Created by abdulrahman on 9/18/18.
//  Copyright © 2018 abdulrahmanAbdou. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    //outlets
    @IBOutlet weak var menubtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTxtBox: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var typingUsersLbl: UILabel!
    
    
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        sendBtn.isHidden = true
        
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap(_:)))
        view.addGestureRecognizer(closeTap)
        
        
        menubtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        
        // add the selected channel name to the channelNameLbl
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelId == MessageService.instance.selectedChannel?.id && AuthServices.instance.isLoggedIn {
                MessageService.instance.messages.append(newMessage)
                self.tableView.reloadData()
                if MessageService.instance.messages.count > 0 {
                    let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
                }
            }
        }
        
//        SocketService.instance.getChatMessage { (success) in
//            if success{
//
//                print(" **** success to load messages ****")
//
//                self.tableView.reloadData()
//                if MessageService.instance.messages.count > 0{
//                    let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
//                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
//                }
//            }
//        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else {return}
            var names = ""
            var numberOfTypers = 0
            
            for (typingUser, channel) in typingUsers{
                // check that the typing user is not me
                if typingUser != UserDataService.instance.name && channel == channelId{
                    if names == ""{
                        names = typingUser
                    }else{
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            
            if numberOfTypers > 0 && AuthServices.instance.isLoggedIn == true{
                var verb = "is"
                if numberOfTypers > 1{
                    verb = "are"
                }
                self.typingUsersLbl.text = "\(names) \(verb) typing a message"
            }else{
                self.typingUsersLbl.text = ""
            }
            
        }
        
        if AuthServices.instance.isLoggedIn{
            AuthServices.instance.findUserByEmail { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
        }

    }
    
    @objc func userDataDidChange(_ notif : Notification){
        if AuthServices.instance.isLoggedIn{
            // add channel name
            onLoginGetMessages()
        }else{
            channelNameLbl.text = "please login"
            self.tableView.reloadData()
        }
    }

    
    // when reopen the app, set the first channel as the default channel
    func onLoginGetMessages(){
        MessageService.instance.findAllChannels { (success) in
            if success{
                if MessageService.instance.channels.count > 0{
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                }else{
                    self.channelNameLbl.text = "no channels yet"
                }
            }
        }
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func channelSelected(_ notif: Notification){
        updateWithChannel()
    }
    
    @IBAction func sendMessagePressed(_ sender: Any) {
        if AuthServices.instance.isLoggedIn{
            guard let channelId = MessageService.instance.selectedChannel?.id else{return}
            guard let message = messageTxtBox.text else{return}
            
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId) { (success) in
                if success{
                    self.messageTxtBox.text = ""
                    self.messageTxtBox.resignFirstResponder()  //dismiss the keyboard
                    SocketService.instance.socket.emit("stopType", UserDataService.instance.name,channelId)
                }
            }
        }
    }
    
    
    // update the channel name in the chat label
    func updateWithChannel(){
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessages()
    }
    
    func getMessages(){
        guard let channelId = MessageService.instance.selectedChannel?.id else{return}
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            if success{
                self.tableView.reloadData()
            }
        }
    }
    
    
    @IBAction func messageBoxEditing(_ sender: Any) {
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        if messageTxtBox.text == ""{
            isTyping = false
            sendBtn.isHidden = true
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name,channelId)
        }else{
            if isTyping == false{
                sendBtn.isHidden = false
                SocketService.instance.socket.emit("startType", UserDataService.instance.name,channelId)
            }
            isTyping = true
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell{
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
}










