//
//  RecipesItem.swift
//  endterm
//
//  Created by Davran Arifzhanov on 08.12.2020.
//

import Foundation
import Firebase

struct RecipesItem {
  
  let ref: DatabaseReference?
  let key: String
  let name: String
  let description: String
  let imagePath: String
//  let addedByUser: String
  var bookmarked: Bool
  
    init(name: String, description: String, imagePath: String, bookmarked: Bool, key: String = "") {
    self.ref = nil
    self.key = key
    self.name = name
    self.description = description
    self.imagePath = imagePath
    self.bookmarked = bookmarked
  }
  
  init?(snapshot: DataSnapshot) {
    guard
      let value = snapshot.value as? [String: AnyObject],
      let name = value["name"] as? String,
      let description = value["description"] as? String,
      let imagePath = value["imagePath"] as? String,
      let bookmarked = value["bookmarked"] as? Bool else {
      return nil
    }
    
    self.ref = snapshot.ref
    self.key = snapshot.key
    self.name = name
    self.description = description
    self.imagePath = imagePath
    self.bookmarked = bookmarked
  }
  
  func toAnyObject() -> Any {
    return [
      "name": name,
      "description": description,
      "imagePath": imagePath,
      "bookmarked": bookmarked
    ]
  }
}
