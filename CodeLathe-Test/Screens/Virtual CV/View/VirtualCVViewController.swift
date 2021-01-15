//
//  VirtualCVViewController.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 13/01/2021.
//

import UIKit

class VirtualCVViewController: UIViewController, Storyboarded {
    
    var virtualCVPresenter: VirtualCVPresenterProtocol!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cvHeaderView: CVHeaderView!
    @IBOutlet weak var skillsCollectionView: UICollectionView!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var bioLabel: CLBody!
    
    private var skillsCollectionViewDataSource: SkillsCollectionViewDataSource!
    private var galleryCollectionViewDataSource: GalleryCollectionViewDataSource!
    
    lazy var backSwipeGestureRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        recognizer.direction = .right
        return recognizer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.appColor(.background)!
        
        var backIcon = UIImage(named: "back-icon")!.withRenderingMode(.alwaysTemplate)
        backIcon = backIcon.withTintColor(UIColor.appColor(.body)!)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backIcon, style: .done, target: self, action: #selector(goBack))
        
        virtualCVPresenter.getCandidate()
        
        self.view.addGestureRecognizer(backSwipeGestureRecognizer)
        
    }
    
    @objc func goBack() {
        virtualCVPresenter.goBack()
    }

}

extension VirtualCVViewController: VirtualCVPresenterView {
    func didGetCandidate(_ candidate: Candidate) {
        self.title = String(format: localizedString(forKey: "virtual_cv"), candidate.firstName, candidate.lastName)
        
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
