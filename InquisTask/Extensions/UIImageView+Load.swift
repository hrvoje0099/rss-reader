//
//  UIImageView+Load.swift
//  InquisTask
//
//  Created by Hrvoje Vuković on 19.12.2021..
//

import UIKit

extension UIImageView {
    func loadImage(at url: String) {
        UIImageLoader.loader.load(url, for: self)
    }
    
    func cancelImageLoad() {
        UIImageLoader.loader.cancel(for: self)
    }
}
