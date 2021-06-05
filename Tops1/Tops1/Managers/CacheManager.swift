//
//  CacheManager.swift
//  Tops1
//
//  Created by Alexander Farber on 05.06.21.
//

import UIKit

class CacheManager {
    static let instance = CacheManager()
    private init() {}

    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 100 * 1024 * 1024
        return cache
    }()

    func add(image: UIImage, name: String) {
        imageCache.setObject(image, forKey: name as NSString)
    }

    func remove(name: String) {
        imageCache.removeObject(forKey: name as NSString)
    }

    func get(name: String) -> UIImage? {
        return imageCache.object(forKey: name as NSString)
    }
}
