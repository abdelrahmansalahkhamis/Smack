
//
//  ChannelCell.swift
//  Smack
//
//  Created by abdulrahman on 9/27/18.
//  Copyright © 2018 abdulrahmanAbdou. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    
    @IBOutlet weak var channelTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected{
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        }else{
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
        
    }
    
    func configureCell(channel: Channel){
        let title = channel.channelTitle ?? ""
        self.channelTitle.text = "#\(title)"
        self.channelTitle.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        for id in MessageService.instance.unreadChannels{
            if id == channel.id{
                channelTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
            }
        }
    }

}







