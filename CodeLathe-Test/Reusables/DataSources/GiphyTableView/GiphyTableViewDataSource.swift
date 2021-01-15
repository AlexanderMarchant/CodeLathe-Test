//
//  GiphyTableViewDataSource.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation
import UIKit
import DZNEmptyDataSet

protocol GiphyTableViewDataSourceDelegate {
    func loadNextGifSet()
}

class GiphyTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private (set) var gifs: [GiphyCellViewModel]
    let tableView: UITableView
    let delegate: GiphyTableViewDataSourceDelegate
    
    init(
        gifs: [GiphyCellViewModel],
        tableView: UITableView,
        delegate: GiphyTableViewDataSourceDelegate) {
        
        self.gifs = gifs
        self.tableView = tableView
        self.delegate = delegate
        
        super.init()
        
        self.tableView.backgroundColor = .clear
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        tableView.register(
            UINib.init(
                nibName: Constants.giphyCellNibName,
                bundle: nil),
            forCellReuseIdentifier: Constants.giphyCellIdentifier)
        
    }
    
    func insertGifs(gifs: [GiphyCellViewModel]) {
        self.gifs.append(contentsOf: gifs)
    }
    
    func removeAllGifs() {
        self.gifs = [GiphyCellViewModel]()
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // Preload the next set
        if(indexPath.row == self.gifs.count - 1) {
            self.delegate.loadNextGifSet()
        }
    }
    
}

extension GiphyTableViewDataSource: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = localizedString(forKey: "no_gifs_found_title")
        let attrs: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: Fonts.subTitleFont,
            NSAttributedString.Key.foregroundColor: UIColor.appColor(.body)!]
        
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = localizedString(forKey: "no_gifs_found_description")
        let attrs: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: Fonts.subHeaderFont,
            NSAttributedString.Key.foregroundColor: UIColor.appColor(.body)!]
        
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "image-search-icon")?.withTintColor(UIColor.appColor(.body)!)
    }
}
