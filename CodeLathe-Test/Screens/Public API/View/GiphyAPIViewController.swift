//
//  GiphyAPIViewController.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 13/01/2021.
//

import UIKit

class GiphyAPIViewController: UIViewController, Storyboarded {
    
    var giphyAPIPresenter: GiphyAPIPresenterProtocol!
    
    @IBOutlet weak var giphyTableView: UITableView!
    private var giphyTableViewDataSource: GiphyTableViewDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.appColor(.background)!
        
        navigationItem.setLeftBarButton(nil, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "CV", style: .plain, target: self, action: #selector(virtualCvTapped))
        
        giphyAPIPresenter.getTrendingGifs()
    }
    
    @objc func virtualCvTapped()
    {
        giphyAPIPresenter.didTapVirtualCv()
    }

}

extension GiphyAPIViewController: GiphyAPIPresenterView {
    func didGetGifs(_ gifs: [GiphyCellViewModel]) {
        
        DispatchQueue.main.async {
            self.giphyTableViewDataSource = GiphyTableViewDataSource(
                gifs: gifs,
                tableView: self.giphyTableView)
            
            self.giphyTableView.dataSource = self.giphyTableViewDataSource
            self.giphyTableView.delegate = self.giphyTableViewDataSource
            
            self.giphyTableView.reloadData()
        }
    }
}
