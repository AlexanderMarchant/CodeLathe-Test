//
//  GiphyCellViewModel.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation

class GiphyCellViewModel {
    
    let gifUrl: URL?
    let title: String
    let sourceUrl: String?
    let markedTrending: String
    let username: String
    
    init(
        gifUrl: String,
        title: String,
        sourceUrl: String,
        markedTrending: String,
        username: String?) {
        
        self.gifUrl = URL(string: gifUrl)
        self.title = title
        self.sourceUrl = sourceUrl
        
        // Giphy API returns 'trending_datetime' with the epoch time if it has not been trending
        if markedTrending == "1970-01-01 00:00:00" || markedTrending == "0000-00-00 00:00:00" {
            self.markedTrending = "Never trended"
        } else {
            self.markedTrending = markedTrending
        }
        
        if let username = username,
              username.isEmpty == false  {
            self.username = username
        } else {
            self.username = "Unknown"
        }
        
    }
    
    
}
