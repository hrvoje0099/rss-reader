//
//  StoriesViewModel.swift
//  InquisTask
//
//  Created by Hrvoje Vuković on 19.12.2021..
//

import Foundation
import FeedKit

protocol StroriesViewModelProtocol {
    var feedStoriesCount: Int { get }
    
    func getStories()
    func getStoryCreatedDate(at indexPath: IndexPath) -> String
    func getStoryTitle(at indexPath: IndexPath) -> String
    func getStoryLink(at indexPath: IndexPath) -> URL?
    func getTitle() -> String
}

final class StoriesViewModel: BaseViewModel, StroriesViewModelProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    private var feed = Feed() {
        didSet {
            self.reloadTableView?()
        }
    }
    
    private let repository: Repository
    private let feedURL: String
    
    // MARK: - PROTOCOL PROPERTIES
    
    var feedStoriesCount: Int {
        return feed.stories?.count ?? 0
    }
    
    // MARK: - INIT
    
    init(_ repository: Repository, _ feedURL: String) {
        self.repository = repository
        self.feedURL = feedURL
    }
    
    // MARK: - PROTOCOL METHODS
    
    func getStories() {
        self.isLoading = true
        
        repository.getStories(feedURL: feedURL) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let feed):
                self.feed = feed
            case .failure(let infoMessage):
                self.processInfoMessage(message: infoMessage)
            }
        }
    }
    
    func getStoryCreatedDate(at indexPath: IndexPath) -> String {
        let createdDate = feed.stories?[indexPath.row].pubDate?.ISO8601Format() ?? ""
        let createdDateFormatted = DateFormatter.formatter.convertDateFormat(inputDate: createdDate)
        return createdDateFormatted
    }
    
    func getStoryTitle(at indexPath: IndexPath) -> String {
        return feed.stories?[indexPath.row].title ?? ""
    }
    
    func getStoryLink(at indexPath: IndexPath) -> URL? {
        return URL(string: feed.stories?[indexPath.row].link ?? "")
    }
    
    func getTitle() -> String {
        return feed.title ?? ""
    }
}
