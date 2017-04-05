//
//  GitHub.swift
//  GitHub Getter
//
//  Created by Robert Hatfield on 4/3/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import UIKit

let kOAuthBaseURLString = "https://github.com/login/oauth/"


typealias GitHubOAuthCompletion = (Bool)->()
typealias FetchReposCompletion = ([Repository]?) -> ()

enum gitHubAuthErrors : Error {
    case extractingCode
    case extractingToken
}

enum SaveOptions {
    case userDefaults
}

class GitHub {
    
    private var session: URLSession
    private var components: URLComponents
    
    static let shared = GitHub()
    
    private init () {
        self.session = URLSession(configuration: .default)
        self.components = URLComponents()
        self.components.scheme = "https"
        self.components.host = "api.github.com"

    }
    
    var token = ""
    let defaults = UserDefaults.standard
    
    func oAuthRequestWith(parameters: [String : String]) {
        var parametersString = ""
        
        for (key, value) in parameters {
            parametersString += "&\(key)=\(value)"
        }
        
        if let requestURL = URL(string: "\(kOAuthBaseURLString)authorize?client_id=\(Credentials.kGitHubClientId)\(parametersString)") {
            print("OAuth request sent: \(requestURL.absoluteString)")
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
                        print("Token received: \(token)")
                        self.token = token
                        if !GitHub.shared.defaults.save(accessToken: token) {
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
    
    func getRepos(completion: @escaping FetchReposCompletion) {
        
        if let token = UserDefaults.standard.getAccessToken() {
            let queryItem = URLQueryItem(name: "access_token", value: token)
            self.components.queryItems = [queryItem]
        }

        func returnToMain(results: [Repository]?) {
            OperationQueue.main.addOperation {
                completion(results)
            }
        }
        
        self.components.path = "/user/repos"
        
        guard let url = self.components.url else { returnToMain(results: nil); return }
        
        self.session.dataTask(with: url) { (data, response, error) in
            
            if error != nil { returnToMain(results: nil); return }
            if let data = data {
                var repositories = [Repository]()
                
                do {
                    if let reposJSON = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                        for repoJSON in reposJSON {
                            if let repo = Repository(json: repoJSON) {
                                repositories.append(repo)
                            }
                        }
                        returnToMain(results: repositories)
                    }
                } catch {
                    
                }
            }
            
        }.resume()
    }
    
}
