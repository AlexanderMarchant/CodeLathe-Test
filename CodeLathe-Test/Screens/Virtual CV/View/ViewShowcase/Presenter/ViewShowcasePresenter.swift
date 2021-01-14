//
//  ViewShowcasePresenter.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation

protocol ViewShowcasePresenterDelegate {
    
}

protocol ViewShowcasePresenterView {
    func didGetShowcase(_ showcase: GalleryShowcase)
    func errorOccurred(message: String)
}

class ViewShowcasePresenter: ViewShowcasePresenterProtocol {
    
    let showcase: GalleryShowcase
    let uiApplicationHelperService: UIApplicationHelperServiceProtocol
    
    let delegate: ViewShowcasePresenterDelegate
    let view: ViewShowcasePresenterView
    
    init(
        showcase: GalleryShowcase,
        _ uiApplicationHelperService: UIApplicationHelperServiceProtocol,
        with view: ViewShowcasePresenterView,
        delegate: ViewShowcasePresenterDelegate) {
        
        self.showcase = showcase
        self.uiApplicationHelperService = uiApplicationHelperService
        self.delegate = delegate
        self.view = view
        
    }
    
    func getShowcase() {
        self.view.didGetShowcase(showcase)
    }
    
    func openProjectLink() {
        if let projectLink = showcase.projectLink {
            self.uiApplicationHelperService.openUrl(url: projectLink)
        } else {
            self.view.errorOccurred(message: localizedString(forKey: "no_project_link_error"))
        }
    }
    
}

