//
//  Downloader.swift
//  Cake List
//
//  Created by Jatinder Pal Singh Khera on 07/10/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import Foundation

protocol DownloaderDelegate {
    func downloader(didDownload from: URL, downloadData Data: Data?)
}

@objc class Downloader: NSObject {
    // MARK: - vars
    static let shared = Downloader()
    
    private let urlSession = URLSession(configuration: .default)
    
    // MARK: - Operation queue to help batch upload data
    private let operationQueue = OperationQueue()
    private var queue = Queue<URL>()
    
    private var timer: Timer?
    
    private let syncQueue = DispatchQueue(label: "com.cakes.background.queue.sync", attributes: .concurrent)
    private var synchingQueue = [URL]()
    
    // weak because memory references etc.....
    var delegate: DownloaderDelegate?
    
    // MARK: - Initialisation
    private override init() {
        super.init()
        operationQueue.maxConcurrentOperationCount = 3
    }
    
    // MARK: - Public methods
    func queueURL(_ url: URL) {
        if queue.items().contains(where: { (u) -> Bool in
            u == url
        }) || synchingQueue.contains(where: { (u) -> Bool in
            u == url
        }){
            print("url already queue \(url)")
        } else {
            queue.enqueue(url)
        }
    }
    
    func pause() {
        // TODO: implement
    }
    
    func stop() {
        self.timer?.invalidate()
    }
    
    func start() {
        if timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(executeSync), userInfo: nil, repeats: true)
        }
    }
    
    func resume() {
        // TODO: implement
    }
    
    // MARK: - Private methods
    @objc private func executeSync() {
        self.syncQueue.sync {
            if queue.isEmpty() == false {
                // Take first 10 to sync
                for _ in 1...10 {
                    if let url = queue.dequeue() {
                        synchingQueue.append(url)
                        
                        var request = URLRequest(url: url)
                        request.httpMethod = "GET"
                        
                        let operation = DownloadOperation(session: urlSession, request: request, url: url, completion: { (url, data, response, error) -> (Void) in
                            
                            // assume all went well and remove
                            // in actuality you will want to queue again for retry
                            
                            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 200
                            if statusCode != 200 {
                                print("Download failed: Server error \(statusCode) : \(url)")
                            } else {
                                print("Download complete: \(url)")
                            }
                            
                            if let index = self.synchingQueue.index(where: { (u) -> Bool in
                                u == url
                            }) {
                                self.synchingQueue.remove(at: index)
                            }
                            
                            // FIXME: check url is not nil
                            self.delegate?.downloader(didDownload: url!, downloadData: data)
                        })
                        operationQueue.addOperation(operation)
                    }
                }
            }
        }
    }
}

// MARK: Queue
struct Queue<T> {
    fileprivate var queue = [T]()
    
    mutating func enqueue(_ item: T) {
        self.queue.insert(item, at: self.queue.count)
    }
    
    mutating func dequeue() -> T? {
        guard !isEmpty() else {
            return nil
        }
        return self.queue.remove(at: 0)
    }
    
    func count() -> Int {
        return self.queue.count
    }
    
    func isEmpty() -> Bool {
        return queue.count == 0
    }
    
    func items() -> [T] {
        return queue
    }
}

// MARK: Download operation
class DownloadOperation : Operation {
    
    private var task : URLSessionDataTask!
    
    enum OperationState : Int {
        case ready
        case executing
        case finished
    }
    
    // default state is ready (when the operation is created)
    private var state : OperationState = .ready {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isReady: Bool { return state == .ready }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    init(session: URLSession, request: URLRequest, url: URL, completion: ((URL?, Data?, URLResponse?, Error?) -> (Void))?) {
        super.init()
        
        task = session.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            if let completion = completion {
                completion(url, data, response, error)
            }
            
            self?.state = .finished
        })
    }
    
    override func start() {
        
        if(self.isCancelled) {
            state = .finished
            return
        }
        
        state = .executing
        
        print("Downloading from: \(self.task.originalRequest?.url?.absoluteString ?? "")")
        
        self.task.resume()
    }
    
    override func cancel() {
        super.cancel()
        
        self.task.cancel()
    }
}
