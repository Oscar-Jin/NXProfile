//
//  Post.swift
//  Oshiego
//
//  Created by Zhiren Jin on 2019/07/14.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import Foundation
import Firebase

struct Post {
  var aboutWhom_FirstName: String
  var aboutWhom_LastName: String
  var aboutWhom_ID: String
  
  var content: String
  
  var contributor_FirstName: String
  var contributor_LastName: String
  var contributor_ID: String
  
  var documentID: String
  
  var createdOn: Date
  var updatedOn: Date
  
  init(data: [String: Any]) {
    self.aboutWhom_FirstName = data[Key.aboutWhom_FirstName] as? String ?? ""
    self.aboutWhom_LastName = data[Key.aboutWhom_LastName] as? String ?? ""
    self.aboutWhom_ID = data[Key.aboutWhom_ID] as? String ?? ""
    
    self.content = data[Key.content] as? String ?? ""
    
    self.contributor_FirstName = data[Key.contributor_FirstName] as? String ?? ""
    self.contributor_LastName = data[Key.contributor_LastName] as? String ?? ""
    self.contributor_ID = data[Key.contributor_ID] as? String ?? ""
    
    self.documentID = data[Key.documentID] as? String ?? ""
    
    self.createdOn = (data[Key.createdOn] as? Timestamp)?.dateValue() ?? Date()
    self.updatedOn = (data[Key.updatedOn] as? Timestamp)?.dateValue() ?? Date()
  }
}
