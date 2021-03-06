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
        
        let repoNib = UINib(nibName: "RepositoryCell", bundle: nil)
        self.repoTableView.register(repoNib, forCellReuseIdentifier: RepositoryCell.identifier)
        self.repoTableView.estimatedRowHeight = 70
        self.repoTableView.rowHeight = UITableViewAutomaticDimension
        
        update()
    }

    func update() {
        GitHub.shared.getRepos { (repositories) in
            // update tableView with repositories
            self.allRepositories = repositories ?? []
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == RepoDetailViewController.identifier {
            guard let selectedIndex = self.repoTableView.indexPathForSelectedRow?.row else {
                return
            }
            let selectedRepo = self.filteredRepositories[selectedIndex]
            
            segue.destination.transitioningDelegate = self
            guard let destinationViewController = segue.destination as? RepoDetailViewController else {
                return
            }
            destinationViewController.repo = selectedRepo
            
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

//MARK: UITableView extensions
extension RepoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRepositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.identifier, for: indexPath) as! RepositoryCell
        
        cell.repo = self.filteredRepositories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: RepoDetailViewController.identifier, sender: nil)
    }
}

//MARK: Controller transitioning delegate extension
extension RepoViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return CustomTransition(duration: 0.33)
        
    }
}
