//
//  GiphyAPIPresenter.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 13/01/2021.
//

import Foundation

protocol GiphyAPIPresenterDelegate {
    func showVirtualCv()
}

protocol GiphyAPIPresenterView {
    func didGetGifs()
}

class GiphyAPIPresenter: GiphyAPIPresenterProtocol {
    
    let giphyService: GiphyServiceProtocol
    let delegate: GiphyAPIPresenterDelegate
    let view: GiphyAPIPresenterView
    
    init(
        _ giphyService: GiphyServiceProtocol,
        with view: GiphyAPIPresenterView,
        delegate: GiphyAPIPresenterDelegate) {
        
        self.giphyService = giphyService
        self.delegate = delegate
        self.view = view
        
    }
    
    func getTrendingGifs() {
        self.giphyService.getTrendingGifs() { [weak self] (gifs, error) in
            if let error = error {
                print("FAILURE")
                print(error)
            } else {
                print("SUCCESS")
            }
        }
    }
    
    func didTapVirtualCv() {
        self.delegate.showVirtualCv()
    }
    
}
