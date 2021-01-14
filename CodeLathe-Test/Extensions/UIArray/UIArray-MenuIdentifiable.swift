//
//  UIArray-MenuIdentifiable.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation
import UIKit

protocol MenuIdentifiable {
    var id: String? { get }
}

@available(iOS 13.0, *)
extension MenuIdentifiable {
    
    var menuId: NSString {
        NSString(string: id ?? "")
    }
    
    func isReferenced(by configuration: UIContextMenuConfiguration) -> Bool {
        return menuId == configuration.identifier as? NSString
    }
}

extension Array where Element: MenuIdentifiable {
    
    func item(for configuration: UIContextMenuConfiguration) -> Element? {
        return first(where: { $0.menuId == configuration.identifier as? NSString })
    }
    
    func index(for configuration: UIContextMenuConfiguration) -> Index? {
        return firstIndex(where: { $0.menuId == configuration.identifier as? NSString })
    }
}
