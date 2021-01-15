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
    func errorOccurred(message: String)
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
    
    func getGifsBySearch(userSearch: String?) {
        
        guard var search = userSearch else {
            self.view.errorOccurred(message: "Please enter a valid search")
            return
        }
        
        search = search.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(search.isEmpty) {
            self.view.errorOccurred(message: "Please enter a valid search")
            return
        }
        
        self.giphyService.getGifsBySearch(search: search, limit: 15) { [weak self] (gifs, error) in
            
            if let gifs = gifs,
               error == nil {
                
                let giphyViewModels = gifs.data!.map({ x in
                    GiphyCellViewModel(
                        gifUrl: x.images!.downsized!.url!,
                        title: x.title!,
                        sourceUrl: x.source!,
                        markedtrending: x.trending_datetime!,
                        username: x.username)
                })
                
                self?.view.didGetGifs(giphyViewModels)
            } else {
                self?.view.errorOccurred(message: "Something went wrong whilst loading more gifs with this search term, please try again.")
            }
        }
        
    }
    
    func getTrendingGifs() {
        self.giphyService.getTrendingGifs(limit: 15) { [weak self] (gifs, error) in
            if let gifs = gifs,
               error == nil {
                
                let giphyViewModels = gifs.data!.map({ x in
                    GiphyCellViewModel(
                        gifUrl: x.images!.downsized!.url!,
                        title: x.title!,
                        sourceUrl: x.source!,
                        markedtrending: x.trending_datetime!,
                        username: x.username)
                })
                
                self?.view.didGetGifs(giphyViewModels)
            } else {
                print("FAILURE")
                print("Show an error")
                self?.view.errorOccurred(message: "Something went wrong whilst loading more gifs, please try again.")
            }
        }
    }
    
    func didTapVirtualCv() {
        self.delegate.showVirtualCv()
    }
    
}
