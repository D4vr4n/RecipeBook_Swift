//
//  ViewController.swift
//  endterm
//
//  Created by Davran Arifzhanov on 08.12.2020.
//

import UIKit
import Firebase
import FirebaseAuth

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

class ListOfAllViewController: UITableViewController {
    
    var recipes: [RecipesItem] = []
    var userCountBarButtonItem: UIBarButtonItem!
    var user: User!
    let ref = Database.database().reference(withPath: "recipe-items")
    let usersRef = Database.database().reference(withPath: "online")
    let cellIdentifier = "FetchedDataTableViewCell"
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FetchedDataTableViewCell
        let recipeItem = recipes[indexPath.row]
        cell.nameLabel.text = recipeItem.name
        cell.descriptionLabel.text = recipeItem.description
        let imageLink = recipeItem.imagePath
        cell.recipeImageView.downloaded(from: imageLink)
        toggleCellCheckbox(cell, isCompleted: recipeItem.bookmarked)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        let recipeItem = recipes[indexPath.row]
        recipeItem.ref?.removeValue()
      }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      guard let cell = tableView.cellForRow(at: indexPath) else { return }
      let recipeItem = recipes[indexPath.row]
      let toggledCompletion = !recipeItem.bookmarked
      toggleCellCheckbox(cell, isCompleted: toggledCompletion)
      recipeItem.ref?.updateChildValues([
        "bookmarked": toggledCompletion
        ])
    }
    
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
      if !isCompleted {
        cell.accessoryType = .none
        cell.textLabel?.textColor = .black
        cell.detailTextLabel?.textColor = .black
      } else {
          cell.accessoryType = .checkmark
        cell.textLabel?.textColor = .gray
        cell.detailTextLabel?.textColor = .gray
      }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "FetchedDataTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        tableView.allowsMultipleSelectionDuringEditing = false

        ref.observe(.value, with: { snapshot in
          var newRecipes: [RecipesItem] = []

          for child in snapshot.children {
            if let snapshot = child as? DataSnapshot,
               let recipeItem = RecipesItem(snapshot: snapshot) {
              newRecipes.append(recipeItem)
            }
          }

          self.recipes = newRecipes
          self.tableView.reloadData()
        })
        
        Auth.auth().addStateDidChangeListener { auth, user in
          guard let user = user else { return }
          self.user = User(authData: user)
          
          let currentUserRef = self.usersRef.child(self.user.uid)
          currentUserRef.setValue(self.user.email)
          currentUserRef.onDisconnectRemoveValue()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
    }
    
    private func handleNotAuthenticated(){
        if Auth.auth().currentUser == nil{
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
    

}

