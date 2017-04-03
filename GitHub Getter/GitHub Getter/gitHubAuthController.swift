//
//  gitHubAuthController.swift
//  GitHub Getter
//
//  Created by Robert Hatfield on 4/3/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import UIKit

class gitHubAuthController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func printTokenPressed(_ sender: Any) {
        
    }
   
    @IBAction func loginButtonPressed(_ sender: Any) {
        let parameters = ["scope": "email,user"]
        GitHub.shared.oAuthRequestWith(parameters: parameters)
    }
    
}