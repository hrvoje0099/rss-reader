//
//  FeedsViewController.swift
//  InquisTask
//
//  Created by Hrvoje Vuković on 16.12.2021..
//

import UIKit

final class FeedsViewController: UIViewController {

    // MARK: - PRIVATE PROPERTIES
    
    private lazy var feedsView: FeedsView = {
        let feedsView = FeedsView()
        feedsView.feedsTableView.delegate = self
        feedsView.feedsTableView.dataSource = self
        return feedsView
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
        view = feedsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observer to reload table when feeds has updated
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .feedsHasUpdated, object: nil)
        
        setupNavigation()
        initViewModelBinding()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    // MARK: - PRIVATE METHODS
    
    private func setupNavigation() {
        title = "RSS Reader"
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFeedPresed))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func initViewModelBinding() {
        
        // Need to reload table when delete feed
        feedsViewModel.reloadTableView = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.reloadTableView()
            }
        }
        
        feedsViewModel.updateLoadingStatus = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let isLoading = self.feedsViewModel.isLoading
                if isLoading {
                    self.feedsView.activityIndicator.startAnimating()
                } else {
                    self.feedsView.activityIndicator.stopAnimating()
                }
            }
        }
        
        feedsViewModel.showInfoMessageClosure = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let message = self.feedsViewModel.infoMessage {
                    self.showAlert(message)
                }
            }
        }
        
        feedsViewModel.getFeeds()
    }
    
    // MARK: - SELECTORS METHODS

    @objc private func addFeedPresed() {
        feedsViewModel.addNewFeed()
    }
    
    @objc private func reloadTableView() {
        DispatchQueue.main.async {
            self.feedsView.feedsTableView.reloadData()
        }
    }
}

// MARK: - TABLE VIEW DATA SOURCE

extension FeedsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedsViewModel.feedsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.FeedCellReuseIdentifier, for: indexPath) as? FeedCell else { return UITableViewCell() }

        cell.feedImageView.loadImage(at: feedsViewModel.getFeedImageURL(at: indexPath.row))
        cell.feedNameLabel.text = feedsViewModel.getFeedTitle(at: indexPath.row)

        return cell
    }
}

// MARK: - TABLE VIEW DELEGATE

extension FeedsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        feedsViewModel.showStories(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completionHandler in
            self?.feedsViewModel.deleteFeed(at: indexPath.row)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
