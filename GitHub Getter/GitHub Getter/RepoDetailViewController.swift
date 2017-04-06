//
//  RepoDetailViewController.swift
//  GitHub Getter
//
//  Created by Robert Hatfield on 4/5/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import UIKit

class RepoDetailViewController: UIViewController {
    
    var repo : Repository!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoLanguage: UILabel!
    @IBOutlet weak var forkStatus: UIImageView!
    @IBOutlet weak var starsCount: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    let forkDim = #imageLiteral(resourceName: "Code_Fork_dark")
    let forkLit = #imageLiteral(resourceName: "Code_Fork_lit")
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        repoName.text = repo.name
        repoLanguage.text = repo.language
        starsCount.text = String(repo.stars)
        repoDescription.text = repo.description
        if repo.isFork {
            forkStatus.image = forkLit
        } else {
            forkStatus.image = forkDim
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == RepoViewController.identifier {
            segue.destination.transitioningDelegate = self
        }
    }

    @IBAction func returnToRepoList(_ sender: Any) {
        self.performSegue(withIdentifier: RepoViewController.identifier, sender: nil)
    }

}

//MARK: Controller transitioning delegate extension
extension RepoDetailViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransition(duration: 0.33)
    }
}
