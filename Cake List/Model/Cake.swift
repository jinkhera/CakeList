//
//  Cake.swift
//  Cake List
//
//  Created by Jatinder Pal Singh Khera on 07/10/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import Foundation

/// As structs are not interoptable with Swift we need to use classes with '@objc' decorators
@objc class Cake: NSObject, Decodable {
    // MARK: - vars
    var title: String
    var desc: String
    var image: URL
    
    // MARK: - initialisation
    public init(title: String, desc: String, imageURL url: URL) {
        self.title = title
        self.desc = desc
        self.image = url
    }
}

extension Cake {
    override var description: String {
        return "\(title) \(image)"
    }
}
