//
//  GiphyAPIViewControllerTests.swift
//  CodeLathe-TestTests
//
//  Created by Alex Marchant on 16/01/2021.
//

import XCTest
import Mockingbird
@testable import CodeLathe_Test

class GiphyAPIViewControllerTests: XCTestCase {
    
    let mockGiphyAPIPresenter = mock(GiphyAPIPresenterProtocol.self)
    
    var giphyAPIViewController: GiphyAPIViewController!
    
    override func setUpWithError() throws {
        giphyAPIViewController = GiphyAPIViewController.instantiate(storyboard: "GiphyAPI")
        
        giphyAPIViewController.giphyAPIPresenter = mockGiphyAPIPresenter
        
        // Load and test the view
        XCTAssertNotNil(giphyAPIViewController.view)
        
        reset(mockGiphyAPIPresenter)
    }
    
    override func tearDownWithError() throws {
        giphyAPIViewController = nil
        
        reset(mockGiphyAPIPresenter)
    }
    
    func testOutletTypes() {
        XCTAssertTrue((giphyAPIViewController.giphyTableView as Any) is UITableView)
        XCTAssertTrue((giphyAPIViewController.searchTextField as Any) is UITextField)
        XCTAssertTrue((giphyAPIViewController.toolbarView as Any) is UIView)
        XCTAssertTrue((giphyAPIViewController.searchButton as Any) is UIButton)
        XCTAssertTrue((giphyAPIViewController.placeholderSearchButton as Any) is UIButton)
        XCTAssertTrue((giphyAPIViewController.placeholderSearchTextField as Any) is UITextField)
        XCTAssertTrue((giphyAPIViewController.searchTextFieldContainerView as Any) is UIView)
        XCTAssertTrue((giphyAPIViewController.keyboardHeightLayoutConstraint as Any) is NSLayoutConstraint)
        XCTAssertTrue((giphyAPIViewController.loadingView as Any) is LoadingView)
    }
    
    func testViewDidLoad() {
        // Arrange/Act
        giphyAPIViewController.viewDidLoad()
        
        // Assert
        XCTAssertEqual(localizedString(forKey: "gift_of_gifs"), giphyAPIViewController.title)
        
        XCTAssertEqual(UIColor.appColor(.background)!, giphyAPIViewController.view.backgroundColor)
        
        XCTAssertNotNil(giphyAPIViewController.navigationItem.leftBarButtonItem)
        XCTAssertEqual(localizedString(forKey: "trending"), giphyAPIViewController.navigationItem.leftBarButtonItem!.title)
        XCTAssertEqual(#selector(giphyAPIViewController.showTrendingGifsTapped), giphyAPIViewController.navigationItem.leftBarButtonItem!.action)
        
        XCTAssertNotNil(giphyAPIViewController.navigationItem.rightBarButtonItem)
        XCTAssertEqual("CV", giphyAPIViewController.navigationItem.rightBarButtonItem!.title)
        XCTAssertEqual(#selector(giphyAPIViewController.virtualCvTapped), giphyAPIViewController.navigationItem.rightBarButtonItem!.action)
        
        XCTAssertEqual(UIColor.appColor(.background)!, giphyAPIViewController.toolbarView.backgroundColor)
        
        XCTAssertEqual(UIColor.appColor(.background)!, giphyAPIViewController.searchTextFieldContainerView.backgroundColor)
        
        XCTAssertEqual(giphyAPIViewController.toolbarView, giphyAPIViewController.placeholderSearchTextField.inputAccessoryView)
        
        XCTAssertEqual(Fonts.buttonFont, giphyAPIViewController.placeholderSearchButton.titleLabel?.font)
        XCTAssertEqual(UIColor.appColor(.body), giphyAPIViewController.placeholderSearchButton.titleLabel?.textColor)
        XCTAssertFalse(giphyAPIViewController.placeholderSearchButton.isEnabled)
        
        XCTAssertEqual(Fonts.buttonFont, giphyAPIViewController.searchButton.titleLabel?.font)
        XCTAssertEqual(UIColor.appColor(.body), giphyAPIViewController.searchButton.titleLabel?.textColor)
        XCTAssertTrue(giphyAPIViewController.searchButton.isEnabled)
        
        verify(mockGiphyAPIPresenter.getGifs(by: .trending, searchTerm: nil)).wasCalled(1)
        
        XCTAssertTrue(giphyAPIViewController.loadingView.loadingIsShown)
        
        XCTAssertEqual(UIColor.appColor(.background), giphyAPIViewController.placeholderSearchTextField.backgroundColor)
        XCTAssertEqual(Constants.buttonCornerRadius, giphyAPIViewController.placeholderSearchTextField.layer.cornerRadius)
        
        XCTAssertEqual(UIColor.appColor(.background), giphyAPIViewController.searchTextField.backgroundColor)
        XCTAssertEqual(Constants.buttonCornerRadius, giphyAPIViewController.searchTextField.layer.cornerRadius)
    }
    
    func testShowTrendingGifsTapped() {
        // Arrange/Act
        giphyAPIViewController.showTrendingGifsTapped()
        
        // Assert
        XCTAssertEqual(0, giphyAPIViewController.giphyTableView.numberOfRows(inSection: 0))
        
        XCTAssertTrue(giphyAPIViewController.loadingView.loadingIsShown)
        
        verify(mockGiphyAPIPresenter.getGifs(by: .trending, searchTerm: nil)).wasCalled(1)
    }
    
    func testVirtualCvTapped() {
        // Arrange/Act
        giphyAPIViewController.virtualCvTapped()
        
        // Assert
        verify(mockGiphyAPIPresenter.didTapVirtualCv()).wasCalled(1)
    }
    
    func testSearchButtonTapped() {
        // Arrange
        let SEARCH_TERM = "Codelathe"
        
        giphyAPIViewController.searchTextField.text = SEARCH_TERM
        
        // Act
        giphyAPIViewController.searchButtonTapped((Any).self)
        
        // Assert
        XCTAssertEqual(0, giphyAPIViewController.giphyTableView.numberOfRows(inSection: 0))
        
        XCTAssertTrue(giphyAPIViewController.loadingView.loadingIsShown)
        
        XCTAssertEqual("", giphyAPIViewController.searchTextField.text)
        
        verify(mockGiphyAPIPresenter.getGifs(by: .bySearchTerm, searchTerm: SEARCH_TERM)).wasCalled(1)
    }
    
    func testSetLoading_False() {
        // Arrange
        let IS_LOADING = false
        
        giphyAPIViewController.loadingView.setLoading(isLoading: true)
        giphyAPIViewController.navigationItem.leftBarButtonItem!.isEnabled = false
        
        // Act
        giphyAPIViewController.setLoading(isLoading: IS_LOADING)
        
        // Assert
        XCTAssertFalse(giphyAPIViewController.loadingView.loadingIsShown)
        XCTAssertTrue(giphyAPIViewController.navigationItem.leftBarButtonItem!.isEnabled)
    }
    
    func testSetLoading_True() {
        // Arrange
        let IS_LOADING = true
        
        // Act
        giphyAPIViewController.setLoading(isLoading: IS_LOADING)
        
        // Assert
        XCTAssertTrue(giphyAPIViewController.loadingView.loadingIsShown)
        XCTAssertFalse(giphyAPIViewController.navigationItem.leftBarButtonItem!.isEnabled)
    }
    
    func testSetupTextFields() {
        // Arrange/Act
        giphyAPIViewController.setupTextFields()
        
        // Assert
        XCTAssertTrue(giphyAPIViewController.placeholderSearchTextField.layer.masksToBounds)
        XCTAssertEqual(Constants.buttonCornerRadius, giphyAPIViewController.placeholderSearchTextField.layer.cornerRadius)
        XCTAssertEqual(1, giphyAPIViewController.placeholderSearchTextField.layer.borderWidth)
        XCTAssertEqual(UIColor.appColor(.borders)!.cgColor, giphyAPIViewController.placeholderSearchTextField.layer.borderColor)
        XCTAssertEqual(UIColor.appColor(.background)!, giphyAPIViewController.placeholderSearchTextField.backgroundColor)
        
        XCTAssertTrue(giphyAPIViewController.searchTextField.layer.masksToBounds)
        XCTAssertEqual(Constants.buttonCornerRadius, giphyAPIViewController.searchTextField.layer.cornerRadius)
        XCTAssertEqual(1, giphyAPIViewController.searchTextField.layer.borderWidth)
        XCTAssertEqual(UIColor.appColor(.borders)!.cgColor, giphyAPIViewController.searchTextField.layer.borderColor)
        XCTAssertEqual(UIColor.appColor(.background)!, giphyAPIViewController.searchTextField.backgroundColor)
    }
    
    func testKeyboardWillShow_DoesNotContainKeyboardInfo() {
        // Arrange
        let NOTIFICATION = NSNotification(
            name: UIResponder.keyboardWillShowNotification,
            object: nil,
            userInfo: [AnyHashable: Any]())
        
        giphyAPIViewController.placeholderSearchTextField.text = "Test"
        
        // Act
        giphyAPIViewController.keyboardWillShow(notification: NOTIFICATION)
        
        // Assert
        XCTAssertFalse(giphyAPIViewController.searchTextFieldContainerView.isHidden)
        XCTAssertEqual("Test", giphyAPIViewController.placeholderSearchTextField.text)
        XCTAssertEqual(0, giphyAPIViewController.view.frame.origin.y)
        XCTAssertFalse(giphyAPIViewController.searchTextField.isFirstResponder)
    }
    
    func testKeyboardWillShow_FrameOriginIs0() {
        // Arrange
        let NOTIFICATION = NSNotification(
            name: UIResponder.keyboardWillShowNotification,
            object: nil,
            userInfo: [
                UIResponder.keyboardFrameEndUserInfoKey: CGRect(x: 0, y: 0, width: 100, height: 100)
            ])
        
        let EXPECTED_VIEW_Y_ORIGIN = giphyAPIViewController.view.frame.origin.y - (100 - giphyAPIViewController.searchTextFieldContainerView.frame.height)
        
        giphyAPIViewController.placeholderSearchTextField.text = "Test"
        
        // Act
        giphyAPIViewController.keyboardWillShow(notification: NOTIFICATION)
        
        // Assert
        XCTAssertTrue(giphyAPIViewController.searchTextFieldContainerView.isHidden)
        XCTAssertEqual("", giphyAPIViewController.placeholderSearchTextField.text)
        XCTAssertEqual(EXPECTED_VIEW_Y_ORIGIN, giphyAPIViewController.view.frame.origin.y)
    }
    
    func testKeyboardWillShow_FrameOriginIsNot0() {
        // Arrange
        let NOTIFICATION = NSNotification(
            name: UIResponder.keyboardWillShowNotification,
            object: nil,
            userInfo: [
                UIResponder.keyboardFrameEndUserInfoKey: CGRect(x: 0, y: 0, width: 100, height: 100)
            ])
        
        giphyAPIViewController.placeholderSearchTextField.text = "Test"
        
        giphyAPIViewController.view.frame.origin.y = 100
        
        // Act
        giphyAPIViewController.keyboardWillShow(notification: NOTIFICATION)
        
        // Assert
        XCTAssertFalse(giphyAPIViewController.searchTextFieldContainerView.isHidden)
        XCTAssertEqual("", giphyAPIViewController.placeholderSearchTextField.text)
        XCTAssertEqual(100, giphyAPIViewController.view.frame.origin.y)
    }
    
    func testKeyboardWillHide_FrameOriginIs0() {
        // Arrange
        let NOTIFICATION = NSNotification(
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        giphyAPIViewController.placeholderSearchTextField.text = "Test"
        giphyAPIViewController.searchTextFieldContainerView.isHidden = true
        
        // Act
        giphyAPIViewController.keyboardWillHide(notification: NOTIFICATION)
        
        // Assert
        XCTAssertEqual("", giphyAPIViewController.placeholderSearchTextField.text)
        XCTAssertTrue(giphyAPIViewController.searchTextFieldContainerView.isHidden)
    }
    
    func testKeyboardWillHide_FrameOriginIsNot0() {
        // Arrange
        let NOTIFICATION = NSNotification(
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        giphyAPIViewController.placeholderSearchTextField.text = "Test"
        giphyAPIViewController.searchTextFieldContainerView.isHidden = true
        
        giphyAPIViewController.view.frame.origin.y = 100
        
        // Act
        giphyAPIViewController.keyboardWillHide(notification: NOTIFICATION)
        
        // Assert
        XCTAssertEqual("", giphyAPIViewController.placeholderSearchTextField.text)
        XCTAssertFalse(giphyAPIViewController.searchTextFieldContainerView.isHidden)
    }
    
    func testClearTableView() {
        // Arrange
        let GIFS = [
            GiphyCellViewModel(
                gifUrl: "1",
                title: "1",
                sourceUrl: "1",
                markedTrending: "1",
                username: "1"),
            GiphyCellViewModel(
                gifUrl: "2",
                title: "2",
                sourceUrl: "2",
                markedTrending: "2",
                username: "2"),
            GiphyCellViewModel(
                gifUrl: "3",
                title: "3",
                sourceUrl: "3",
                markedTrending: "3",
                username: "3")
        ]
        
        giphyAPIViewController.giphyTableViewDataSource = GiphyTableViewDataSource(
            gifs: GIFS,
            tableView: giphyAPIViewController.giphyTableView,
            delegate: giphyAPIViewController)
        
        giphyAPIViewController.giphyTableView.dataSource = giphyAPIViewController.giphyTableViewDataSource
        giphyAPIViewController.giphyTableView.delegate = giphyAPIViewController.giphyTableViewDataSource
        
        giphyAPIViewController.giphyTableView.reloadData()
        
        // Act
        giphyAPIViewController.clearTableView()
        
        // Assert
        XCTAssertEqual(0, giphyAPIViewController.giphyTableView.numberOfRows(inSection: 0))
    }
    
    func testGiphyAPIPresenterView_DidGetGifs_DataSourceIsNil() {
        // Arrange
        let NEXT_SET_OF_GIFS = [
            GiphyCellViewModel(
                gifUrl: "1",
                title: "1",
                sourceUrl: "1",
                markedTrending: "1",
                username: "1"),
            GiphyCellViewModel(
                gifUrl: "2",
                title: "2",
                sourceUrl: "2",
                markedTrending: "2",
                username: "2"),
            GiphyCellViewModel(
                gifUrl: "3",
                title: "3",
                sourceUrl: "3",
                markedTrending: "3",
                username: "3")
        ]
        
        giphyAPIViewController.setLoading(isLoading: true)
        
        // Act
        giphyAPIViewController.didGetGifs(NEXT_SET_OF_GIFS)
        
        // Assert
        XCTAssertNotNil(giphyAPIViewController.giphyTableViewDataSource)
        
        XCTAssertTrue(giphyAPIViewController.giphyTableView.dataSource is GiphyTableViewDataSource)
        XCTAssertTrue(giphyAPIViewController.giphyTableView.delegate is GiphyTableViewDataSource)
        
        XCTAssertEqual(3, giphyAPIViewController.giphyTableView.numberOfRows(inSection: 0))
        
        XCTAssertFalse(giphyAPIViewController.loadingView.loadingIsShown)
    }
    
    func testGiphyAPIPresenterView_DidGetGifs_DataSourceNotNil() {
        // Arrange
        let EXISTING_GIFS = [
            GiphyCellViewModel(
                gifUrl: "1",
                title: "1",
                sourceUrl: "1",
                markedTrending: "1",
                username: "1"),
            GiphyCellViewModel(
                gifUrl: "2",
                title: "2",
                sourceUrl: "2",
                markedTrending: "2",
                username: "2"),
            GiphyCellViewModel(
                gifUrl: "3",
                title: "3",
                sourceUrl: "3",
                markedTrending: "3",
                username: "3")
        ]
        
        let NEXT_SET_OF_GIFS = [
            GiphyCellViewModel(
                gifUrl: "4",
                title: "4",
                sourceUrl: "4",
                markedTrending: "4",
                username: "4"),
            GiphyCellViewModel(
                gifUrl: "5",
                title: "5",
                sourceUrl: "5",
                markedTrending: "5",
                username: "5"),
            GiphyCellViewModel(
                gifUrl: "6",
                title: "6",
                sourceUrl: "6",
                markedTrending: "6",
                username: "6")
        ]
        
        giphyAPIViewController.giphyTableViewDataSource = GiphyTableViewDataSource(
            gifs: EXISTING_GIFS,
            tableView: giphyAPIViewController.giphyTableView,
            delegate: giphyAPIViewController)
        
        giphyAPIViewController.giphyTableView.dataSource = giphyAPIViewController.giphyTableViewDataSource
        giphyAPIViewController.giphyTableView.delegate = giphyAPIViewController.giphyTableViewDataSource
        
        giphyAPIViewController.giphyTableView.reloadData()
        
        giphyAPIViewController.setLoading(isLoading: true)
        
        // Act
        giphyAPIViewController.didGetGifs(NEXT_SET_OF_GIFS)
        
        // Assert
        XCTAssertEqual(6, giphyAPIViewController.giphyTableView.numberOfRows(inSection: 0))
        
        XCTAssertFalse(giphyAPIViewController.loadingView.loadingIsShown)
    }
    
    func testGiphyTableViewDataSourceDelegate_LoadNextGifSet() {
        // Arrange/Act
        giphyAPIViewController.loadNextGifSet()
        
        // Assert
        verify(mockGiphyAPIPresenter.loadNextGifSet()).wasCalled(1)
    }

}
