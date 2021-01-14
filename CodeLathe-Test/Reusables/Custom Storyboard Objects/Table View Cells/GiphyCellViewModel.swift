//
//  GiphyCellViewModel.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation

class GiphyCellViewModel {
    
    let gifUrl: URL
    let title: String
    let sourceUrl: String?
    let markedTrending: String
    let username: String?
    
    init(
        gifUrl: String,
        title: String,
        sourceUrl: String,
        markedtrending: String,
        username: String?) {
        
        self.gifUrl = URL(string: gifUrl)!
        self.title = title
        self.sourceUrl = sourceUrl
        self.markedTrending = markedtrending
        self.username = username
        
    }
    
    
}
