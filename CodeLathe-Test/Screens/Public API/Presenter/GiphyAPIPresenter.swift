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
    
}

class GiphyAPIPresenter: GiphyAPIPresenterProtocol {
    
    let delegate: GiphyAPIPresenterDelegate
    let view: GiphyAPIPresenterView
    
    init(
        with view: GiphyAPIPresenterView,
        delegate: GiphyAPIPresenterDelegate) {
        
        self.delegate = delegate
        self.view = view
        
    }
    
    func didTapVirtualCv() {
        self.delegate.showVirtualCv()
    }
    
}
