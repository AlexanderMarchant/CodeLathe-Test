//
//  GiphyTableViewDataSource.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation
import UIKit

class GiphyTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let gifs: [GiphyCellViewModel]
    let tableView: UITableView
    
    init(
        gifs: [GiphyCellViewModel],
        tableView: UITableView) {
        
        self.gifs = gifs
        self.tableView = tableView
        
        self.tableView.backgroundColor = .clear
        
        tableView.register(
            UINib.init(
                nibName: Constants.giphyCellNibName,
                bundle: nil),
            forCellReuseIdentifier: Constants.giphyCellIdentifier)
        
        super.init()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.giphyCellIdentifier,
            for: indexPath) as! GiphyCell
        
        
        let gif = self.gifs[indexPath.row]
        
        cell.model = gif
        
        return cell
        
    }
    
}
