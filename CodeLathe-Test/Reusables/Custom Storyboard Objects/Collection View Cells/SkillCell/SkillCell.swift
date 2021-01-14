//
//  SkillCell.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 13/01/2021.
//

import UIKit

class SkillCell: UICollectionViewCell {
    
    @IBOutlet private var view: UIView!
    @IBOutlet private var skillLabel: CLHeader!
    
    var model: SkillCellModel! {
        didSet {
            self.skillLabel.text = model.skill
            
            setupDropShadow()
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
        self.backgroundColor = UIColor.appColor(.skillCellBackground)!
        self.view.backgroundColor = UIColor.appColor(.skillCellBackground)!
        self.skillLabel.textColor = .white
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = self.frame.height / 2
        self.contentView.layer.masksToBounds = true
    }
    
    private func setupDropShadow() {
        
        if(self.traitCollection.userInterfaceStyle == .light) {
            
            self.layer.shadowColor = UIColor.lightGray.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
            self.layer.shadowRadius = 3.0
            self.layer.shadowOpacity = 1.0
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

}
