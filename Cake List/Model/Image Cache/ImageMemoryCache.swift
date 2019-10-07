//
//  ImageMemoryCache.swift
//  Cake List
//
//  Created by Jatinder Pal Singh Khera on 07/10/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import Foundation

@objc class ImageMemoryCache: NSObject, ImageCache, DownloaderDelegate {

    // MARK: - vars
    lazy private var cahce = [URL: UIImage?]()
    lazy private var imageSizes = [URL: Double]()
    
    private var downloader: Downloader?
    
    var delegate: ImageCacheDelegate?
    
    // MARK: - initialisation
    init(downloader: Downloader) {
        super.init()
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
        
        // failed image download
        if self.cahce.keys.contains(url) {
            completion(nil)
            return
        }
        
        // queue image for download
        downloader?.queueURL(url)
    }
    
    func imageForURL(_ url: URL, resizeTo width: Double, completion: @escaping (UIImage?) -> ()) {
        self.imageSizes[url] = width
        if let image = self.cahce[url] {
            completion(image)
            return
        }
        
        // failed image download
        if self.cahce.keys.contains(url) {
            completion(nil)
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
            if let newWidth = self.imageSizes[from], newWidth > 0 {
                let image = image.resize(newWidth: CGFloat(newWidth))
                self.cahce[from] = image
            } else {
                self.cahce[from] = image
            }
            
            delegate?.imageCacheChanged(imageCahce: self, imageURL: from, image: image)
        } else {
            self.cahce[from] = UIImage(named: "default-image")
        }
    }
}
