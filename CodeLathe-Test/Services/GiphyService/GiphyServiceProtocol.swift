//
//  GiphyServiceProtocol.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation

protocol GiphyServiceProtocol {
    func getTrendingGifs(completion: @escaping (GifTrendModel?, Error?) -> Void)
}
