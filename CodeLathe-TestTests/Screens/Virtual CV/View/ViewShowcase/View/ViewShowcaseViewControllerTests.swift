//
//  ViewShowcaseViewControllerTests.swift
//  CodeLathe-TestTests
//
//  Created by Alex Marchant on 16/01/2021.
//

import XCTest
import Mockingbird
@testable import CodeLathe_Test

class ViewShowcaseViewControllerTests: XCTestCase {
    
    let mockViewShowcasePresenter = mock(ViewShowcasePresenterProtocol.self)
    
    var viewShowcaseViewController: ViewShowcaseViewController!

    override func setUpWithError() throws {
        viewShowcaseViewController = ViewShowcaseViewController.instantiate(storyboard: "ViewShowcase")
        
        viewShowcaseViewController.viewShowcasePresenter = mockViewShowcasePresenter
        
        // Load and test the view
        XCTAssertNotNil(viewShowcaseViewController.view)
        
        reset(mockViewShowcasePresenter)
    }

    override func tearDownWithError() throws {
        viewShowcaseViewController = nil
        
        reset(mockViewShowcasePresenter)
    }
    
    func testOutletTypes() {
        XCTAssertTrue((viewShowcaseViewController.projectLogo as Any) is UIImageView)
        XCTAssertTrue((viewShowcaseViewController.descriptionLabel as Any) is CLBody)
        XCTAssertTrue((viewShowcaseViewController.technologiesUsedLabel as Any) is CLBody)
        XCTAssertTrue((viewShowcaseViewController.challengesLabel as Any) is CLBody)
        XCTAssertTrue((viewShowcaseViewController.takeALookButton as Any) is CLPrimaryButton)
    }
    
    func testViewDidLoad() {
        // Arrange/Act
        viewShowcaseViewController.viewDidLoad()
        
        // Assert
        XCTAssertEqual(UIColor.appColor(.background)!, viewShowcaseViewController.view.backgroundColor)
        
        XCTAssertEqual(localizedString(forKey: "take_a_look"), viewShowcaseViewController.takeALookButton.currentTitle)
        
        verify(mockViewShowcasePresenter.getShowcase()).wasCalled(1)
    }
    
    func testTakeALookButtonTapped() {
        // Arrange/Act
        viewShowcaseViewController.takeALookButtonTapped((Any).self)
        
        // Assert
        verify(mockViewShowcasePresenter.openProjectLink()).wasCalled(1)
    }
    
    func testViewShowcasePresenterView_DidGetShowcase_ProjectLinkIsNil() {
        // Arrange
        let DISPLAY_IMAGE_URL = "https://ptfinder.app/testing"
        let TITLE = "Test"
        let DESCRIPTION = "Testing"
        let PROJECT_LINK: String? = nil
        
        let TECHNOLOGIES_USED = ["Tech 1", "Tech 2", "Tech 3"]
        let CHALLENGES = ["Test 1", "Test 2", "Test 3"]
        
        let EXPECTED_TECHNOLOGIES_USED_STRING = "Tech 1, Tech 2, Tech 3"
        let EXPECTED_CHALLENGES_STRING = "Test 1\n\n\nTest 2\n\n\nTest 3"
        
        let SHOWCASE = GalleryShowcase(
            displayImageUrl: DISPLAY_IMAGE_URL,
            title: TITLE,
            description: DESCRIPTION,
            projectLink: PROJECT_LINK,
            technologiesUsed: TECHNOLOGIES_USED,
            challenges: CHALLENGES)
        
        // Act
        viewShowcaseViewController.didGetShowcase(SHOWCASE)
        
        // Assert
        XCTAssertEqual(TITLE, viewShowcaseViewController.title)
        XCTAssertEqual(DESCRIPTION, viewShowcaseViewController.descriptionLabel.text)
        XCTAssertEqual(EXPECTED_TECHNOLOGIES_USED_STRING, viewShowcaseViewController.technologiesUsedLabel.text)
        XCTAssertEqual(EXPECTED_CHALLENGES_STRING, viewShowcaseViewController.challengesLabel.text)
        
        XCTAssertEqual(localizedString(forKey: "no_project_link"), viewShowcaseViewController.takeALookButton.currentTitle)
        XCTAssertFalse(viewShowcaseViewController.takeALookButton.isEnabled)
    }
    
    func testViewShowcasePresenterView_DidGetShowcase_TechnologiesUsedIsEmpty() {
        // Arrange
        let DISPLAY_IMAGE_URL = "https://ptfinder.app/testing"
        let TITLE = "Test"
        let DESCRIPTION = "Testing"
        let PROJECT_LINK: String? = "https://ptfinder.app"
        
        let TECHNOLOGIES_USED = [String]()
        let CHALLENGES = ["Test 1", "Test 2", "Test 3"]
        
        let EXPECTED_TECHNOLOGIES_USED_STRING = ""
        let EXPECTED_CHALLENGES_STRING = "Test 1\n\n\nTest 2\n\n\nTest 3"
        
        let SHOWCASE = GalleryShowcase(
            displayImageUrl: DISPLAY_IMAGE_URL,
            title: TITLE,
            description: DESCRIPTION,
            projectLink: PROJECT_LINK,
            technologiesUsed: TECHNOLOGIES_USED,
            challenges: CHALLENGES)
        
        // Act
        viewShowcaseViewController.didGetShowcase(SHOWCASE)
        
        // Assert
        XCTAssertEqual(TITLE, viewShowcaseViewController.title)
        XCTAssertEqual(DESCRIPTION, viewShowcaseViewController.descriptionLabel.text)
        XCTAssertEqual(EXPECTED_TECHNOLOGIES_USED_STRING, viewShowcaseViewController.technologiesUsedLabel.text)
        XCTAssertEqual(EXPECTED_CHALLENGES_STRING, viewShowcaseViewController.challengesLabel.text)
        
        XCTAssertEqual(localizedString(forKey: "take_a_look"), viewShowcaseViewController.takeALookButton.currentTitle)
        XCTAssertTrue(viewShowcaseViewController.takeALookButton.isEnabled)
    }
    
    func testViewShowcasePresenterView_DidGetShowcase_ChallengesIsEmpty() {
        // Arrange
        let DISPLAY_IMAGE_URL = "https://ptfinder.app/testing"
        let TITLE = "Test"
        let DESCRIPTION = "Testing"
        let PROJECT_LINK: String? = "https://ptfinder.app"
        
        let TECHNOLOGIES_USED = ["Tech 1", "Tech 2", "Tech 3"]
        let CHALLENGES = [String]()
        
        let EXPECTED_TECHNOLOGIES_USED_STRING = "Tech 1, Tech 2, Tech 3"
        let EXPECTED_CHALLENGES_STRING = ""
        
        let SHOWCASE = GalleryShowcase(
            displayImageUrl: DISPLAY_IMAGE_URL,
            title: TITLE,
            description: DESCRIPTION,
            projectLink: PROJECT_LINK,
            technologiesUsed: TECHNOLOGIES_USED,
            challenges: CHALLENGES)
        
        // Act
        viewShowcaseViewController.didGetShowcase(SHOWCASE)
        
        // Assert
        XCTAssertEqual(TITLE, viewShowcaseViewController.title)
        XCTAssertEqual(DESCRIPTION, viewShowcaseViewController.descriptionLabel.text)
        XCTAssertEqual(EXPECTED_TECHNOLOGIES_USED_STRING, viewShowcaseViewController.technologiesUsedLabel.text)
        XCTAssertEqual(EXPECTED_CHALLENGES_STRING, viewShowcaseViewController.challengesLabel.text)
        
        XCTAssertEqual(localizedString(forKey: "take_a_look"), viewShowcaseViewController.takeALookButton.currentTitle)
        XCTAssertTrue(viewShowcaseViewController.takeALookButton.isEnabled)
    }
    
    func testViewShowcasePresenterView_DidGetImageData_DataIsNil() {
        // Arrange
        let DATA: Data? = nil
        
        let NOT_FOUND_IMAGE = UIImage(named: "image-not-found", in: Bundle(identifier: "CodeLathe-Test"), compatibleWith: nil)!
        
        // Act
        viewShowcaseViewController.didGetImageData(DATA)
            
        // Assert
        XCTAssertEqual(NOT_FOUND_IMAGE, viewShowcaseViewController.projectLogo.image)
    }
    
    func testViewShowcasePresenterView_DidGetImageData_DataIsNotNil() {
        // Arrange
        let IMAGE = UIImage(named: "codelathe-logo", in: Bundle(identifier: "CodeLathe-Test"), compatibleWith: nil)!
        
        let DATA = IMAGE.imageData
        
        // Act
        viewShowcaseViewController.didGetImageData(DATA)
            
        // Assert
        XCTAssertNotNil(viewShowcaseViewController.projectLogo.image)
    }

}
