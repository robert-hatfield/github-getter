//
//  RepoDetailViewController.swift
//  GitHub Getter
//
//  Created by Robert Hatfield on 4/5/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import UIKit
import SafariServices

class RepoDetailViewController: UIViewController {
    
    var repo : Repository!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoLanguage: UILabel!
    @IBOutlet weak var forkStatus: UIImageView!
    @IBOutlet weak var starsCount: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    
    let forkDim = #imageLiteral(resourceName: "Code_Fork_dark")
    let forkLit = #imageLiteral(resourceName: "Code_Fork_lit")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self
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
        dateCreated.text = "Created \(repo.createdAt.mediumDateString())"
    }
    
    @IBAction func viewOnGitHub(_ sender: Any) {
        presentSafariViewControllerWith(urlString: repo.repoUrlString)
//        presentWebViewControllerWith(urlString: repo.repoUrlString)
    }
    
    func presentSafariViewControllerWith(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let safariController = SFSafariViewController(url: url)
        self.present(safariController, animated: true, completion: nil)
    }
    
    func presentWebViewControllerWith(urlString: String) {
        let webController = WebViewController()
        webController.url = urlString
        self.present(webController, animated: true, completion: nil)
    }

    @IBAction func returnToRepoList(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

//MARK: Controller transitioning delegate extension
extension RepoDetailViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransition(duration: 0.33)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransition(duration: 0.33)
    }
}
