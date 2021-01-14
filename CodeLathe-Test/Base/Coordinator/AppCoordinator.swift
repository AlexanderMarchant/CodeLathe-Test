//
//  AppCoordinator.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 13/01/2021.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    let uiApplicationHelperService: UIApplicationHelperServiceProtocol
    

    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        
        self.navigationController = navigationController
        self.uiApplicationHelperService = UIApplicationHelperService()
        
        super.init()
        
    }

    // MARK: - Start
    
    override func start() {
        
        self.navigationController.dismissKeyboardOnTap()
        
        showGiphyAPI()
        
    }

    // MARK: - Show Giphy API
    
    func showGiphyAPI() {
        
        let giphyAPICoordinator = GiphyAPICoordinator(
            self.navigationController,
            self.uiApplicationHelperService)
        
        giphyAPICoordinator.delegate = self
            
        self.addChildCoordinator(giphyAPICoordinator)
        
        giphyAPICoordinator.start()
    }
}


// MARK: - GiphyAPICoordinatorDelegate

extension AppCoordinator: GiphyAPICoordinatorDelegate {
    
}

