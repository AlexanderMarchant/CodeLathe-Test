//
//  UIColor-AppColors.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 13/01/2021.
//

import Foundation
import UIKit

enum AppColors : String {
    case background
    case body
    case galleryCellBorder
    case skillCellBackground
    case navigationBarButtonFill
    case codeLathe
}

extension UIColor {
  static func appColor(_ name: AppColors) -> UIColor? {
     return UIColor(named: name.rawValue)
  }
}
