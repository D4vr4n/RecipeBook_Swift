//
//  FetchedDataTableViewCell.swift
//  endterm
//
//  Created by Davran Arifzhanov on 08.12.2020.
//

import UIKit

class FetchedDataTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        recipeImageView?.layer.cornerRadius = (recipeImageView?.frame.size.width ?? 0.0) / 2
        recipeImageView?.clipsToBounds = true
        recipeImageView?.layer.borderWidth = 3.0
        recipeImageView?.layer.borderColor = UIColor.white.cgColor
    }
    
}
