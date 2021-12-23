//
//  UIImageLoader.swift
//  InquisTask
//
//  Created by Hrvoje Vuković on 19.12.2021..
//

import UIKit

final class UIImageLoader {
    static let loader = UIImageLoader()
    
    private let imageLoader = ImageLoader()
    private var uuidMap = [UIImageView: UUID]()
    
    private init() {}
    
    func load(_ link: String, for imageView: UIImageView) {
        
        let token = imageLoader.loadImage(link) { [unowned self] result in
            defer { self.uuidMap.removeValue(forKey: imageView) }
            
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    imageView.image = image
                }
            case .failure(let error):
                // Here is no need to show the user an error, it is enough in the console
                print("Load image from link fail! Error: \(error)")
            }
            
        }
        
        if let token = token {
            uuidMap[imageView] = token
        }
    }
    
    func cancel(for imageView: UIImageView) {
        if let uuid = uuidMap[imageView] {
            imageLoader.cancelLoad(uuid)
            uuidMap.removeValue(forKey: imageView)
        }
    }
}
