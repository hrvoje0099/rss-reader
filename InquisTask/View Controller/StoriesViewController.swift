//
//  StoriesViewController.swift
//  InquisTask
//
//  Created by Hrvoje Vuković on 19.12.2021..
//

import UIKit
import FeedKit

final class StoriesViewController: UIViewController {

    // MARK: - PRIVATE PROPERTIES
    
    private lazy var storiesView: StoriesView = {
        let storiesView = StoriesView()
        storiesView.storiesTableView.delegate = self
        storiesView.storiesTableView.dataSource = self
        return storiesView
    }()
    
    private var storiesViewModel: StoriesViewModel

    // MARK: - INIT
    
    init(viewModel: StoriesViewModel) {
        self.storiesViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = storiesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        initViewModelBinding()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func initViewModelBinding() {
        storiesViewModel.reloadTableView = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                // Set navigation title
                self.title = self.storiesViewModel.getTitle()
                
                self.storiesView.storiesTableView.reloadData()
            }
        }
        
        storiesViewModel.updateLoadingStatus = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let isLoading = self.storiesViewModel.isLoading 
                if isLoading {
                    self.storiesView.activityIndicator.startAnimating()
                } else {
                    self.storiesView.activityIndicator.stopAnimating()
                }
            }
        }
        
        storiesViewModel.showInfoMessageClosure = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let message = self.storiesViewModel.infoMessage {
                    self.showAlert(message)
                }
            }
        }
        
        storiesViewModel.getStories()
    }
}

// MARK: - TABLE VIEW DATA SOURCE

extension StoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storiesViewModel.feedStoriesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryCell.StoryCellReuseIdentifier, for: indexPath) as? StoryCell else { return UITableViewCell() }

        cell.storyCreatedDateLabel.text = storiesViewModel.getStoryCreatedDate(at: indexPath)
        cell.storyNameLabel.text = storiesViewModel.getStoryTitle(at: indexPath)

        return cell
    }
}

// MARK: - TABLE VIEW DELEGATE

extension StoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let pageURL = storiesViewModel.getStoryLink(at: indexPath) else { return }
        let webViewController = WebViewController(pageURL: pageURL)
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
}
