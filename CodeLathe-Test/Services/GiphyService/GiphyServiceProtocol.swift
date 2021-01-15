//
//  GiphyServiceProtocol.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation

protocol GiphyServiceProtocol {
    
    func resetTrendingSearch()
    
    func resetSearchByTermSearch()
    
    func getTrendingGifs(
        limit: Int,
        completion: @escaping (GifTrendModel?, Error?) -> Void)
    
    
    func getGifsBySearchTerm(
        search: String,
        limit: Int,
        completion: @escaping (GifSearchModel?, Error?) -> Void)
}
