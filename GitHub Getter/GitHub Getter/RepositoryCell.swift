//
//  RepositoryCell.swift
//  GitHub Getter
//
//  Created by Robert Hatfield on 4/4/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    var repo: Repository! {
        didSet {
            self.nameLabel.text = repo.name
        }
    }
    
}
