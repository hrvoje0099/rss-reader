//
//  ImageLoader.swift
//  InquisTask
//
//  Created by Hrvoje Vuković on 19.12.2021..
//

import UIKit

enum ImageRequestError: Error {
    case noData
    case dataDecodingError
    case apiError
    case invalidResponse
}

final class ImageLoader {
    private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    func loadImage(_ link: String, _ completion: @escaping (Result<UIImage, ImageRequestError>) -> Void) -> UUID? {
        guard let url = URL(string: link) else { return nil }
        
        if let image = loadedImages[url] {
//            print("image cached")
            completion(.success(image))
            return nil
        }
        
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) { [unowned self] data, response, error in
            defer { self.runningRequests.removeValue(forKey: uuid) }
            
            guard error == nil else {
                completion(.failure(.apiError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, !(200...299).contains(statusCode) {
                print("Status code: \(statusCode)")
                completion(.failure(.invalidResponse))
                return
            }
            
            if let image = UIImage(data: data) {
                self.loadedImages[url] = image
                completion(.success(image))
                return
            }
            
        }
        task.resume()
        
        runningRequests[uuid] = task
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
