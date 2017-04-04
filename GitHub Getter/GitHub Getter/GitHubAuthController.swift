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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GitHub.shared.token = GitHub.shared.defaults.getAccessToken() ?? ""
        if GitHub.shared.token != "" {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.darkGray
            print("Token loaded from defaults: \(GitHub.shared.token)")
        } else { print("No token in defaults.") }
        // Do any additional setup after loading the view.
    }
   
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
