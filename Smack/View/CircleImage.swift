//
//  CircleImage.swift
//  Smack
//
//  Created by abdulrahman on 9/26/18.
//  Copyright © 2018 abdulrahmanAbdou. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImage: UIImageView {
    
    // when awake from nib or when prepare for interface builder we call the setupview function
    
    override func awakeFromNib() {
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    func setupView(){
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
    }

}
