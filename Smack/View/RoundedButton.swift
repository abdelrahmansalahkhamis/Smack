//
//  RoundedButton.swift
//  Smack
//
//  Created by abdulrahman on 9/23/18.
//  Copyright © 2018 abdulrahmanAbdou. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable var cornerRadius : CGFloat = 3.0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func prepareForInterfaceBuilder() {
        self.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    override func awakeFromNib() {
        self.setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = cornerRadius
    }
}
