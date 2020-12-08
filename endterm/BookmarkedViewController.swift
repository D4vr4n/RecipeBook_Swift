//
//  BookmarkedViewController.swift
//  endterm
//
//  Created by Davran Arifzhanov on 08.12.2020.
//

import UIKit
import Firebase
import FirebaseAuth



class BookmarkedViewController: UITableViewController {
    
    var recipes: [RecipesItem] = []
    let cellIdentifier = "BookmarkedTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "BookmarkedTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BookmarkedTableViewCell
        let recipeItem = recipes[indexPath.row]
        
        if recipeItem.bookmarked{
            cell.nameLabel.text = recipeItem.name
            cell.descriptionLabel.text = recipeItem.description
            let imageLink = recipeItem.imagePath
            cell.foodImageView.downloaded(from: imageLink)
        } 
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        let recipeItem = recipes[indexPath.row]
        !recipeItem.bookmarked
        self.tableView.reloadData()
      }
    }

}
