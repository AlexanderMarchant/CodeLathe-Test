//
//  CLHeader.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 13/01/2021.
//

import Foundation
import UIKit

class CLHeader: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.font = Fonts.headerFont
        self.textColor = UIColor.appColor(.body)
    }

}
