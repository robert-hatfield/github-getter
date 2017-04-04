//
//  GitHub.swift
//  GitHub Getter
//
//  Created by Robert Hatfield on 4/3/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import UIKit

let kOAuthBaseURLString = "https://github.com/login/oauth/"
let defaults = UserDefaults.standard

typealias GitHubOAuthCompletion = (Bool)->()

enum gitHubAuthErrors : Error {
    case extractingCode
    case extractingToken
}

enum SaveOptions {
    case userDefaults
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
    
    func tokenRequestFor(url: URL, saveOptions: SaveOptions, completion: @escaping GitHubOAuthCompletion) {
        
        func complete(success: Bool) {
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
        
        do {
            let code = try self.getCodeFrom(url: url)
            let requestString = "\(kOAuthBaseURLString)access_token?client_id=\(Credentials.kGitHubClientId)&client_secret=\(Credentials.kGitHubClientSecret)&code=\(code)"
            if let requestURL = URL(string: requestString) {
                let session = URLSession(configuration: .default)
                session.dataTask(with: requestURL, completionHandler: { (data, response, error) in
                    if error != nil {
                        print("Error received: \(error?.localizedDescription)")
                        complete(success: false)
                    }
                    guard let data = data else {
                        print("Data not received")
                        complete(success: false)
                        return
                    }
                    if let dataString = String(data: data, encoding: .utf8) {
                        print("Data string is: \(dataString)")
                        guard let token = dataString.components(separatedBy: "&").first?.components(separatedBy: "=").last else {
                            print("Unable to parse token from data")
                            complete(success: false); return
                        }
                        print("Token: \(token)")
                        if !defaults.save(accessToken: token) {
                            print("Unable to save token to UserDefaults")
                            complete(success: false)
                        }
                        print("Saved token to UserDefaults.")
                        complete(success: true)
                    }
                }).resume()
            }
        } catch {
            print(error)
            complete(success: false)
        }
    }
    
}
