//
//  GalleryCollectionViewDataSource-ContextMenu.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation
import UIKit

extension GalleryCollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let showcase = self.gallery.showcases[indexPath.row]
        let urlSessionService: UrlSessionServiceProtocol = UrlSessionService()
        let uiApplicationHelperService: UIApplicationHelperServiceProtocol = UIApplicationHelperService()
        var openProjectLinkActionAttributes: UIMenuElement.Attributes = UIMenuElement.Attributes.disabled
        
        let viewShowcaseViewController = ViewShowcaseViewController.instantiate(storyboard: "ViewShowcase")
        
        let viewShowcasePresenter = ViewShowcasePresenter(
            showcase: showcase,
            urlSessionService,
            uiApplicationHelperService,
            with: viewShowcaseViewController,
            delegate: self)
        
        viewShowcaseViewController.viewShowcasePresenter = viewShowcasePresenter
        
        if let projectLink = showcase.projectLink {
            if !projectLink.isEmpty {
                openProjectLinkActionAttributes = UIMenuElement.Attributes.init()
            }
        }
        
        let config = UIContextMenuConfiguration(identifier: showcase.menuId, previewProvider: {
    
            return viewShowcaseViewController
            
        }, actionProvider: { _ in
            
            let contactMenu: UIMenu = {
                let link = UIAction(
                    title: localizedString(forKey: "open_project_link"),
                    image: UIImage(named: "open-icon"),
                    attributes: openProjectLinkActionAttributes) { _ in
                    uiApplicationHelperService.openUrl(url: showcase.projectLink!)
                }
                
                return UIMenu(title: "Project", image: nil, identifier: nil, options: .displayInline, children: [link])
            }()
            
            let menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: [contactMenu])
            
            return menu
            
        })
        
        return config
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        
        guard let showcase = self.gallery.showcases.item(for: configuration) else {
            return
        }
        
        animator.addCompletion {
            self.delegate.viewShowcase(showcase)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makePhotoPreview(for: configuration)
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makePhotoPreview(for: configuration)
    }
    
    func makePhotoPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        guard let index = self.gallery.showcases.index(for: configuration) else {
            return nil
        }
        
        guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? GalleryCell else {
            return nil
        }
        
        let preview = UITargetedPreview(view: cell.iconImageView)
        
        return preview
    }
}

extension GalleryCollectionViewDataSource: ViewShowcasePresenterDelegate {
}
