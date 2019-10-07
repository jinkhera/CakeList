//
//  ImageCache.swift
//  Cake List
//
//  Created by Jatinder Pal Singh Khera on 07/10/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import Foundation

protocol ImageCache {
    func imageForURL(_ url: URL, completion: @escaping (UIImage?) -> ())
    func isImageChached(_ url: URL) -> Bool
    func purge()
    
    var delegate: ImageCacheDelegate? { get set }
}

protocol ImageCacheDelegate {
    func imageCacheChanged(imageCahce: ImageCache, imageURL: URL)
    func imageCacheChanged(imageCahce: ImageCache, imageURL: URL, image: UIImage?)
}
