//
//  Repository.swift
//  GitHub Getter
//
//  Created by Robert Hatfield on 4/4/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import Foundation

class Repository {
    
    let name: String
    let description: String?
    let language: String?
//    let languagesUrl: URL?
    
    init?(json: [String: Any]) {
        if let name = json["name"] as? String {
            self.name = name
            self.description = json["description"] as? String ?? nil
            self.language = json["language"] as? String ?? nil
        } else { return nil }
        
    }
    
}
