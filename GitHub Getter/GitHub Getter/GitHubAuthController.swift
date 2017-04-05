//
//  gitHubAuthController.swift
//  GitHub Getter
//
//  Created by Robert Hatfield on 4/3/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import UIKit

class GitHubAuthController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if GitHub.shared.token == "" {
            let parameters = ["scope": "email,user,repo"]
            GitHub.shared.oAuthRequestWith(parameters: parameters)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.darkGray
            loginButton.setTitle("Logged in", for: .disabled)
        }
    }
    
    func dismissAuthController() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
}
