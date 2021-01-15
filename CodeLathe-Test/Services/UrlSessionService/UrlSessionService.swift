//
//  UrlSessionService.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 15/01/2021.
//

import Foundation

class UrlSessionService: UrlSessionServiceProtocol {
    
    init() {}
    
    // Given more time, I would add a caching service that is checked before downloading the image from the url
    
    func downloadImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}
