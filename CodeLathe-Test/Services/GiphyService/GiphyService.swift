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
            link: Constants.giphyApiTrendingLink,
            parameters: parameters) { (result: Result<ApiResponse<GifTrendModel>>) in
            
                self.currentTrendingOffeset += limit
            
            switch result {
            case let .success(response):
                completion(response.entity, nil)
            case let .failure(error):
                
                // Log this error to somewhere like crashlytics
                
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
            link: Constants.giphyApiSearchLink,
            parameters: parameters) { (result: Result<ApiResponse<GifSearchModel>>) in
            
                self.currentSearchOffset += limit
            
            switch result {
            case let .success(response):
                completion(response.entity, nil)
            case let .failure(error):
                
                // Log this error to somewhere like crashlytics
                
                completion(nil, error)
            }
                
        }
        
    }
    
    private func performRequest<T: Decodable>(
        link: String,
        parameters: [String: String],
        completion: @escaping (Result<ApiResponse<T>>) -> Void) {
        
        var components = URLComponents(string: link)!
        
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        let request = URLRequest(url: components.url!)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkRequestError(error: error)))
                return
            }
            
            let successRange = 200...299
            if successRange.contains(httpUrlResponse.statusCode) {
                do {
                    let response = try ApiResponse<T>(data: data, httpUrlResponse: httpUrlResponse)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(ApiError(data: data, httpUrlResponse: httpUrlResponse)))
            }
        }
        
        task.resume()
    }
    
}
