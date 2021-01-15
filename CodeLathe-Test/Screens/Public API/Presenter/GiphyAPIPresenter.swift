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
    
    private var currentSearch: GiphySearch?
    private var currentSearchTerm: String?
    
    init(
        _ giphyService: GiphyServiceProtocol,
        with view: GiphyAPIPresenterView,
        delegate: GiphyAPIPresenterDelegate) {
        
        self.giphyService = giphyService
        self.delegate = delegate
        self.view = view
        
    }
    
    func getGifs(by searchType: GiphySearch, searchTerm: String? = nil) {
        
        self.giphyService.resetTrendingSearch()
        self.giphyService.resetSearchByTermSearch()
        
        switch searchType {
        case .trending:
            self.getTrendingGifs()
        case .bySearchTerm:
            self.getGifsBySearchTerm(userSearch: searchTerm)
        }
    }
    
    func loadNextGifSet() {
        guard let currentSearch = currentSearch else {
            self.view.errorOccurred(message: "Please perform a search")
            return
        }
        
        switch currentSearch {
        case .bySearchTerm:
            self.getGifsBySearchTerm(userSearch: currentSearchTerm!)
        case .trending:
            self.getTrendingGifs()
        }
    }
    
    internal func getGifsBySearchTerm(userSearch: String?) {
        
        guard var search = userSearch else {
            self.view.errorOccurred(message: "Please enter a valid search")
            return
        }
        
        search = search.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(search.isEmpty) {
            self.view.errorOccurred(message: "Please enter a valid search")
            return
        }
        
        self.currentSearch = .bySearchTerm
        self.currentSearchTerm = search
        
        self.giphyService.getGifsBySearchTerm(search: search, limit: 15) { [weak self] (gifs, error) in
            
            if let gifs = gifs,
               error == nil {
                
                let giphyViewModels = gifs.data!.map({ x in
                    GiphyCellViewModel(
                        gifUrl: x.images!.downsized!.url!,
                        title: x.title ?? "No title",
                        sourceUrl: x.source ?? "Unknown",
                        markedTrending: x.trending_datetime ?? "Never",
                        username: x.username ?? "Unknown")
                })
                
                self?.view.didGetGifs(giphyViewModels)
            } else {
                self?.view.errorOccurred(message: "Something went wrong whilst loading more gifs with this search term, please try again.")
            }
        }
        
    }
    
    func getTrendingGifs() {
        
        self.currentSearch = .trending
        
        self.giphyService.getTrendingGifs(limit: 15) { [weak self] (gifs, error) in
            if let gifs = gifs,
               error == nil {
                
                let giphyViewModels = gifs.data!.map({ x in
                    
                    GiphyCellViewModel(
                        gifUrl: x.images?.downsized?.url ?? "",
                        title: x.title ?? "No title",
                        sourceUrl: x.source ?? "Unknown",
                        markedTrending: x.trending_datetime ?? "Never",
                        username: x.username ?? "Unknown")
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
