//
//  CandidateGallery.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation

struct CandidateGallery {
    
    let showcases: [GalleryShowcase]
    
    init(showcases: [GalleryShowcase] = [GalleryShowcase]()) {
        self.showcases = showcases
    }
}
