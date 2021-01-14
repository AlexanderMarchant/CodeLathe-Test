//
//  LocalizedString.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 13/01/2021.
//

import Foundation

func localizedString(forKey key: String) -> String {
    var result = Bundle.main.localizedString(forKey: key, value: nil, table: nil)

    if result == key {
        result = Bundle.main.localizedString(forKey: key, value: nil, table: "Default")
    }

    return result
}
