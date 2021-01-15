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
    let giphyService: GiphyServiceProtocol
    let urlSessionService: UrlSessionServiceProtocol
    let uiApplicationHelperService: UIApplicationHelperServiceProtocol
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        
        self.navigationController = navigationController
        self.giphyService = GiphyService()
        self.urlSessionService = UrlSessionService()
        self.uiApplicationHelperService = UIApplicationHelperService()
        
        self.navigationController.navigationBar.tintColor = UIColor.appColor(.body)
        self.navigationController.navigationBar.barTintColor = UIColor.appColor(.background)!
        self.navigationController.navigationBar.shadowImage = UIImage()
        self.navigationController.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: Fonts.headerFont, NSAttributedString.Key.foregroundColor: UIColor.appColor(.body)!]
        
        self.navigationController.navigationBar.layer.masksToBounds = false
        self.navigationController.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.navigationController.navigationBar.layer.shadowRadius = 4
        self.navigationController.navigationBar.layer.shadowOpacity = 0.7
        
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
            self.giphyService,
            self.urlSessionService,
            self.uiApplicationHelperService)
        
        giphyAPICoordinator.delegate = self
            
        self.addChildCoordinator(giphyAPICoordinator)
        
        giphyAPICoordinator.start()
    }
}


// MARK: - GiphyAPICoordinatorDelegate

extension AppCoordinator: GiphyAPICoordinatorDelegate {
    
}

