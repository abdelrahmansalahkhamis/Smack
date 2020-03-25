//
//  AddChannelVC.swift
//  Smack
//
//  Created by abdulrahman on 9/28/18.
//  Copyright © 2018 abdulrahmanAbdou. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var descTxt: UITextField!
    @IBOutlet weak var bgViewTxt: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView(){
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
        descTxt.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closePressed(_:)))
        bgViewTxt.addGestureRecognizer(closeTouch)
    }
    
    
    @objc func closePressed(_ recognizer: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func creaatChannelPressed(_ sender: Any) {
        guard let channelName = usernameTxt.text, usernameTxt.text != "" else{return}
        guard let channelDescription = descTxt.text else{return}
        
        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDescription) { (success) in
            if success{
                self.dismiss(animated: true, completion: nil)
                print("success")
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
