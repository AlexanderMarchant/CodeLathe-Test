//
//  CVHeaderViewModel.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation

class CVHeaderViewModel {
    
    let fullname: String
    let emailAddress: String
    let phoneNumber: String
    let delegate: CVHeaderViewDelegate
    
    init(
        firstName: String,
        lastName: String,
        emailAddress: String,
        phoneNumber: String,
        delegate: CVHeaderViewDelegate) {
        
        self.fullname = "\(firstName) \(lastName)"
        self.emailAddress = emailAddress
        self.phoneNumber = phoneNumber
        self.delegate = delegate
        
    }
    
}
