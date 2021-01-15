//
//  UrlSessionServiceProtocol.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 15/01/2021.
//

import Foundation

protocol UrlSessionServiceProtocol {
    func downloadImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ())
}
