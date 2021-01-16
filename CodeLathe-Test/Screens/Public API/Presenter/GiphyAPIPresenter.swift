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
    
    private (set) var currentSearch: GiphySearch?
    private (set) var currentSearchTerm: String?
    
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
            self.view.errorOccurred(message: localizedString(forKey: "perform_a_valid_search"))
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
            self.view.errorOccurred(message: localizedString(forKey: "perform_a_valid_search"))
            return
        }
        
        search = search.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(search.isEmpty) {
            self.view.errorOccurred(message: localizedString(forKey: "perform_a_valid_search"))
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
                        title: x.title ?? "",
                        sourceUrl: x.source ?? "",
                        markedTrending: x.trending_datetime ?? "",
                        username: x.username ?? "")
                })
                
                self?.view.didGetGifs(giphyViewModels)
            } else {
                self?.view.errorOccurred(message: localizedString(forKey: "general_error"))
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
                        title: x.title ?? "",
                        sourceUrl: x.source ?? "",
                        markedTrending: x.trending_datetime ?? "",
                        username: x.username ?? "")
                })
                
                self?.view.didGetGifs(giphyViewModels)
            } else {
                self?.view.errorOccurred(message: localizedString(forKey: "general_error"))
            }
        }
    }
    
    func didTapVirtualCv() {
        self.delegate.showVirtualCv()
    }
    
}
