//
//  ContactCandidateService.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation
import UIKit
import MessageUI

class ContactCandidateService: NSObject {
    
    static let shared = ContactCandidateService()
    
    private override init() {
        super.init()
    }
    
    func sendEmail(
        recipientEmail: String,
        recipientFirstName: String,
        displayedOn viewController: UIViewController) {
        if MFMailComposeViewController.canSendMail() {
            let vc = MFMailComposeViewController()
            
            vc.mailComposeDelegate = self
            
            vc.setToRecipients([recipientEmail])
            
            var message: String!
            
            
            message = "Hi \(recipientFirstName),<br><br>I have seen your profile on CodeLathe's virtual CV app and I am interested in moving forward with you.<br><br>Please let me know when you are free to chat with me by replying to this email.<br><br>Best,<br><br> <br><br>CodeLathe Team<br><a href='\(Constants.codalatheWebsiteLink)'>\(Constants.codalatheWebsiteLink)</a>"
            
            vc.setMessageBody(message, isHTML: true)
            
            viewController.present(vc, animated: true, completion: nil)
        } else {
            AlertHandlerService.shared.showWarningAlert(
                view: viewController,
                message: "You must set up an email app on your phone before you can send emails through this app.")
        }
    }
    
    func callNumber(phoneNumber: String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application: UIApplication = UIApplication.shared
            
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
}

extension ContactCandidateService: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ContactCandidateService: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

