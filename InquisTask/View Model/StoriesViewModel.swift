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
    func getStoryCreatedDate(at index: Int) -> String
    func getStoryTitle(at index: Int) -> String
    func getStoryLink(at index: Int) -> URL?
    func getTitle() -> String
    func showStory(at index: Int)
}

final class StoriesViewModel: BaseViewModel, StroriesViewModelProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    var didShowStory: ((URL) -> ())?
    
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
    
    func getStoryCreatedDate(at index: Int) -> String {
        let createdDate = feed.stories?[index].pubDate?.ISO8601Format() ?? ""
        let createdDateFormatted = DateFormatter.formatter.convertDateFormat(inputDate: createdDate)
        return createdDateFormatted
    }
    
    func getStoryTitle(at index: Int) -> String {
        return feed.stories?[index].title ?? ""
    }
    
    func getStoryLink(at index: Int) -> URL? {
        return URL(string: feed.stories?[index].link ?? "")
    }
    
    func getTitle() -> String {
        return feed.title ?? ""
    }
    
    func showStory(at index: Int) {
        guard let storyURL = getStoryLink(at: index) else { return }
        didShowStory?(storyURL)
    }
}
