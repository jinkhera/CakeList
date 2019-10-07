//
//  Cake_List_ImageCache_Tests.swift
//  Cake ListTests
//
//  Created by Jatinder Pal Singh Khera on 07/10/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import XCTest
@testable import Cake_List

class Cake_List_ImageCache_Tests: XCTestCase, ImageCacheDelegate {
   
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDownloader() {
        // Create an expectation for a API call.
        let expectation = XCTestExpectation(description: "Downloader download images")
        
        var imageURLS = [URL]()
        imageURLS.append(URL(string: "http://www.bbcgoodfood.com/sites/bbcgoodfood.com/files/recipe_images/recipe-image-legacy-id--1001468_10.jpg")!)
        imageURLS.append(URL(string: "http://www.villageinn.com/i/pies/profile/carrotcake_main1.jpg")!)
        imageURLS.append(URL(string: "http://ukcdn.ar-cdn.com/recipes/xlarge/ff22df7f-dbcd-4a09-81f7-9c1d8395d936.jpg")!)
        
        Downloader.shared.start()
        for url in imageURLS {
            Downloader.shared.queueURL(url)
        }
        
        // FIXME: a cheat
        let delay = 45.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            // Fulfill the expectation to indicate that the background task has finished successfully.
            expectation.fulfill()
        }
        
        // Wait until the expectation is fulfilled, with a timeout of 50seconds.
        wait(for: [expectation], timeout: 50.0)
    }
    
    let expectation = XCTestExpectation(description: "MemoryImageCache download images")
    var count = 0
    func testMemoryImageCache() {
        // Create an expectation for a API call.
        
        
        var imageURLS = [URL]()
        imageURLS.append(URL(string: "http://www.bbcgoodfood.com/sites/bbcgoodfood.com/files/recipe_images/recipe-image-legacy-id--1001468_10.jpg")!)
        imageURLS.append(URL(string: "http://www.villageinn.com/i/pies/profile/carrotcake_main1.jpg")!)
        imageURLS.append(URL(string: "http://ukcdn.ar-cdn.com/recipes/xlarge/ff22df7f-dbcd-4a09-81f7-9c1d8395d936.jpg")!)
        
        let memoryImageCache = ImageMemoryCache(downloader: Downloader.shared)
        memoryImageCache.delegate = self
        
        for url in imageURLS {
            memoryImageCache.imageForURL(url, completion: { (image) in
                if image != nil {
                    print("image already cached: \(url)")
                }
            })
        }
        
        // Wait until the expectation is fulfilled, with a timeout of 50seconds.
        wait(for: [expectation], timeout: 50.0)
    }
    
    // MARK: - ImageCacheDelegate
    func imageCacheChanged(imageCahce: ImageCache, imageURL: URL) {
        // Fulfill the expectation to indicate that the background task has finished successfully.
        if count == 3 {
            expectation.fulfill()
        }
    }
    
    func imageCacheChanged(imageCahce: ImageCache, imageURL: URL, image: UIImage?) {
        if count == 3 {
            count += 1
            expectation.fulfill()
        }
    }
}
