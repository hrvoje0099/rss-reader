//
//  AddRSSSheetViewController.swift
//  InquisTask
//
//  Created by Hrvoje Vuković on 16.12.2021..
//

import UIKit

final class AddRSSSheetViewController: UIViewController {

    // MARK: - PRIVATE PROPERTIES
    
    private lazy var addRSSView: AddRSSView = {
        let addRSSView = AddRSSView()
        return addRSSView
    }()
    
    private var feedsViewModel: FeedsViewModelProtocol

    // MARK: - INIT
    
    init(viewModel: FeedsViewModelProtocol) {
        self.feedsViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = addRSSView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setViewClosures()
        initViewModelBinding()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func setupNavigation() {
        title = "Enter RSS URL"
    }
    
    private func setViewClosures() {
        addRSSView.onProcessRssUrl = { [weak self] textField in
            guard let self = self else { return }
            
            self.feedsViewModel.processRssUrl(textField)
        }
    }
    
    private func initViewModelBinding() {
        feedsViewModel.reloadTableView = {
            NotificationCenter.default.post(name: .feedsHasUpdated, object: nil)
        }
        
        feedsViewModel.updateLoadingStatus = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let isLoading = self.feedsViewModel.isLoading 
                if isLoading {
                    self.addRSSView.activityIndicator.startAnimating()
                } else {
                    self.addRSSView.activityIndicator.stopAnimating()
                }
            }
        }
        
        feedsViewModel.showInfoMessageClosure = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let message = self.feedsViewModel.infoMessage {
                    self.addRSSView.infoLabel.text = message
                }
            }
        }
    }
}
