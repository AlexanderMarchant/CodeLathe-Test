//
//  GiphyService.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation

enum GiphySearch {
    case bySearchTerm
    case trending
}

class GiphyService: GiphyServiceProtocol {
    
    init() {}
    
    fileprivate var currentTrendingOffeset = 0
    fileprivate var currentSearchOffset = 0
    
    func resetTrendingSearch() {
        self.currentTrendingOffeset = 0
    }
    
    func resetSearchByTermSearch() {
        self.currentSearchOffset = 0
    }
    
    func getTrendingGifs(
        limit: Int,
        completion: @escaping (GifTrendModel?, Error?) -> Void) {
        
        let parameters: [String: String] = [
            "api_key" : Constants.wouldNotNormallyCommitToGit,
            "limit" : "\(limit)",
            "offset" : "\(currentTrendingOffeset)"
        ]
        
        self.performRequest(
            link: "https://api.giphy.com/v1/gifs/trending",
            parameters: parameters) { (data, error) in
                
            if let data = data,
               error == nil {
                do {
                    let decoder = JSONDecoder()
                    let gifs = try decoder.decode(GifTrendModel.self, from: data)
                    
                    self.currentTrendingOffeset += limit
                    completion(gifs, nil)
                } catch {
                    print("log an error")
                    completion(nil, nil)
                }
            } else {
                print("ERROR: \(error?.localizedDescription)")
                completion(nil, error)
            }
                
        }
    }
    
    func getGifsBySearchTerm(
        search: String,
        limit: Int,
        completion: @escaping (GifSearchModel?, Error?) -> Void) {
        
        let parameters: [String: String] = [
            "api_key" : Constants.wouldNotNormallyCommitToGit,
            "q": search,
            "limit" : "\(limit)",
            "offset" : "\(currentSearchOffset)"
        ]
        
        self.performRequest(
            link: "https://api.giphy.com/v1/gifs/search",
            parameters: parameters) { (data, error) in
                
            if let data = data,
               error == nil {
                do {
                    let decoder = JSONDecoder()
                    let gifs = try decoder.decode(GifSearchModel.self, from: data)
                    
                    self.currentSearchOffset += limit
                    completion(gifs, nil)
                } catch {
                    print("log an error")
                    completion(nil, nil)
                }
            } else {
                print("ERROR: \(error?.localizedDescription)")
                completion(nil, error)
            }
                
        }
        
    }
    
    private func performRequest(
        link: String,
        parameters: [String: String],
        completion: @escaping (Data?, Error?) -> Void) {
        
        var components = URLComponents(string: link)!
        
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        let request = URLRequest(url: components.url!)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200 ..< 300) ~= response.statusCode,
                  error == nil else {
                
                    completion(nil, error)
                    return
            }
            
            completion(data, error)
        }
        
        task.resume()
    }
    
}
