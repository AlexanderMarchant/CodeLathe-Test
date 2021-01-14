//
//  GalleryCell.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var loadingView: LoadingView!
    
    var model: GalleryCellModel! {
        didSet {
            
            loadingView.setLoading(isLoading: true)
            loadingView.updateLoadingMessage(message: "Loading image...")
            
            setupDropShadow()
            
            downloadImage(from: model.imageUrl!) { [weak self] (data, response, error) in
                
                guard let data = data,
                      let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                      error == nil else {
                    
                    print("Something went wrong, log the error")
                    print("ERROR: \(error!.localizedDescription)")
                    
                    DispatchQueue.main.async() { [weak self] in
                        self?.loadingView.setLoading(isLoading: false)
                        self?.iconImageView.image = UIImage(named: "image-not-found")!
                    }
                    
                    return
                }
                
                print("Download Finished")
                
                DispatchQueue.main.async() { [weak self] in
                    self?.loadingView.setLoading(isLoading: false)
                    self?.iconImageView.image = UIImage(data: data)
                }
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if(previousTraitCollection?.userInterfaceStyle != self.traitCollection.userInterfaceStyle) {
            setupDropShadow()
        }
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.appColor(.background)!
        
        self.view.backgroundColor = UIColor.appColor(.background)!
        self.view.layer.borderWidth = 1
        self.view.layer.borderColor = UIColor.appColor(.galleryCellBorder)!.cgColor
        self.view.layer.cornerRadius = 5
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.masksToBounds = true
        
        self.loadingView.setLoading(isLoading: false)
        self.loadingView.loadingMessage.isHidden = true
        
        self.iconImageView.layer.cornerRadius = 10
    }
    private func setupDropShadow() {
        
        if(self.traitCollection.userInterfaceStyle == .light) {
            
            self.layer.shadowColor = UIColor.lightGray.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
            self.layer.shadowRadius = 3
            self.layer.shadowOpacity = 0.75
            self.layer.masksToBounds = false
            self.layer.shadowPath = UIBezierPath(
                roundedRect: self.bounds,
                cornerRadius: self.contentView.layer.cornerRadius).cgPath
        } else {
            self.layer.masksToBounds = true
            
            self.layer.shadowColor = nil
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowRadius = 0
            self.layer.shadowOpacity = 0
            self.layer.shadowPath = nil
        }
        
    }
    
    func downloadImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

}
