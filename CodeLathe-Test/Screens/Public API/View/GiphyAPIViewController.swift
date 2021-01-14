//
//  GiphyAPIViewController.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 13/01/2021.
//

import UIKit

class GiphyAPIViewController: UIViewController, Storyboarded {
    
    var giphyAPIPresenter: GiphyAPIPresenterProtocol!

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
    func didGetGifs() {
        
    }
}
