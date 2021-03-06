//
//  ViewShowcaseViewController.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import UIKit

class ViewShowcaseViewController: UIViewController, Storyboarded {
    
    var viewShowcasePresenter: ViewShowcasePresenterProtocol!
    
    @IBOutlet weak var projectLogo: UIImageView!
    @IBOutlet weak var descriptionLabel: CLBody!
    @IBOutlet weak var technologiesUsedLabel: CLBody!
    @IBOutlet weak var challengesLabel: CLBody!
    @IBOutlet weak var takeALookButton: CLPrimaryButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.appColor(.background)!
        
        self.takeALookButton.setTitle(localizedString(forKey: "take_a_look"), for: .normal)

        viewShowcasePresenter.getShowcase()
    }
    
    @IBAction func takeALookButtonTapped(_ sender: Any) {
        viewShowcasePresenter.openProjectLink()
    }

}

extension ViewShowcaseViewController: ViewShowcasePresenterView {
    func didGetShowcase(_ showcase: GalleryShowcase) {
        self.title = showcase.title
        
        self.descriptionLabel.text = showcase.description
        
        showcase.technologiesUsed.forEach({
            if let techsUsed = self.technologiesUsedLabel.text {
                if(techsUsed.isEmpty) {
                    self.technologiesUsedLabel.text = "\($0)"
                } else {
                    self.technologiesUsedLabel.text = "\(techsUsed), \($0)"
                }
            } else {
                self.technologiesUsedLabel.text = "\($0)"
            }
        })
        
        // Given more time, I would display this in a more interesting format
        showcase.challenges.forEach({
            if let challenges = self.challengesLabel.text {
                if(challenges.isEmpty) {
                    self.challengesLabel.text = "\($0)"
                } else {
                    self.challengesLabel.text = "\(challenges)\n\n\n\($0)"
                }
            } else {
                self.challengesLabel.text = "\($0)"
            }
        })
        
        if let _ = showcase.projectLink {
            self.takeALookButton.isEnabled = true
        } else {
            self.takeALookButton.isEnabled = false
            self.takeALookButton.setTitle(localizedString(forKey: "no_project_link"), for: .normal)
        }
    }
    
    func didGetImageData(_ imageData: Data?) {
        guaranteeMainThread {
            if let data = imageData {
                self.projectLogo.image = UIImage(data: data)
            } else {
                self.projectLogo.image = UIImage(named: "image-not-found")!
            }
        }
        
    }
    
    func errorOccurred(message: String) {
        AlertHandlerService.shared.showWarningAlert(view: self, message: message)
    }
}
