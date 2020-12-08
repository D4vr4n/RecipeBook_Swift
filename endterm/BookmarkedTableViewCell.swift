//
//  BookmarkedTableViewCell.swift
//  endterm
//
//  Created by Davran Arifzhanov on 08.12.2020.
//

import UIKit

class BookmarkedTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        foodImageView?.layer.cornerRadius = (foodImageView?.frame.size.width ?? 0.0) / 2
        foodImageView?.clipsToBounds = true
        foodImageView?.layer.borderWidth = 3.0
        foodImageView?.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var foodImageView: UIImageView!
}
