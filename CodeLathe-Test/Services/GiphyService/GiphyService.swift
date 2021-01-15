//
//  GiphyService.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation

class GiphyService: GiphyServiceProtocol {
    
    init() {}
    
    var currentTrendingOffeset = 0
    var currentSearchOffset = 0
    
    func getTrendingGifs(
        limit: Int,
        completion: @escaping (GifTrendModel?, Error?) -> Void) {
        
        let parameters: [String: String] = [
            "api_key" : Constants.wouldNotNormallyCommitToGit,
            "limit" : "\(limit)",
            "offset" : "\(currentTrendingOffeset)"
        ]
        
        var components = URLComponents(string: "https://api.giphy.com/v1/gifs/trending")!
        
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        let request = URLRequest(url: components.url!)

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200 ..< 300) ~= response.statusCode,
                  error == nil else {
                
                    completion(nil, error)
                    return
            }
            
            // Do proper error handling
                        
            let decoder = JSONDecoder()
            let gifs = try! decoder.decode(GifTrendModel.self, from: data)
            
            self?.currentTrendingOffeset += limit
            
            completion(gifs, nil)
        }
        task.resume()
    }
    
    func getGifsBySearch(
        search: String,
        limit: Int,
        completion: @escaping (GifSearchModel?, Error?) -> Void) {
        
        let parameters: [String: String] = [
            "api_key" : Constants.wouldNotNormallyCommitToGit,
            "q": search,
            "limit" : "\(limit)",
            "offset" : "\(currentSearchOffset)"
        ]
        
        var components = URLComponents(string: "https://api.giphy.com/v1/gifs/search")!
        
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        let request = URLRequest(url: components.url!)

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200 ..< 300) ~= response.statusCode,
                  error == nil else {
                
                    completion(nil, error)
                    return
            }
            
            // Do proper error handling
                        
            let decoder = JSONDecoder()
            let gifs = try! decoder.decode(GifSearchModel.self, from: data)
            
            self?.currentSearchOffset += limit
            
            completion(gifs, nil)
        }
        task.resume()
        
    }
    
}