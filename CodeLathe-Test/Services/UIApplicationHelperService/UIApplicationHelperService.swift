//
//  UIApplicationHelperService.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation


import Foundation
import UIKit

class UIApplicationHelperService: UIApplicationHelperServiceProtocol {
    
    init() { }
    
    func openUrl(url: String) {
        UIApplication.shared.open(URL(string: url)!)
    }
}
