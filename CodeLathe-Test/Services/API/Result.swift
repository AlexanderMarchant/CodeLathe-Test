//
//  Result.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 15/01/2021.
//

import Foundation

struct CoreError: Error {
    var localizedDescription: String {
        return message
    }
    
    var message = localizedString(forKey: "general_error")
}

typealias Result<T> = Swift.Result<T, Error>
