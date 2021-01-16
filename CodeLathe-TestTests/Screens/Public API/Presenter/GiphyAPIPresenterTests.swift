//
//  GiphyAPIPresenterTests.swift
//  CodeLathe-TestTests
//
//  Created by Alex Marchant on 16/01/2021.
//

import XCTest
import Mockingbird
@testable import CodeLathe_Test

class GiphyAPIPresenterTests: XCTestCase {
    
    let mockGiphyService = mock(GiphyServiceProtocol.self)
    let mockGiphyAPIPresenterDelegate = mock(GiphyAPIPresenterDelegate.self)
    let mockGiphyAPIPresenterView = mock(GiphyAPIPresenterView.self)
    
    var giphyAPIPresenter: GiphyAPIPresenter!

    override func setUpWithError() throws {
        giphyAPIPresenter = GiphyAPIPresenter(
            mockGiphyService,
            with: mockGiphyAPIPresenterView,
            delegate: mockGiphyAPIPresenterDelegate)
    }

    override func tearDownWithError() throws {
        giphyAPIPresenter = nil
        
        reset(mockGiphyService)
        reset(mockGiphyAPIPresenterView)
        reset(mockGiphyAPIPresenterDelegate)
    }
    
    func testGetGifs_Trending() {
        // Arrange
        let GIPHY_SEARCH = GiphySearch.trending
        
        let RETURNED_GIF_TREND_MODEL = GifTrendModel()
        
        let ERROR: Error? = NSError(domain: "Test", code: 404, userInfo: nil)
        
        given(mockGiphyService.getTrendingGifs(limit: 15, completion: any()))
            .will { (limit, completion) in
                completion(RETURNED_GIF_TREND_MODEL, ERROR)
            }
        
        // Act
        giphyAPIPresenter.getGifs(by: GIPHY_SEARCH)
        
        // Assert
        verify(mockGiphyService.resetTrendingSearch()).wasCalled(1)
        verify(mockGiphyService.resetSearchByTermSearch()).wasCalled(1)
        
        verify(mockGiphyService.getGifsBySearchTerm(search: any(), limit: any(), completion: any())).wasNeverCalled()
        
        verify(mockGiphyService.getTrendingGifs(limit: any(), completion: any())).wasCalled(1)
    }
    
    func testGetGifs_SearchTerm() {
        // Arrange
        let GIPHY_SEARCH = GiphySearch.bySearchTerm
        
        let RETURNED_GIF_SEARCH_MODEL = GifSearchModel()
        
        let ERROR: Error? = NSError(domain: "Test", code: 404, userInfo: nil)
        
        let SEARCH_TERM = "Codelathe"
        
        given(mockGiphyService.getGifsBySearchTerm(search: SEARCH_TERM, limit: 15, completion: any()))
            .will { (searchTerm, limit, completion) in
                completion(RETURNED_GIF_SEARCH_MODEL, ERROR)
            }
        
        // Act
        giphyAPIPresenter.getGifs(by: GIPHY_SEARCH, searchTerm: SEARCH_TERM)
        
        // Assert
        verify(mockGiphyService.resetTrendingSearch()).wasCalled(1)
        verify(mockGiphyService.resetSearchByTermSearch()).wasCalled(1)
        
        verify(mockGiphyService.getGifsBySearchTerm(search: any(), limit: any(), completion: any())).wasCalled(1)
        
        verify(mockGiphyService.getTrendingGifs(limit: any(), completion: any())).wasNeverCalled()
    }
    
    func testLoadNextGifSet_CurrentSearchIsNil() {
        // Arrange/Act
        giphyAPIPresenter.loadNextGifSet()
        
        // Assert
        verify(mockGiphyAPIPresenterView.errorOccurred(message: localizedString(forKey: "perform_a_valid_search"))).wasCalled(1)
        
        verify(mockGiphyService.getGifsBySearchTerm(search: any(), limit: any(), completion: any())).wasNeverCalled()
        
        verify(mockGiphyService.getTrendingGifs(limit: any(), completion: any())).wasNeverCalled()
    }
    
    func testGetGifsBySearchTerm_SearchIsNil() {
        // Arrange/Act
        giphyAPIPresenter.getGifsBySearchTerm(userSearch: nil)
        
        // Assert
        verify(mockGiphyService.getGifsBySearchTerm(search: any(), limit: any(), completion: any())).wasNeverCalled()
        
        verify(mockGiphyAPIPresenterView.didGetGifs(any())).wasNeverCalled()
        verify(mockGiphyAPIPresenterView.errorOccurred(message: localizedString(forKey: "perform_a_valid_search"))).wasCalled(1)
        
        XCTAssertNil(giphyAPIPresenter.currentSearch)
        XCTAssertNil(giphyAPIPresenter.currentSearchTerm)
    }
    
    func testGetGifsBySearchTerm_SearchIsEmpty() {
        // Arrange
        let SEARCH_TERM = ""
        
        // Act
        giphyAPIPresenter.getGifsBySearchTerm(userSearch: SEARCH_TERM)
        
        // Assert
        verify(mockGiphyService.getGifsBySearchTerm(search: any(), limit: any(), completion: any())).wasNeverCalled()
        
        verify(mockGiphyAPIPresenterView.didGetGifs(any())).wasNeverCalled()
        verify(mockGiphyAPIPresenterView.errorOccurred(message: localizedString(forKey: "perform_a_valid_search"))).wasCalled(1)
        
        XCTAssertNil(giphyAPIPresenter.currentSearch)
        XCTAssertNil(giphyAPIPresenter.currentSearchTerm)
    }
    
    func testGetGifsBySearchTerm_SearchIsSpaces() {
        // Arrange
        let SEARCH_TERM = "    "
        
        // Act
        giphyAPIPresenter.getGifsBySearchTerm(userSearch: SEARCH_TERM)
        
        // Assert
        verify(mockGiphyService.getGifsBySearchTerm(search: any(), limit: any(), completion: any())).wasNeverCalled()
        
        verify(mockGiphyAPIPresenterView.didGetGifs(any())).wasNeverCalled()
        verify(mockGiphyAPIPresenterView.errorOccurred(message: localizedString(forKey: "perform_a_valid_search"))).wasCalled(1)
        
        XCTAssertNil(giphyAPIPresenter.currentSearch)
        XCTAssertNil(giphyAPIPresenter.currentSearchTerm)
    }
    
    func testGetGifsBySearchTerm_Fails() {
        // Arrange
        let RETURNED_GIF_SEARCH_MODEL = GifSearchModel()
        
        let ERROR: Error? = NSError(domain: "Test", code: 404, userInfo: nil)
        
        let SEARCH_TERM = "Codelathe"
        
        given(mockGiphyService.getGifsBySearchTerm(search: SEARCH_TERM, limit: 15, completion: any()))
            .will { (searchTerm, limit, completion) in
                completion(RETURNED_GIF_SEARCH_MODEL, ERROR)
            }
        
        // Act
        giphyAPIPresenter.getGifsBySearchTerm(userSearch: SEARCH_TERM)
        
        // Assert
        verify(mockGiphyService.getGifsBySearchTerm(search: any(), limit: any(), completion: any())).wasCalled(1)
        
        verify(mockGiphyAPIPresenterView.didGetGifs(any())).wasNeverCalled()
        verify(mockGiphyAPIPresenterView.errorOccurred(message: localizedString(forKey: "general_error"))).wasCalled(1)
        
        XCTAssertEqual(GiphySearch.bySearchTerm, giphyAPIPresenter.currentSearch)
        XCTAssertEqual(SEARCH_TERM, giphyAPIPresenter.currentSearchTerm)
    }
    
    func testGetGifsBySearchTerm_Success() {
        // Arrange
        let RETURNED_GIF_SEARCH_MODEL = GifSearchModel()
        
        let ERROR: Error? = nil
        
        let SEARCH_TERM = "Codelathe"
        
        RETURNED_GIF_SEARCH_MODEL.data = [DataModel]()
        
        given(mockGiphyService.getGifsBySearchTerm(search: SEARCH_TERM, limit: 15, completion: any()))
            .will { (searchTerm, limit, completion) in
                completion(RETURNED_GIF_SEARCH_MODEL, ERROR)
            }
        
        // Act
        giphyAPIPresenter.getGifsBySearchTerm(userSearch: SEARCH_TERM)
        
        // Assert
        verify(mockGiphyService.getGifsBySearchTerm(search: any(), limit: any(), completion: any())).wasCalled(1)
        
        verify(mockGiphyAPIPresenterView.didGetGifs(any())).wasCalled(1)
        verify(mockGiphyAPIPresenterView.errorOccurred(message: any())).wasNeverCalled()
        
        XCTAssertEqual(GiphySearch.bySearchTerm, giphyAPIPresenter.currentSearch)
        XCTAssertEqual(SEARCH_TERM, giphyAPIPresenter.currentSearchTerm)
    }
    
    func testGetTrendingGifs_Error() {
        // Arrange
        let RETURNED_GIF_TREND_MODEL = GifTrendModel()
        
        let ERROR: Error? = NSError(domain: "Test", code: 404, userInfo: nil)
        
        given(mockGiphyService.getTrendingGifs(limit: 15, completion: any()))
            .will { (limit, completion) in
                completion(RETURNED_GIF_TREND_MODEL, ERROR)
            }
        
        // Act
        giphyAPIPresenter.getTrendingGifs()
        
        // Assert
        verify(mockGiphyService.getTrendingGifs(limit: 15, completion: any())).wasCalled(1)
        
        verify(mockGiphyAPIPresenterView.didGetGifs(any())).wasNeverCalled()
        verify(mockGiphyAPIPresenterView.errorOccurred(message: localizedString(forKey: "general_error"))).wasCalled(1)
        
        XCTAssertEqual(GiphySearch.trending, giphyAPIPresenter.currentSearch)
    }
    
    func testGetTrendingGifs_Success() {
        // Arrange
        let RETURNED_GIF_TREND_MODEL = GifTrendModel()
        
        let ERROR: Error? = nil
        
        RETURNED_GIF_TREND_MODEL.data = [DataModel]()
        
        given(mockGiphyService.getTrendingGifs(limit: 15, completion: any()))
            .will { (limit, completion) in
                completion(RETURNED_GIF_TREND_MODEL, ERROR)
            }
        
        // Act
        giphyAPIPresenter.getTrendingGifs()
        
        // Assert
        verify(mockGiphyService.getTrendingGifs(limit: 15, completion: any())).wasCalled(1)
        
        verify(mockGiphyAPIPresenterView.didGetGifs(any())).wasCalled(1)
        verify(mockGiphyAPIPresenterView.errorOccurred(message: any())).wasNeverCalled()
        
        XCTAssertEqual(GiphySearch.trending, giphyAPIPresenter.currentSearch)
    }
    
    func testDidTapVirtualCv() {
        // Arrange/Act
        giphyAPIPresenter.didTapVirtualCv()
        
        // Assert
        verify(mockGiphyAPIPresenterDelegate.showVirtualCv()).wasCalled(1)
    }

}
