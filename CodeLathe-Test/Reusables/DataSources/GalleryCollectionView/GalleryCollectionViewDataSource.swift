//
//  GalleryCollectionViewDataSource.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import Foundation
import UIKit

protocol GalleryCollectionViewDataSourceDelegate {
    func viewShowcase(_ showcase: GalleryShowcase)
}

class GalleryCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let gallery: CandidateGallery
    let collectionView: UICollectionView
    let delegate: GalleryCollectionViewDataSourceDelegate
    
    init(
        gallery: CandidateGallery,
        collectionView: UICollectionView,
        delegate: GalleryCollectionViewDataSourceDelegate) {
        
        self.gallery = gallery
        self.collectionView = collectionView
        self.delegate = delegate
        
        self.collectionView.backgroundColor = .clear
        
        collectionView.register(
            UINib.init(
                nibName: Constants.galleryCellNibName,
                bundle: nil),
            forCellWithReuseIdentifier: Constants.galleryCellIdentifier)
        
        super.init()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery.showcases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.galleryCellIdentifier,
            for: indexPath) as! GalleryCell
        
        
        if(gallery.showcases.count - 1 < indexPath.row) {
            return cell
        }
        
        let galleryShowcase = gallery.showcases[indexPath.row]
        
        let galleryCellModel = GalleryCellModel(galleryShowcase)
        
        cell.model = galleryCellModel
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let showcase = gallery.showcases[indexPath.row]
        
        self.delegate.viewShowcase(showcase)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 125, height: 125)
    }
    
}


