//
//  AppCoordinator.swift
//  InquisTask
//
//  Created by Hrvoje Vuković on 20.01.2022..
//

import UIKit

final class AppCoordinator {
    
    // MARK: - PROPERTIES
    
    private let navigationController = UINavigationController()
    
    private let repository = Repository()
    
    private var feedsViewModel: FeedsViewModel?
    
    // MARK: - PUBLIC API
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    func start() {
        navigationController.navigationBar.scrollEdgeAppearance = navigationController.navigationBar.standardAppearance

        feedsViewModel = FeedsViewModel(repository: repository)
        
        showFeeds()
    }
    
    // MARK: - PRIVATE HELPER METHODS
    
    private func showFeeds() {
        guard let feedsViewModel = feedsViewModel else { return }
        
        feedsViewModel.didShowStories = { [weak self] (feedURL) in
            self?.showStories(feedURL: feedURL)
        }
        
        feedsViewModel.didAddNewFeed = { [weak self] in
            self?.showAddFeedSheetViewController()
        }
        
        let feedsViewController = FeedsViewController(viewModel: feedsViewModel)
        
        navigationController.pushViewController(feedsViewController, animated: true)
    }
    
    private func showStories(feedURL: String) {
        let storiesViewModel = StoriesViewModel(repository, feedURL)
        
        storiesViewModel.didShowStory = { [weak self] (storyURL) in
            self?.showStory(storyURL: storyURL)
        }
        
        let storiesViewController = StoriesViewController(viewModel: storiesViewModel)
        
        navigationController.pushViewController(storiesViewController, animated: true)
    }
    
    private func showAddFeedSheetViewController() {
        guard let feedsViewModel = feedsViewModel else { return }
        
        let addRSSSheetVC = AddFeedViewController(viewModel: feedsViewModel)
        let navigationController = UINavigationController(rootViewController: addRSSSheetVC)

        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium()]
        }

        self.navigationController.present(navigationController, animated: true)
    }
    
    private func showStory(storyURL: URL) {
        let webViewController = WebViewController(pageURL: storyURL)
        self.navigationController.pushViewController(webViewController, animated: true)
    }
}
