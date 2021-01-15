//
//  CVHeaderView.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import UIKit

protocol CVHeaderViewDelegate {
    func sendEmail(to email: String, name: String)
}

class CVHeaderView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var fullnameLabel: CLSubTitle!
    @IBOutlet weak var emailAddressLabel: CLSubHeader!
    @IBOutlet weak var phoneNumberLabel: CLSubHeader!
    
    @IBOutlet weak var emailAddressImageView: UIButton!
    @IBOutlet weak var phoneNumberImageView: UIButton!
    
    private var delegate: CVHeaderViewDelegate?
    
    var model: CVHeaderViewModel! {
        didSet {
            
            self.delegate = model.delegate
            
            self.pictureImageView.image = UIImage(named: "cv-picture")!
            self.fullnameLabel.text = model.fullname
            self.emailAddressLabel.text = model.emailAddress
            self.phoneNumberLabel.text = model.phoneNumber
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
        
        let name = String(describing: type(of: self))
        
        Bundle.main.loadNibNamed(name, owner: self, options: nil)
        
        self.addSubview(self.view)
        
        self.view.backgroundColor = UIColor.appColor(.background)!
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.layer.masksToBounds = true
        
        setupView()
    }
    
    func setupView() {
        let emailIcon = UIImage(named: "email-icon")!.withRenderingMode(.alwaysTemplate)
        let phoneIcon = UIImage(named: "phone-icon")!.withRenderingMode(.alwaysTemplate)
        
        self.pictureImageView.layer.cornerRadius = 25
        
        emailAddressImageView.setImage(emailIcon, for: .normal)
        emailAddressImageView.tintColor = UIColor.appColor(.codeLathe)!
        
        phoneNumberImageView.setImage(phoneIcon, for: .normal)
        phoneNumberImageView.tintColor = UIColor.appColor(.codeLathe)!

    }
    
    @IBAction func sendEmail(_ sender: Any) {
        self.delegate?.sendEmail(to: model.emailAddress, name: model.fullname)
    }
    
    @IBAction func callNumber(_ sender: Any) {
        ContactCandidateService.shared.callNumber(phoneNumber: model.phoneNumber)
    }

}

extension CVHeaderView: UIGestureRecognizerDelegate {
    
}
