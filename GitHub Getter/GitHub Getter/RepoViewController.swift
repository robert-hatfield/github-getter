//
//  RepoViewController.swift
//  GitHub Getter
//
//  Created by Robert Hatfield on 4/4/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController, UISearchBarDelegate {
    var repositories = [Repository]() {
        didSet {
            print(repositories.first?.name)
            print(repositories.first?.description)
            print(repositories.first?.language)
//            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        update()
    }

    func update() {
        GitHub.shared.getRepos { (repositories) in
            // update tableView with repositories
            self.repositories = repositories ?? []
        }
    }
    
}
