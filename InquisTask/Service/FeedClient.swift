//
//  FeedClient.swift
//  InquisTask
//
//  Created by Hrvoje Vuković on 21.12.2021..
//

import UIKit
import FeedKit

enum RequestError: Error {
    case getFeedsError
    case deleteFeedError
    case saveFeedError
    case storiesUrlError
    case networkingError(Error)
    case pageNotFound
    case serverError(Int)
    case requestFailed(Int)
    case feedParsingError(Error)
    case wrongModel
}

struct FeedClient {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - PUBLIC METHODS
    
    func getFeeds(completion: @escaping (Result<[Feeds], RequestError>) -> Void) {
        getFeeds(completion)
    }
    
    func deleteFeed(feed: Feeds, completion: @escaping (Result<[Feeds], RequestError>) -> Void) {
        self.context.delete(feed)
        
        do {
            try self.context.save()
        } catch {
            completion(.failure(.deleteFeedError))
        }
                
        getFeeds(completion)
    }
    
    func validateFeedUrl(_ feedURL: URL, completion: @escaping (Result<RSSFeed, RequestError>) -> Void) {
        let feedParser = FeedParser(URL: feedURL)
        feedParser.parseAsync { result in

            switch result {
            case .success(let feed):
                if let rssFeed = feed.rssFeed {
                    completion(.success(rssFeed))
                } else {
                    completion(.failure(.wrongModel))
                }
            case .failure(let error):
                completion(.failure(.feedParsingError(error)))
            }
        }
    }
    
    func saveFeed(feed: Feeds, completion: @escaping (Result<[Feeds], RequestError>) -> Void) {
        do {
            try self.context.save()
        } catch {
            completion(.failure(.saveFeedError))
        }
                
        getFeeds(completion)
    }
    
    func getStories(feedURL: String, completion: @escaping (Result<Feed, RequestError>) -> Void) {
        guard let feedURL = URL(string: feedURL) else {
            completion(.failure(.storiesUrlError))
            return
        }
        
        let urlRequest = URLRequest(url: feedURL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.networkingError(error)))
                    return
                }
                
                let http = response as! HTTPURLResponse
                switch http.statusCode {
                case 200:
                    if let data = data {
                        self.loadFeed(data: data, completion: completion)
                    }
                    
                case 404:
                    completion(.failure(.pageNotFound))
                    
                case 500...599:
                    completion(.failure(.serverError(http.statusCode)))
                    
                default:
                    completion(.failure(.requestFailed(http.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func getFeeds(_ completion: (Result<[Feeds], RequestError>) -> Void) {
        do {
            let feeds = try context.fetch(Feeds.fetchRequest())
            completion(.success(feeds))
        } catch {
            completion(.failure(.getFeedsError))
        }
    }
    
    private func loadFeed(data: Data, completion: @escaping (Result<Feed, RequestError>) -> Void) {
        let parser = FeedParser(data: data)
        parser.parseAsync { parseResult in
            let result: Result<Feed, RequestError>
            
            do {
                switch parseResult {
                case .success(let feed):
                    if let rssFeed = feed.rssFeed {
                        result = try .success(self.convert(rss: rssFeed))
                    } else {
                        result = .failure(.wrongModel)
                    }
                case .failure(let error):
                    result = .failure(.feedParsingError(error))
                }
            } catch let error as RequestError {
                result = .failure(error)
            } catch {
                fatalError()
            }
            
            completion(result)
        }
    }
    
    private func convert(rss: RSSFeed) throws -> Feed {
        var feed = Feed()
        feed.title = rss.title
        feed.stories = rss.items
        return feed
    }
}
