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
    func didGetImageData(_ imageData: Data?)
    func errorOccurred(message: String)
}

class ViewShowcasePresenter: ViewShowcasePresenterProtocol {
    
    let showcase: GalleryShowcase
    let urlSessionService: UrlSessionServiceProtocol
    let uiApplicationHelperService: UIApplicationHelperServiceProtocol
    
    let delegate: ViewShowcasePresenterDelegate
    let view: ViewShowcasePresenterView
    
    init(
        showcase: GalleryShowcase,
        _ urlSessionService: UrlSessionServiceProtocol,
        _ uiApplicationHelperService: UIApplicationHelperServiceProtocol,
        with view: ViewShowcasePresenterView,
        delegate: ViewShowcasePresenterDelegate) {
        
        self.showcase = showcase
        self.urlSessionService = urlSessionService
        self.uiApplicationHelperService = uiApplicationHelperService
        self.delegate = delegate
        self.view = view
        
    }
    
    func getShowcase() {
        self.view.didGetShowcase(showcase)
        
        urlSessionService.downloadImage(from: URL(string: showcase.displayImageUrl)!) { [weak self] (data, response, error) in
            
            if (error != nil || response == nil || (response as? HTTPURLResponse)!.statusCode != 200) {
                
                print("Something went wrong, log the error")
                print("ERROR: \(error?.localizedDescription ?? "Unknown")")
                
                self?.view.errorOccurred(message: localizedString(forKey: "general_error"))
            }
            
            self?.view.didGetImageData(data)
            
        }
    }
    
    func openProjectLink() {
        if let projectLink = showcase.projectLink {
            self.uiApplicationHelperService.openUrl(url: projectLink)
        } else {
            self.view.errorOccurred(message: localizedString(forKey: "no_project_link_error"))
        }
    }
    
}

