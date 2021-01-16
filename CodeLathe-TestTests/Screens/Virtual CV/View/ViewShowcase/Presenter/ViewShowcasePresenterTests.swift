//
//  ViewShowcasePresenterTests.swift
//  CodeLathe-TestTests
//
//  Created by Alex Marchant on 16/01/2021.
//

import XCTest
import Mockingbird
@testable import CodeLathe_Test

class ViewShowcasePresenterTests: XCTestCase {
    
    let mockUrlSessionService = mock(UrlSessionServiceProtocol.self)
    let mockUIApplicationHelperService = mock(UIApplicationHelperServiceProtocol.self)
    
    let mockViewShowcasePresenterDelegate = mock(ViewShowcasePresenterDelegate.self)
    let mockViewShowcasePresenterView = mock(ViewShowcasePresenterView.self)
    
    var showcase: GalleryShowcase!
    var viewShowcasePresenter: ViewShowcasePresenter!

    override func setUpWithError() throws {
        
        showcase = GalleryShowcase(
            displayImageUrl: "https://ptfinder.app/testing",
            title: "PTFinder",
            description: "Testing",
            projectLink: "https://ptfinder.app",
            technologiesUsed: [String](),
            challenges: [String]())
        
        viewShowcasePresenter = ViewShowcasePresenter(
            showcase: showcase,
            mockUrlSessionService,
            mockUIApplicationHelperService,
            with: mockViewShowcasePresenterView,
            delegate: mockViewShowcasePresenterDelegate)
    }

    override func tearDownWithError() throws {
        viewShowcasePresenter = nil
        showcase = nil
        
        reset(mockUrlSessionService)
        reset(mockUIApplicationHelperService)
        reset(mockViewShowcasePresenterView)
        reset(mockViewShowcasePresenterDelegate)
    }
    
    func testGetShowcase_DownloadFails_ContainsError() {
        // Arrange
        let IMAGE_URL = URL(string: showcase.displayImageUrl)!
        
        let RETURNED_IMAGE_DATA: Data? = nil
        
        let HTTP_RESPONSE: HTTPURLResponse? = HTTPURLResponse(url: IMAGE_URL, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        let ERROR: Error? = NSError(domain: "Test", code: 404, userInfo: nil)
        
        
        given(mockUrlSessionService.downloadImage(
                from: IMAGE_URL,
                completion: any()))
            .will { (url, completion) in
                completion(RETURNED_IMAGE_DATA, HTTP_RESPONSE, ERROR)
            }
        
        // Act
        viewShowcasePresenter.getShowcase()
        
        // Assert
        verify(mockViewShowcasePresenterView.didGetShowcase(any())).wasCalled(1)
        verify(mockViewShowcasePresenterView.didGetImageData(any())).wasCalled(1)
        verify(mockViewShowcasePresenterView.errorOccurred(message: any())).wasCalled(1)
        
        verify(mockUrlSessionService.downloadImage(from: any(), completion: any())).wasCalled(1)
    }
    
    func testGetShowcase_DownloadFails_ResponseIsNil() {
        // Arrange
        let IMAGE_URL = URL(string: showcase.displayImageUrl)!
        
        let RETURNED_IMAGE_DATA: Data? = nil
        
        let HTTP_RESPONSE: HTTPURLResponse? = nil
        
        let ERROR: Error? = NSError(domain: "Test", code: 404, userInfo: nil)
        
        
        given(mockUrlSessionService.downloadImage(
                from: IMAGE_URL,
                completion: any()))
            .will { (url, completion) in
                completion(RETURNED_IMAGE_DATA, HTTP_RESPONSE, ERROR)
            }
        
        // Act
        viewShowcasePresenter.getShowcase()
        
        // Assert
        verify(mockViewShowcasePresenterView.didGetShowcase(any())).wasCalled(1)
        verify(mockViewShowcasePresenterView.didGetImageData(any())).wasCalled(1)
        verify(mockViewShowcasePresenterView.errorOccurred(message: any())).wasCalled(1)
        
        verify(mockUrlSessionService.downloadImage(from: any(), completion: any())).wasCalled(1)
    }
    
    func testGetShowcase_DownloadFails_ResposneIsNot200() {
        // Arrange
        let IMAGE_URL = URL(string: showcase.displayImageUrl)!
        
        let RETURNED_IMAGE_DATA: Data? = UIImage(named: "codelathe-logo", in: Bundle(identifier: "CodeLathe-Test"), compatibleWith: nil)!.imageData
        
        let HTTP_RESPONSE: HTTPURLResponse? = HTTPURLResponse(url: IMAGE_URL, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        let ERROR: Error? = NSError(domain: "Test", code: 404, userInfo: nil)
        
        
        given(mockUrlSessionService.downloadImage(
                from: IMAGE_URL,
                completion: any()))
            .will { (url, completion) in
                completion(RETURNED_IMAGE_DATA, HTTP_RESPONSE, ERROR)
            }
        
        // Act
        viewShowcasePresenter.getShowcase()
        
        // Assert
        verify(mockViewShowcasePresenterView.didGetShowcase(any())).wasCalled(1)
        verify(mockViewShowcasePresenterView.didGetImageData(any())).wasCalled(1)
        verify(mockViewShowcasePresenterView.errorOccurred(message: any())).wasCalled(1)
        
        verify(mockUrlSessionService.downloadImage(from: any(), completion: any())).wasCalled(1)
    }
    
    func testGetShowcase_DownloadSuccessful() {
        // Arrange
        let IMAGE_URL = URL(string: showcase.displayImageUrl)!
        
        let RETURNED_IMAGE_DATA: Data? = UIImage(named: "codelathe-logo", in: Bundle(identifier: "CodeLathe-Test"), compatibleWith: nil)!.imageData
        
        let HTTP_RESPONSE: HTTPURLResponse? = HTTPURLResponse(url: IMAGE_URL, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let ERROR: Error? = nil
        
        
        given(mockUrlSessionService.downloadImage(
                from: IMAGE_URL,
                completion: any()))
            .will { (url, completion) in
                completion(RETURNED_IMAGE_DATA, HTTP_RESPONSE, ERROR)
            }
        
        // Act
        viewShowcasePresenter.getShowcase()
        
        // Assert
        verify(mockViewShowcasePresenterView.didGetShowcase(any())).wasCalled(1)
        verify(mockViewShowcasePresenterView.didGetImageData(any())).wasCalled(1)
        verify(mockViewShowcasePresenterView.errorOccurred(message: any())).wasNeverCalled()
        
        verify(mockUrlSessionService.downloadImage(from: any(), completion: any())).wasCalled(1)
    }
    
    func testOpenProjectLink_IsNil() {
        // Arrange
        showcase = GalleryShowcase(
            displayImageUrl: "https://ptfinder.app/testing",
            title: "PTFinder",
            description: "Testing",
            projectLink: nil,
            technologiesUsed: [String](),
            challenges: [String]())
        
        viewShowcasePresenter = ViewShowcasePresenter(
            showcase: showcase,
            mockUrlSessionService,
            mockUIApplicationHelperService,
            with: mockViewShowcasePresenterView,
            delegate: mockViewShowcasePresenterDelegate)
        
        // Act
        viewShowcasePresenter.openProjectLink()
        
        // Assert
        verify(mockUIApplicationHelperService.openUrl(url: any())).wasNeverCalled()
    }
    
    func testOpenProjectLink_NotNil() {
        // Arrange/Act
        viewShowcasePresenter.openProjectLink()
        
        // Assert
        verify(mockUIApplicationHelperService.openUrl(url: self.showcase.projectLink!)).wasCalled(1)
    }
}
