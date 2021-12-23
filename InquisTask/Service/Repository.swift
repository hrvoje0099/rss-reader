//
//  Repository.swift
//  InquisTask
//
//  Created by Hrvoje Vuković on 22.12.2021..
//

import Foundation
import FeedKit

struct Repository {
    
    private let feedClient: FeedClient
    
    // MARK: - INIT
    
    init(feedClient: FeedClient = FeedClient()) {
        self.feedClient = feedClient
    }
    
    // MARK: - METHODS

    func getFeeds(completion: @escaping (Result<[Feeds], RequestError>) -> Void) {
        feedClient.getFeeds { result in
            switch result {
            case .success(let feeds):
                completion(.success(feeds))
            case .failure(let requestError):
                completion(.failure(requestError))
            }
        }
    }
    
    func deleteFeed(feed: Feeds, completion: @escaping (Result<[Feeds], RequestError>) -> Void) {
        feedClient.deleteFeed(feed: feed) { result in
            switch result {
            case .success(let feeds):
                completion(.success(feeds))
            case .failure(let requestError):
                completion(.failure(requestError))
            }
        }
    }
    
    func validateFeedUrl(_ feedURL: URL, completion: @escaping (Result<RSSFeed, RequestError>) -> Void) {
        feedClient.validateFeedUrl(feedURL) { result in
            switch result {
            case .success(let rssFeed):
                completion(.success(rssFeed))
            case .failure(let requestError):
                completion(.failure(requestError))
            }
        }
    }
    
    func saveFeed(feed: Feeds, completion: @escaping (Result<[Feeds], RequestError>) -> Void) {
        feedClient.saveFeed(feed: feed) { result in
            switch result {
            case .success(let rssFeed):
                completion(.success(rssFeed))
            case .failure(let requestError):
                completion(.failure(requestError))
            }
        }
    }
    
    func getStories(feedURL: String, completion: @escaping (Result<Feed, RequestError>) -> Void) {
        feedClient.getStories(feedURL: feedURL) { result in
            switch result {
            case .success(let feed):
                completion(.success(feed))
            case .failure(let requestError):
                completion(.failure(requestError))
            }
        }
    }
}
