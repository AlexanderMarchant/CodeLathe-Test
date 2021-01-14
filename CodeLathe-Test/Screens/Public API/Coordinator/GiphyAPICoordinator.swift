//
//  GiphyAPICoordinator.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 13/01/2021.
//

import Foundation
import UIKit

protocol GiphyAPICoordinatorDelegate: AnyObject {
}

class GiphyAPICoordinator: Coordinator {
    
    let navigationController: UINavigationController
    let uiApplicationHelperService: UIApplicationHelperServiceProtocol
    
    weak var delegate: GiphyAPICoordinatorDelegate?
    
    init(
        _ navigationController: UINavigationController,
        _ uiApplicationHelperService: UIApplicationHelperServiceProtocol) {
        
        self.navigationController = navigationController
        self.uiApplicationHelperService = uiApplicationHelperService
        
        self.navigationController.isNavigationBarHidden = false
    }
    
    override func start() {
        showGiphyAPI()
    }
    
    func showGiphyAPI() {
        let giphyAPIViewController = GiphyAPIViewController.instantiate(storyboard: "GiphyAPI")
        
        let giphyAPIPresenter = GiphyAPIPresenter(
            with: giphyAPIViewController,
            delegate: self)
        
        giphyAPIViewController.giphyAPIPresenter = giphyAPIPresenter
        
        self.navigationController.pushViewController(giphyAPIViewController, animated: true)
    }
}


// MARK: - GiphyAPIPresenterDelegate

extension GiphyAPICoordinator: GiphyAPIPresenterDelegate {
    func showVirtualCv() {
        let virtualCVCoordinator = VirtualCVCoordinator(
            self.navigationController,
            self.uiApplicationHelperService)
            
        virtualCVCoordinator.delegate = self
            
        self.addChildCoordinator(virtualCVCoordinator)
        
        virtualCVCoordinator.start()
    }
}

extension GiphyAPICoordinator: VirtualCVCoordinatorDelegate {
    func didFinishViewingCV(_ virtualCVCoordinator: VirtualCVCoordinator) {
        virtualCVCoordinator.navigationController.dismiss(animated: true)
        self.removeChildCoordinator(virtualCVCoordinator)
    }
}
