//
//  VirtualCVPresenterTests.swift
//  CodeLathe-TestTests
//
//  Created by Alex Marchant on 16/01/2021.
//

import XCTest
import Mockingbird
@testable import CodeLathe_Test

class VirtualCVPresenterTests: XCTestCase {
    
    let mockUrlSessionService = mock(UrlSessionServiceProtocol.self)
    let mockVirtualCVPresenterDelegate = mock(VirtualCVPresenterDelegate.self)
    let mockVirtualCVPresenterView = mock(VirtualCVPresenterView.self)
    
    var candidate: Candidate!
    var virtualCVPresenter: VirtualCVPresenter!

    override func setUpWithError() throws {
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
        
        candidate = Candidate(
            firstName: FIRST_NAME,
            lastName: LAST_NAME,
            emailAddress: EMAIL,
            phoneNumber: PHONE_NUMBER,
            bio: BIO,
            gallery: GALLERY,
            skills: SKILLS)
        
        virtualCVPresenter = VirtualCVPresenter(
            candidate: candidate,
            mockUrlSessionService,
            with: mockVirtualCVPresenterView,
            delegate: mockVirtualCVPresenterDelegate)
    }

    override func tearDownWithError() throws {
        virtualCVPresenter = nil
        candidate = nil
        
        reset(mockUrlSessionService)
        reset(mockVirtualCVPresenterView)
        reset(mockVirtualCVPresenterDelegate)
    }
    
    func testGetCandidate() {
        // Arrange/Act
        virtualCVPresenter.getCandidate()
        
        // Assert
        verify(mockVirtualCVPresenterView.didGetCandidate(any(), self.mockUrlSessionService)).wasCalled(1)
    }
    
    func testDidTapShowcase() {
        // Arrange
        let SHOWCASE = GalleryShowcase(
            displayImageUrl: "",
            title: "",
            description: "",
            projectLink: "",
            technologiesUsed: [String](),
            challenges: [String]())
        
        // Act
        virtualCVPresenter.didTapShowcase(showcase: SHOWCASE)
        
        // Assert
        verify(mockVirtualCVPresenterDelegate.viewShowcaseInformation(any())).wasCalled(1)
    }
    
    func testGoBack() {
        // Arrange/Act
        virtualCVPresenter.goBack()
        
        // Assert
        verify(mockVirtualCVPresenterDelegate.goBack()).wasCalled(1)
    }

}
