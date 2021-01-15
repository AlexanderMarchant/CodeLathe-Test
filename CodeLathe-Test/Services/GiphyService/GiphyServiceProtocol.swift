//
//  GiphyServiceProtocol.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation

protocol GiphyServiceProtocol {
    
    func getTrendingGifs(
        limit: Int,
        completion: @escaping (GifTrendModel?, Error?) -> Void)
    
    
    func getGifsBySearch(
        search: String,
        limit: Int,
        completion: @escaping (GifSearchModel?, Error?) -> Void)
}
