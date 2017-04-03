//
//  GitHub.swift
//  GitHub Getter
//
//  Created by Robert Hatfield on 4/3/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import UIKit

let kOAuthBaseURLString = "https://github.com/login/oauth/"
enum gitHubAuthErrors : Error {
    case extractingCode
}

class GitHub {
    
    static let shared = GitHub()
    
    func oAuthRequestWith(parameters: [String : String]) {
        var parametersString = ""
        
        for (key, value) in parameters {
            parametersString += "&\(key)=\(value)"
        }
        
        if let requestURL = URL(string: "\(kOAuthBaseURLString)authorize?client_id=\(Credentials.kGitHubClientId)\(parametersString)") {
            print(requestURL.absoluteString)
            UIApplication.shared.open(requestURL)
        }
    }
    
    func getCodeFrom(url: URL) throws -> String {
        guard let code = url.absoluteString.components(separatedBy: "=").last else {
            throw gitHubAuthErrors.extractingCode
        }
        return code
    }
    
}
