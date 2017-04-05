//
//  RepoViewController.swift
//  GitHub Getter
//
//  Created by Robert Hatfield on 4/4/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController {
    
    @IBOutlet weak var repoTableView: UITableView!
    
    @IBOutlet weak var repositoryCell: RepositoryCell!
    
    var filteredRepositories = [Repository]() {
        didSet {
            self.repoTableView.reloadData()
        }
    }
    
    var allRepositories = [Repository]() {
        didSet {
            self.filteredRepositories = allRepositories
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.repoTableView.dataSource = self
        self.repoTableView.delegate = self
        update()
    }

    func update() {
        GitHub.shared.getRepos { (repositories) in
            // update tableView with repositories
            self.allRepositories = repositories ?? []
        }
    }
    
    func filterRepos() {
        self.filteredRepositories = allRepositories.filter { repo in
            return repo.name.lowercased().contains("cookie".lowercased())
        }
        print(filteredRepositories)
        self.repoTableView.reloadData()
    }
    
}

//MARK: UITableView extension
extension RepoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRepositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.identifier, for: indexPath) as! RepositoryCell
        
        let repo = self.filteredRepositories[indexPath.row]
        cell.repo = repo
        return cell
    }
    
}
