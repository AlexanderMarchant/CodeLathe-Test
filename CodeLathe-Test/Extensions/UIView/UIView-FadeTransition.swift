//
//  UIView-FadeTransition.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation
import UIKit

// Usage: Insert view.fadeTransition right before changing content

extension UIView {
    func fadeTransition(_ duration: CFTimeInterval) {
        
        let animation = CATransition()
        
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        animation.type = CATransitionType.fade
        animation.duration = duration
        
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
