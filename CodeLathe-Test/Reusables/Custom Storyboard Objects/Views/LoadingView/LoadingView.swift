//
//  LoadingView.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import UIKit

class LoadingView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet var loadingMessage: CLSubHeader!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private (set) var viewHasBeenSetup = false
    private (set) var loadingIsShown = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewBounds()
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViewBounds()
        
        setupView()
    }
    
    func setupViewBounds() {
        
        if(!viewHasBeenSetup) {
            let name = String(describing: type(of: self))
            
            Bundle.main.loadNibNamed(name, owner: self, options: nil)
            
            self.addSubview(self.view)
            
            self.view.frame = self.bounds
            self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            viewHasBeenSetup = true
        }
    }
    
    func setupView() {
        
        self.backgroundColor = .clear
        self.view.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.75)
        
        loadingMessage.textColor = .white
        activityIndicator.color = .white
        
        setLoading(isLoading: false)
    }
    
    func setLoading(isLoading: Bool) {
        
        self.loadingIsShown = isLoading
        
        DispatchQueue.main.async {
            
            self.isHidden = !isLoading
            self.view.isHidden = !isLoading
            self.activityIndicator.isHidden = !isLoading
            
            if(isLoading) {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
                self.loadingMessage.text = "Please wait a second..."
            }
            
        }
        self.loadingIsShown = isLoading
    }
    
    func updateLoadingMessage(message: String) {
        
        // All messages should be short and end with '...'
        var msg = message
        
        if(!msg.hasSuffix("...")) {
            msg.removeAll(where: { $0 == "." })
            msg.append("...")
        }
        
        self.loadingMessage.fadeTransition(0.4)
        self.loadingMessage.text = msg
    }

}
