//
//  ViewShowcaseViewController.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 14/01/2021.
//

import UIKit

class ViewShowcaseViewController: UIViewController, Storyboarded {
    
    var viewShowcasePresenter: ViewShowcasePresenterProtocol!
    
    @IBOutlet weak var descriptionLabel: CLBody!
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
        
        if let _ = showcase.projectLink {
            self.takeALookButton.isEnabled = true
        } else {
            self.takeALookButton.isEnabled = false
            self.takeALookButton.setTitle(localizedString(forKey: "no_project_link"), for: .normal)
        }
    }
    
    func errorOccurred(message: String) {
        AlertHandlerService.shared.showWarningAlert(view: self, message: message)
    }
}
