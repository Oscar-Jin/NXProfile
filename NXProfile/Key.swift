//
//  Key.swift
//  Oshiego
//
//  Created by Zhiren Jin on 2019/07/10.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import Foundation

struct Key {
  static let firstName_Kanji = "firstName_Kanji"
  static let firstName_Hiragana = "firstName_Hiragana"
  static let lastName_Kanji = "lastName_Kanji"
  static let lastName_Hiragana = "lastName_Hiragana"
  
  static let documentID = "documentID"
  static let studentPhotoID = "studentPhotoID"
  static let studentPhotoURL = "studentPhotoURL"
  
  static let createdOn = "createdOn"
  static let updatedOn = "updatedOn"
  
  static let gender = "gender"
  static let birthDay = "birthDay"
  
  static let classLevel = "classLevel"
  
  static let note1 = "note1"
  static let note1_updatedOn = "note1_updatedOn"
  
  
  //newly added 2019/07/12
  
  static let nationality = "nationality"
  static let hometown = "hometown"

  static let occupation = "occupation"
  static let company = "company"
  
  static let schoolName = "schoolName"
  static let grade = "grade"
  
  static let mobilePhone = "mobilePhone"
  static let homePhone = "homePhone"
  static let workPhone = "workPhone"
  static let parentsPhone = "parentsPhone"
  
  static let personalEmail = "personalEmail"
  static let workEmail = "workEmail"
  static let parentsEmail = "parentsEmail"
  
  static let postalCode = "postalCode"
  static let address = "address"
  
  static let line = "line"
  static let twitter = "twitter"
  static let facebook = "facebook"
  static let instagram = "instagram"
  
  static let comment1 = "comment1"
  static let comment2 = "comment2"
  
  
  //key for instructors
  
  static let instructorPhotoID = "instructorPhotoID"
  static let instructorPhotoURL = "instructorPhotoURL"
  static let instructorLevel = "instructorLevel"
  
  
  //key for post
  static let aboutWhom_FirstName = "aboutWhom_FirstName"
  static let aboutWhom_LastName = "aboutWhom_LastName"
  static let aboutWhom_ID = "aboutWhom_ID"

  static let content = "content"
  
  static let contributor_FirstName = "contributor_FirstName"
  static let contributor_LastName = "contributor_LastName"
  static let contributor_ID = "contributor_ID"
  
  
  
}

//pathfinder for Firestore
extension Key {
  static let student = "student"
  static let instructor = "instructor"
  static let post = "post"
  
  static let studentsPhoto = "studentsPhoto"
}



