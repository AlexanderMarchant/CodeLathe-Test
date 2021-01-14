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
    func didGetGifs(_ gifs: [GiphyCellViewModel])
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
            if let gifs = gifs,
               error == nil {
                
//                var giphyViewModels: [GiphyCellViewModel]
                
                var giphyViewModels = gifs.data!.map({ x in
                    GiphyCellViewModel(
                        gifUrl: x.embed_url!,
                        title: x.title!,
                        sourceUrl: x.source!,
                        markedtrending: x.trending_datetime!,
                        username: x.username)
                })
                
                self?.view.didGetGifs(giphyViewModels)
                
                print("SUCCESS")
            } else {
                print("FAILURE")
                print("Show an error")
            }
        }
    }
    
    func didTapVirtualCv() {
        self.delegate.showVirtualCv()
    }
    
}
