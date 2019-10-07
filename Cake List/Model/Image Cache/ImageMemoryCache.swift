//
//  ImageMemoryCache.swift
//  Cake List
//
//  Created by Jatinder Pal Singh Khera on 07/10/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import Foundation

class ImageMemoryCache: ImageCache, DownloaderDelegate {
   
    // MARK: - vars
    lazy private var cahce = [URL: UIImage]()
    
    private var downloader: Downloader?
    
    var delegate: ImageCacheDelegate?
    
    // MARK: - initialisation
    init(downloader: Downloader) {
        self.downloader = downloader
        self.downloader?.delegate = self
        self.downloader?.start()
    }
    
    // MARK: - ImageCache
    func imageForURL(_ url: URL, completion: @escaping (UIImage?) -> ()) {
        if let image = self.cahce[url] {
            completion(image)
            return
        }
        
        // queue image for download
        downloader?.queueURL(url)
    }
    
    // MARK: - ImageCache
    func imageForURL(_ url: URL, atIndexPath indexPath: IndexPath, completion: @escaping (UIImage?) -> ()) {
        if let image = self.cahce[url] {
            completion(image)
            return
        }
        
        // queue image for download
        downloader?.queueURL(url)
    }
    
    func isImageChached(_ url: URL) -> Bool {
        return cahce.keys.contains(url)
    }
    
    func purge() {
        self.cahce.removeAll()
    }
    
    // MARK: - DownloaderDelegate
    func downloader(didDownload from: URL, downloadData data: Data?) {
        if let image = UIImage(data: data!) {
            self.cahce[from] = image
            delegate?.imageCacheChanged(imageCahce: self, imageURL: from, image: image)
        }
    }
}
