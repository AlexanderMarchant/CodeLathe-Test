//
//  CLPrimaryButton.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 13/01/2021.
//

import Foundation
import UIKit

class CLPrimaryButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Design taken from CodeLathe website

        self.backgroundColor = UIColor.appColor(.codeLathe)
        
        self.layer.cornerRadius = self.frame.height / 2
        
        self.setTitleColor(UIColor.white, for: .normal)
        
        self.titleLabel?.font = Fonts.buttonFont
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = 0.75
    }

}
