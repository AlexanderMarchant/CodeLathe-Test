//
//  GiphyAPIPresenterProtocol.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 13/01/2021.
//

import Foundation

protocol GiphyAPIPresenterProtocol {
    func didTapVirtualCv()
    func getGifs(by searchType: GiphySearch, searchTerm: String?)
    func loadNextGifSet()
}
