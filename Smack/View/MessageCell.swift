//
//  MessageCell.swift
//  Smack
//
//  Created by abdulrahman on 9/29/18.
//  Copyright © 2018 abdulrahmanAbdou. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var userImg: CircleImage!
    @IBOutlet weak var usernameTxt: UILabel!
    @IBOutlet weak var timestapmTxt: UILabel!
    @IBOutlet weak var messageBodyTxt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(message: Message){
        usernameTxt.text = message.userName
        messageBodyTxt.text = message.message
        userImg.image = UIImage(named: message.userAvatar)
        userImg.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
        
        
        guard var isoDate = message.timeStamp else {return}
        let end = isoDate.index(isoDate.endIndex , offsetBy: -5)
        //isoDate = isoDate.substring(to: end)
        isoDate = isoDate.substring(to: end)
        
        //let isoFormatter = ISO8601DateFormatter()
        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: isoDate.appending("Z"))
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d, h:mm a"
        
        if let finalDate = chatDate{
            let finalDate = newFormatter.string(from: finalDate)
            timestapmTxt.text = finalDate
        }
    }
    
}
