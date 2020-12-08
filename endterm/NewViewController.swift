//
//  NewViewController.swift
//  endterm
//
//  Created by Davran Arifzhanov on 08.12.2020.
//

import UIKit
import Firebase
import FirebaseAuth

class NewViewController: UIViewController {
    
    let ref = Database.database().reference(withPath: "recipe-items")
    let usersRef = Database.database().reference(withPath: "online")
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var imagePathField: UITextField!
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        let text1 = nameField.text!
        let text2 = descriptionField.text!
        let text3 = imagePathField.text!
        
        let recipeItem = RecipesItem(name: text1,
                                     description: text2,
                                     imagePath: text3,
                                     bookmarked: false
                                     )

        let recipeItemRef = self.ref.child(text1.lowercased())
        recipeItemRef.setValue(recipeItem.toAnyObject())
        
        nameField.text = ""
        descriptionField.text = ""
        imagePathField.text = ""
        
        let alert = UIAlertController(title: "Success",
                                      message: "New Recipe Added",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
