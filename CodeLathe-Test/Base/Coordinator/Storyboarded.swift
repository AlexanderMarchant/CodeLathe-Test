//
//  Storyboarded.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 13/01/2021.
//

import UIKit

protocol Storyboarded {
    static func instantiate(storyboard: String) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(storyboard: String = "Main") -> Self {
        let storyboardIdentifier = String(describing: self)
        let storyboard = UIStoryboard(name: storyboard, bundle: Bundle.main)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
            fatalError()
        }
        
        return viewController
    }
}
