//
//  AlertHandlerService.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation
import UIKit

class AlertHandlerService {
    
    static let shared = AlertHandlerService()
    
    private init() {}
    
    func showWarningAlert(view: UIViewController, message: String) {
        let alert = UIAlertController(
            title: localizedString(forKey: "warning"),
            message: message,
            preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(
            title: localizedString(forKey: "ok"),
            style: UIAlertAction.Style.default,
            handler: nil))
        
        DispatchQueue.main.async {
            view.present(alert, animated: true, completion: nil)
        }
    }

    func showCustomAlert(view: UIViewController, title: String, message: String, actionTitles:[String?], actions: [((UIAlertAction) -> Void)?]) {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert)
        
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(
                title: title,
                style: .default,
                handler: actions[index])
            
            alert.addAction(action)
        }
        
        DispatchQueue.main.async {
            view.present(alert, animated: true, completion: nil)
        }
    }
}

