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
    func didGetCandidate(_ candidate: Candidate)
}

class VirtualCVPresenter: VirtualCVPresenterProtocol {
    
    let candidate: Candidate
    
    let delegate: VirtualCVPresenterDelegate
    let view: VirtualCVPresenterView
    
    init(
        candidate: Candidate,
        with view: VirtualCVPresenterView,
        delegate: VirtualCVPresenterDelegate) {
        
        self.candidate = candidate
        self.delegate = delegate
        self.view = view
        
    }
    
    func getCandidate() {
        self.view.didGetCandidate(candidate)
    }
    
    func didTapShowcase(showcase: GalleryShowcase) {
        self.delegate.viewShowcaseInformation(showcase)
    }
    
    func goBack() {
        self.delegate.goBack()
    }
    
}
