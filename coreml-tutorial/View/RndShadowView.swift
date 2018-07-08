//
//  RndShadowView.swift
//  coreml-tutorial
//
//  Created by PEDRO LUIS AARON R on 7/7/18.
//  Copyright © 2018 paaron. All rights reserved.
//

import UIKit

class RndShadowView: UIView {

    override func awakeFromNib() {
        self.layer.shadowColor=UIColor.darkGray.cgColor
        self.layer.shadowRadius=15
        self.layer.shadowOpacity=0.75
        self.layer.cornerRadius=self.frame.height/2
    }

}
