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
    
    func testViewShowcasePresenterView_DidGetImageData_DataIsNil() {
        // Arrange
        let DATA: Data? = nil
        
        let NOT_FOUND_IMAGE = UIImage(named: "image-not-found", in: Bundle(identifier: "CodeLathe-Test"), compatibleWith: nil)!
        
        // Act
        viewShowcaseViewController.didGetImageData(DATA)
            
        // Assert
        XCTAssertEqual(NOT_FOUND_IMAGE, viewShowcaseViewController.projectLogo.image)
        
    }

}
