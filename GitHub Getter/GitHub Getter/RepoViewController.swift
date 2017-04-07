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
    @IBOutlet weak var searchBar: UISearchBar!
    
    var allRepositories = [Repository]() {
        didSet {
            repoTableView.reloadData()
        }
    }
    var filteredRepositories: [Repository]? {
        didSet {
            repoTableView.reloadData()
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
        
        self.searchBar.delegate = self
        
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
            let selectedRepo = self.filteredRepositories?[selectedIndex] ?? self.allRepositories[selectedIndex]
            
            segue.destination.transitioningDelegate = self
            guard let destinationViewController = segue.destination as? RepoDetailViewController else {
                return
            }
            destinationViewController.repo = selectedRepo
            
        }
    }
    

    
}

//MARK: UITableView extensions
extension RepoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRepositories?.count ?? allRepositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.identifier, for: indexPath) as! RepositoryCell
        
        cell.repo = filteredRepositories?[indexPath.row] ?? allRepositories[indexPath.row]
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

// MARK: UISearchBarDelegate Extension
extension RepoViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isValid() {
            let lastIndex = searchText.index(before: searchText.endIndex)
            searchBar.text = searchText.substring(to: lastIndex)
        }
        
        if searchBar.text == "" {
            filteredRepositories = nil
            return
        }
        
        guard var filterText = searchBar.text else { return }
        filterText = filterText.lowercased()
        
        self.filteredRepositories = self.allRepositories.filter({
            $0.name.lowercased().contains(filterText) ||
            $0.description.lowercased().contains(filterText) ||
            $0.language.lowercased().contains(filterText)
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.filteredRepositories = nil
        searchBar.resignFirstResponder()
    }
    
}
