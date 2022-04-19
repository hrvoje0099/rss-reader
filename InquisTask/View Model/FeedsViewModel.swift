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
    func getFeedImageURL(at index: Int) -> String
    func getFeedTitle(at index: Int) -> String
    func deleteFeed(at index: Int)
    func processRssUrl(_ textField: UITextField)
    func showStories(at index: Int)
    func addNewFeed()
}

final class FeedsViewModel: BaseViewModel, FeedsViewModelProtocol {
    
    // MARK: - PROPERTIES
    
    var didShowStories: ((String) -> ())?
    var didAddNewFeed: (() -> ())?
    
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
    
    init(repository: Repository) {
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
    
    func getFeedImageURL(at index: Int) -> String {
        return feeds[index].image ?? ""
    }
    
    func getFeedTitle(at index: Int) -> String {
        return feeds[index].title
    }
    
    func deleteFeed(at index: Int) {
        self.isLoading = true
        
        let feedToDelete = self.feeds[index]
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
        
        // For testing purpose
        #if DEBUG
        textField.text = "https://www.index.hr/rss/sport"
        #endif
        
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
    
    func showStories(at index: Int) {
        let feedURL = self.feeds[index].link
        didShowStories?(feedURL)
    }
    
    func addNewFeed() {
        didAddNewFeed?()
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
