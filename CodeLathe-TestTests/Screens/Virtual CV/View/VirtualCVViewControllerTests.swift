//
//  VirtualCVViewControllerTests.swift
//  CodeLathe-TestTests
//
//  Created by Alex Marchant on 16/01/2021.
//

import XCTest
import Mockingbird
@testable import CodeLathe_Test

class VirtualCVViewControllerTests: XCTestCase {
    
    let mockVirtualCVPresenter = mock(VirtualCVPresenterProtocol.self)
    
    var virtualCVViewController: VirtualCVViewController!
    
    override func setUpWithError() throws {
        virtualCVViewController = VirtualCVViewController.instantiate(storyboard: "VirtualCV")
        
        virtualCVViewController.virtualCVPresenter = mockVirtualCVPresenter
        
        // Load and test the view
        XCTAssertNotNil(virtualCVViewController.view)
        
        reset(mockVirtualCVPresenter)
    }
    
    override func tearDownWithError() throws {
        virtualCVViewController = nil
        
        reset(mockVirtualCVPresenter)
    }
    
    func testOutletTypes() {
        XCTAssertTrue((virtualCVViewController.cvHeaderView as Any) is CVHeaderView)
        XCTAssertTrue((virtualCVViewController.skillsCollectionView as Any) is UICollectionView)
        XCTAssertTrue((virtualCVViewController.galleryCollectionView as Any) is UICollectionView)
        XCTAssertTrue((virtualCVViewController.bioLabel as Any) is CLBody)
    }
    
    func testViewDidLoad() {
        // Arrange
        let BACK_ICON = UIImage(named: "back-icon",in: Bundle(identifier: "CodeLathe-Test"),compatibleWith: nil)!
            .withRenderingMode(.alwaysTemplate)
            .withTintColor(UIColor.appColor(.body)!)
        
        // Act
        virtualCVViewController.viewDidLoad()
        
        // Assert
        XCTAssertEqual(UIColor.appColor(.background)!, virtualCVViewController.view.backgroundColor)
        
        XCTAssertNotNil(virtualCVViewController.navigationItem.leftBarButtonItem?.image)
        XCTAssertEqual(BACK_ICON, virtualCVViewController.navigationItem.leftBarButtonItem!.image)
        XCTAssertEqual(#selector(VirtualCVViewController.goBack), virtualCVViewController.navigationItem.leftBarButtonItem!.action)
        
        verify(mockVirtualCVPresenter.getCandidate()).wasCalled(1)
    }
    
    func testGoBack() {
        // Arrange/Act
        virtualCVViewController.goBack()
        
        // Assert
        verify(mockVirtualCVPresenter.goBack()).wasCalled(1)
    }
    
    func testVirtualCVPresenterView_DidGetCandidate() {
        // Arrange
        let FIRST_NAME = "Alex"
        let LAST_NAME = "Marchant"
        let EMAIL = "test@test.com"
        let PHONE_NUMBER = "07711123456"
        let BIO = "Testing"
        
        let GALLERY = CandidateGallery(
            showcases: [
                GalleryShowcase(
                    displayImageUrl: "",
                    title: "",
                    description: "",
                    projectLink: "",
                    technologiesUsed: [""],
                    challenges: [""])
            ]
        )
        
        let SKILLS = [
            CandidateSkill(skill: "Test1"),
            CandidateSkill(skill: "Test2"),
            CandidateSkill(skill: "Test3"),
            CandidateSkill(skill: "Test4"),
            CandidateSkill(skill: "Test5")
        ]
        
        let CANDIDATE = Candidate(
            firstName: FIRST_NAME,
            lastName: LAST_NAME,
            emailAddress: EMAIL,
            phoneNumber: PHONE_NUMBER,
            bio: BIO,
            gallery: GALLERY,
            skills: SKILLS)
        
        let EXPECTED_TITLE = String(format: localizedString(forKey: "virtual_cv"), FIRST_NAME, LAST_NAME)
        
        // Act
        virtualCVViewController.didGetCandidate(CANDIDATE, mock(UrlSessionServiceProtocol.self))
        
        // Assert
        XCTAssertEqual(EXPECTED_TITLE, virtualCVViewController.title)
        XCTAssertEqual(BIO, virtualCVViewController.bioLabel.text)
        XCTAssertEqual(EMAIL, virtualCVViewController.cvHeaderView.model.emailAddress)
        XCTAssertEqual(PHONE_NUMBER, virtualCVViewController.cvHeaderView.model.phoneNumber)
        
        XCTAssertTrue(virtualCVViewController.skillsCollectionView.delegate is SkillsCollectionViewDataSource)
        XCTAssertTrue(virtualCVViewController.skillsCollectionView.dataSource is SkillsCollectionViewDataSource)
        
        XCTAssertTrue(virtualCVViewController.galleryCollectionView.delegate is GalleryCollectionViewDataSource)
        XCTAssertTrue(virtualCVViewController.galleryCollectionView.dataSource is GalleryCollectionViewDataSource)
    }
    
    func testGalleryCollectionViewDataSourceDelegate_ViewShowcase() {
        // Arrange
        let SHOWCASE = GalleryShowcase(
            displayImageUrl: "",
            title: "",
            description: "",
            projectLink: "",
            technologiesUsed: [String](),
            challenges: [String]())
        
        // Act
        virtualCVViewController.viewShowcase(SHOWCASE)
        
        // Assert
        verify(mockVirtualCVPresenter.didTapShowcase(showcase: any())).wasCalled(1)
    }
    
}
