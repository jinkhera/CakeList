//
//  CakeList.swift
//  Cake List
//
//  Created by Jatinder Pal Singh Khera on 07/10/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import Foundation

struct CakeList {
    
}

extension CakeList {
    static func loadCakes(_ completion: @escaping ([Cake]?, APIError?) -> ()) {
        CakeAPI.get(endpoint: "cake.json", type: [Cake].self) { (cakes, error) in
            // TODO: - Store locally in core data, sqlite, etc.....
            completion(cakes, error)
        }
    }
}
