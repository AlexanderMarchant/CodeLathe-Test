//
//  GiphyAPIViewController.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 13/01/2021.
//

import UIKit

class GiphyAPIViewController: UIViewController, Storyboarded {
    
    var giphyAPIPresenter: GiphyAPIPresenterProtocol!
    
    @IBOutlet weak var giphyTableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var placeholderSearchButton: UIButton!
    @IBOutlet weak var placeholderSearchTextField: UITextField!
    @IBOutlet weak var searchTextFieldContainerView: UIView!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var loadingView: LoadingView!
    
    internal var giphyTableViewDataSource: GiphyTableViewDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = localizedString(forKey: "gift_of_gifs")
        
        self.view.backgroundColor = UIColor.appColor(.background)!
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: localizedString(forKey: "trending"), style: .plain, target: self, action: #selector(showTrendingGifsTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "CV", style: .plain, target: self, action: #selector(virtualCvTapped))
        
        self.toolbarView.addTopBorder(with: UIColor.appColor(.borders)!, andWidth: 1)
        self.toolbarView.backgroundColor = UIColor.appColor(.background)!
        
        self.searchTextFieldContainerView.addTopBorder(with: UIColor.appColor(.borders)!, andWidth: 1)
        self.searchTextFieldContainerView.backgroundColor = UIColor.appColor(.background)!
        
        toolbarView.sizeToFit()
        placeholderSearchTextField.inputAccessoryView = toolbarView
        setupTextFields()
        
        placeholderSearchButton.titleLabel?.font = Fonts.buttonFont
        placeholderSearchButton.setTitleColor(UIColor.appColor(.body), for: .normal)
        placeholderSearchButton.isEnabled = false
        
        searchButton.titleLabel?.font = Fonts.buttonFont
        searchButton.setTitleColor(UIColor.appColor(.body), for: .normal)
        
        giphyAPIPresenter.getGifs(by: .trending, searchTerm: nil)
        
        setLoading(isLoading: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setupTextFields()
    }
    
    @objc func showTrendingGifsTapped() {
        clearTableView()
        setLoading(isLoading: true)
        giphyAPIPresenter.getGifs(by: .trending, searchTerm: nil)
    }
    
    @objc func virtualCvTapped() {
        giphyAPIPresenter.didTapVirtualCv()
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        clearTableView()
        setLoading(isLoading: true)
        giphyAPIPresenter.getGifs(by: .bySearchTerm, searchTerm: searchTextField.text)
        self.searchTextField.text = ""
    }
    
    func setLoading(isLoading: Bool) {
        guaranteeMainThread {
            self.loadingView.setLoading(isLoading: isLoading)
            self.navigationItem.leftBarButtonItem?.isEnabled = !isLoading
        }
    }
    
    func setupTextFields() {
        
        placeholderSearchTextField.layer.masksToBounds = true
        placeholderSearchTextField.layer.cornerRadius = Constants.buttonCornerRadius
        placeholderSearchTextField.layer.borderWidth = 1
        placeholderSearchTextField.layer.borderColor = UIColor.appColor(.borders)!.cgColor
        placeholderSearchTextField.backgroundColor = UIColor.appColor(.background)!
        
        searchTextField.layer.masksToBounds = true
        searchTextField.layer.cornerRadius = Constants.buttonCornerRadius
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.appColor(.borders)!.cgColor
        searchTextField.backgroundColor = UIColor.appColor(.background)!
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.searchTextFieldContainerView.isHidden = true
                self.view.frame.origin.y -= (keyboardSize.height - searchTextFieldContainerView.frame.height)
            }
            
            self.placeholderSearchTextField.text = ""
            self.searchTextField.becomeFirstResponder()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            self.searchTextFieldContainerView.isHidden = false
        }
        self.placeholderSearchTextField.text = ""
    }
    
    func clearTableView() {
        self.giphyTableViewDataSource?.removeAllGifs()
        
        guaranteeMainThread {
            self.giphyTableView.reloadData()
            self.dismissKeyboard()
        }
    }

}

extension GiphyAPIViewController: GiphyAPIPresenterView {
    func didGetGifs(_ gifs: [GiphyCellViewModel]) {
        
        setLoading(isLoading: false)
        
        if let _ = self.giphyTableViewDataSource {
            self.giphyTableViewDataSource!.insertGifs(gifs: gifs)
            
            var currentCount = gifs.count
            
            guaranteeMainThread {
                self.giphyTableView.beginUpdates()
                
                gifs.forEach({ x in
                    self.giphyTableView.insertRows(
                        at: [
                            IndexPath(
                                row: self.giphyTableViewDataSource!.gifs.count - currentCount,
                                section: 0
                            )
                        ],
                        with: .bottom)
                    currentCount -= 1
                })
                
                self.giphyTableView.endUpdates()
            }
            
        } else {
            
            self.giphyTableViewDataSource = GiphyTableViewDataSource(
                gifs: gifs,
                tableView: self.giphyTableView,
                delegate: self)
            
            self.giphyTableView.dataSource = self.giphyTableViewDataSource!
            self.giphyTableView.delegate = self.giphyTableViewDataSource!
            
            guaranteeMainThread {
                self.giphyTableView.reloadData()
            }
            
        }
    }
}

extension GiphyAPIViewController: GiphyTableViewDataSourceDelegate {
    func loadNextGifSet() {
        self.giphyAPIPresenter.loadNextGifSet()
    }
    
    func errorOccurred(message: String) {
        setLoading(isLoading: false)
        AlertHandlerService.shared.showWarningAlert(view: self, message: message)
        clearTableView()
    }
}
