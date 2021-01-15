//
//  GalleryCellModel.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation

class GalleryCellModel {
    
    let imageUrl: URL?
    let urlSessionService: UrlSessionServiceProtocol
    
    init(_ galleryShowcase: GalleryShowcase, _ urlSessionService: UrlSessionServiceProtocol) {
        
        if let showcaseImageUrl = URL(string: galleryShowcase.displayImageUrl) {
            self.imageUrl = showcaseImageUrl
        } else {
            imageUrl = nil
        }
        
        self.urlSessionService = urlSessionService
    }
}
