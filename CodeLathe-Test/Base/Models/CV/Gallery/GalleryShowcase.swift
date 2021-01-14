//
//  GalleryShowcase.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation

struct GalleryShowcase: MenuIdentifiable {
    
    var id: String?
    
    var elementId: String!
    
    let displayImageUrl: String
    let title: String
    let description: String
    let projectLink: String?
    let technologiesUsed: [String]
    let challenges: [String]
    
    init(
        displayImageUrl: String,
        title: String,
        description: String,
        projectLink: String? = nil,
        technologiesUsed: [String],
        challenges: [String]) {
        
        self.id = UUID().uuidString
        self.displayImageUrl = displayImageUrl
        self.title = title
        self.description = description
        self.projectLink = projectLink
        self.technologiesUsed = technologiesUsed
        self.challenges = challenges
        
    }
    
}
