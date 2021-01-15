//
//  VirtualCVPresenter.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 13/01/2021.
//

import Foundation

protocol VirtualCVPresenterDelegate {
    func viewShowcaseInformation(_ showcase: GalleryShowcase)
    func goBack()
}

protocol VirtualCVPresenterView {
    func didGetCandidate(_ candidate: Candidate, _ urlSessionService: UrlSessionServiceProtocol)
}

class VirtualCVPresenter: VirtualCVPresenterProtocol {
    
    let candidate: Candidate
    let urlSessionService: UrlSessionServiceProtocol
    let delegate: VirtualCVPresenterDelegate
    let view: VirtualCVPresenterView
    
    init(
        candidate: Candidate,
        _ urlSessionService: UrlSessionServiceProtocol,
        with view: VirtualCVPresenterView,
        delegate: VirtualCVPresenterDelegate) {
        
        self.candidate = candidate
        self.urlSessionService = urlSessionService
        self.delegate = delegate
        self.view = view
        
    }
    
    func getCandidate() {
        self.view.didGetCandidate(candidate, self.urlSessionService)
    }
    
    func didTapShowcase(showcase: GalleryShowcase) {
        self.delegate.viewShowcaseInformation(showcase)
    }
    
    func goBack() {
        self.delegate.goBack()
    }
    
}
