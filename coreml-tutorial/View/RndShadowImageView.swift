//
//  RndShadowImageView.swift
//  coreml-tutorial
//
//  Created by PEDRO LUIS AARON R on 7/7/18.
//  Copyright © 2018 paaron. All rights reserved.
//

import UIKit

class RndShadowImageView: UIImageView {
    
    override func awakeFromNib() {
        self.layer.shadowColor=UIColor.darkGray.cgColor
        self.layer.shadowRadius=15
        self.layer.shadowOpacity=0.75
        self.layer.cornerRadius=15
    }
    
}
