//
//  VirtualCVViewController.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 13/01/2021.
//

import UIKit

class VirtualCVViewController: UIViewController, Storyboarded {
    
    var virtualCVPresenter: VirtualCVPresenterProtocol!
    
    @IBOutlet weak var cvHeaderView: CVHeaderView!
    @IBOutlet weak var skillsCollectionView: UICollectionView!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var bioLabel: CLBody!
    
    private var skillsCollectionViewDataSource: SkillsCollectionViewDataSource!
    private var galleryCollectionViewDataSource: GalleryCollectionViewDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.appColor(.background)!
        
        virtualCVPresenter.getCandidate()
        
    }

}

extension VirtualCVViewController: VirtualCVPresenterView {
    func didGetCandidate(_ candidate: Candidate) {
        
        self.title = "\(candidate.firstName) \(candidate.lastName)'s Virtual CV"
        
        cvHeaderView.model = CVHeaderViewModel(
            firstName: candidate.firstName,
            lastName: candidate.lastName,
            emailAddress: candidate.emailAddress,
            phoneNumber: candidate.phoneNumber,
            delegate: self)
        
        skillsCollectionViewDataSource = SkillsCollectionViewDataSource(
            candidateSkills: candidate.skills,
            collectionView: self.skillsCollectionView)
        
        galleryCollectionViewDataSource = GalleryCollectionViewDataSource(
            gallery: candidate.gallery,
            collectionView: galleryCollectionView,
            delegate: self)
        
        skillsCollectionView.dataSource = skillsCollectionViewDataSource
        skillsCollectionView.delegate = skillsCollectionViewDataSource
        
        galleryCollectionView.dataSource = galleryCollectionViewDataSource
        galleryCollectionView.delegate = galleryCollectionViewDataSource
        
        bioLabel.text = candidate.bio
        
    }
}

extension VirtualCVViewController: GalleryCollectionViewDataSourceDelegate {
    
    func viewShowcase(_ showcase: GalleryShowcase) {
        self.virtualCVPresenter.didTapShowcase(showcase: showcase)
    }
    
}

extension VirtualCVViewController: CVHeaderViewDelegate {
    
    func sendEmail(to email: String, name: String) {
        ContactCandidateService.shared.sendEmail(
            recipientEmail: email,
            recipientFirstName: name,
            displayedOn: self)
    }
    
}
