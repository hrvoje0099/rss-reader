//
//  BaseViewModel.swift
//  InquisTask
//
//  Created by Hrvoje Vuković on 18.12.2021..
//

import FeedKit
import UIKit
import CoreData

protocol FeedsViewModelProtocol: BaseViewModelProtocol {
    var infoMessage: String? { get }
    var feedsCount: Int { get }
    
    var reloadTableView: (()->())? { get set }
    var showInfoMessageClosure: (()->())? { get set }
    
    func getFeeds()
    func getFeedImageURL(at indexPath: IndexPath) -> String
    func getFeedTitle(at indexPath: IndexPath) -> String
    func deleteFeed(at indexPath: IndexPath)
    func processRssUrl(_ textField: UITextField)
    func creteStoriesViewModel(forFeedAt indexPath: IndexPath) -> StoriesViewModel
}

final class FeedsViewModel: BaseViewModel, FeedsViewModelProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    private var feeds = [Feeds]() {
        didSet {
            self.reloadTableView?()
        }
    }
    
    private let repository: Repository
    
    // MARK: - PROTOCOL PROPERTIES

    var feedsCount: Int {
        return feeds.count
    }
    
    // MARK: - INIT
    
    init(repository: Repository = Repository()) {
        self.repository = repository
    }
    
    // MARK: - PROTOCOL METHODS
    
    func getFeeds() {
        self.isLoading = true
        
        repository.getFeeds { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let feeds):
                self.feeds = feeds
            case .failure(let error):
                self.processInfoMessage(message: error)
            }
        }
    }
    
    func getFeedImageURL(at indexPath: IndexPath) -> String {
        return feeds[indexPath.row].image ?? ""
    }
    
    func getFeedTitle(at indexPath: IndexPath) -> String {
        return feeds[indexPath.row].title
    }
    
    func deleteFeed(at indexPath: IndexPath) {
        self.isLoading = true
        
        let feedToDelete = self.feeds[indexPath.row]
        repository.deleteFeed(feed: feedToDelete) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let feeds):
                self.feeds = feeds
            case .failure(let error):
                self.processInfoMessage(message: error)
            }
        }
    }
    
    func processRssUrl(_ textField: UITextField) {
        self.isLoading = true
        
        guard let textFieldText = textField.text else {
            self.isLoading = false
            self.processInfoMessage(message: InfoMessage.wrongText)
            return
        }
        
        guard let feedURL = URL(string: textFieldText) else {
            self.isLoading = false
            self.processInfoMessage(message: InfoMessage.wrongURL)
            return
        }
        
        repository.validateFeedUrl(feedURL) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let rssFeed):
                self.saveRSSFeed(rssFeed)
                self.processInfoMessage(message: InfoMessage.feedIsValid)
            case .failure(let infoMessage):
                self.processInfoMessage(message: infoMessage)
            }
            self.isLoading = false
        }
    }
    
    func creteStoriesViewModel(forFeedAt indexPath: IndexPath) -> StoriesViewModel {
        let feedURL = self.feeds[indexPath.row].link
        return StoriesViewModel(repository, feedURL)
    }
    
    // MARK: - PRIVATE METHODS
    
    private func saveRSSFeed(_ rssFeed: RSSFeed) {
        let newFeed = Feeds(context: context)
        newFeed.title = rssFeed.title ?? ""
        newFeed.link = rssFeed.link ?? ""
        newFeed.image = rssFeed.image?.url
        
        repository.saveFeed(feed: newFeed) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let feeds):
                self.feeds = feeds
            case .failure(let infoMessage):
                self.processInfoMessage(message: infoMessage)
            }
        }
    }
}