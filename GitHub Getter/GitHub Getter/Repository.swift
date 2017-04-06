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
    let stars: Int
    let isFork: Bool
    let createdAt: Date
//    let languagesUrl: URL?
    
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let createdAtString = json["created_at"] as? String else {
            return nil
        }
        self.name = name
        
        let dateFormatter = ISO8601DateFormatter()
        guard let createdAtDate = dateFormatter.date(from: createdAtString) else { return nil }
        self.createdAt = createdAtDate
        
        self.description = json["description"] as? String ?? nil
        self.language = json["language"] as? String ?? nil
        self.stars = json["stargazers_count"] as? Int ?? 0
        self.isFork = json["fork"] as? Bool ?? false
        

        
    }
    
}
