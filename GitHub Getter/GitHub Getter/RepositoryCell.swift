//
//  RepositoryCell.swift
//  GitHub Getter
//
//  Created by Robert Hatfield on 4/5/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!

    var repo : Repository! {
        didSet {
            self.nameLabel.text = repo.name
            
            if repo.description != "" {
                self.descriptionLabel.text = repo.description
            } else {
                self.descriptionLabel.text = "No description provided"
            }
            
            if repo.language != "" {
                self.languageLabel.text = repo.language
            } else {
                self.languageLabel.text = "No primary language"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
