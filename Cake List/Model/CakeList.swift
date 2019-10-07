//
//  CakeList.swift
//  Cake List
//
//  Created by Jatinder Pal Singh Khera on 07/10/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import Foundation

@objc class CakeList: NSObject {
    
}

extension CakeList {
    // ideally we want to return an error as part of the completion. Enum in swift
    // is not exposed to Objec-C, needs refacctor
    @objc static func loadCakes(_ completion: @escaping ([Cake]?) -> ()) {
        CakeAPI.get(endpoint: "cake.json", type: [Cake].self) { (cakes, error) in
            // TODO: - Store locally in core data, sqlite, etc.....
            completion(cakes)
        }
    }
}
