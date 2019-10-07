//
//  CakesDecoder.swift
//  Cake List
//
//  Created by Jatinder Pal Singh Khera on 07/10/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import Foundation

struct CakesDecoder {
    static func decodeJSON<T: Decodable>(data: Data, type: T.Type) throws -> T? {
        let decoder = JSONDecoder()
        do {
            let decoded: T? = try decoder.decode(T.self, from: data)
            return decoded
        } catch let e {
            throw APIError.generic("Invalid JSON \(T.self) \(e.localizedDescription)")
        }
    }
}
