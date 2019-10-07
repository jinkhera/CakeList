//
//  CakeAPI.swift
//  Cake List
//
//  Created by Jatinder Pal Singh Khera on 07/10/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import Foundation

public enum APIError: Error, CustomStringConvertible {
    /// An error for which we don't have a specific one.
    case generic(String)
    
    /// An error holding on to an NSError.
    case nsError(Foundation.NSError)
    
    /// Human understandable error string.
    public var description: String {
        switch self {
        case .generic(let message):
            return message
        case .nsError(let error):
            return error.localizedDescription
        }
    }
}

struct CakeAPI {
    
}

// MARK: - Headlines endpoint
extension CakeAPI {
    static func get<T: Decodable>(endpoint: String, type: T.Type, _ completion: @escaping (T?, APIError?) -> ()) {
        guard let url = URL(string: Application.Configuration.baseURL(path: endpoint)) else {
            completion(nil, APIError.generic("Invalid API"))
            return
        }
        
        Networking.HTTP.request(url: url) { (data, error) in
            if let e = error {
                completion(nil, e)
            } else {
                do {
                    //                    let a = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    //                    print("\(a)")
                    
                    let decodedObjects = try CakesDecoder.decodeJSON(data: data!, type: T.self)
                    completion(decodedObjects, nil)
                } catch let decodeError {
                    completion(nil, decodeError as? APIError)
                }
            }
        }
    }
}
