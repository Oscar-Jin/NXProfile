//
//  Instructor.swift
//  Oshiego
//
//  Created by Zhiren Jin on 2019/07/14.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import Foundation
import Firebase

struct Instructor {
  var lastName_Kanji: String
  var lastName_Hiragana: String
  var firstName_Kanji: String
  var firstName_Hiragana: String
  
  var gender: String
  var instructorLevel: String
  
  var documentID: String
  
  var instructorPhotoID: String?
  var instructorPhotoURL: String?
  
  
  var birthDay: Date
  
  var createdOn: Date
  var updatedOn: Date
  
  init(data: [String: Any]) {
    self.lastName_Kanji = data[Key.lastName_Kanji] as? String ?? ""
    self.lastName_Hiragana = data[Key.lastName_Hiragana] as? String ?? ""
    self.firstName_Kanji = data[Key.firstName_Kanji] as? String ?? ""
    self.firstName_Hiragana = data[Key.firstName_Hiragana] as? String ?? ""
    
    self.gender = data[Key.gender] as? String ?? ""
    self.instructorLevel = data[Key.instructorLevel] as? String ?? ""
    
    self.documentID = data[Key.documentID] as? String ?? ""
      
    self.instructorPhotoID = data[Key.instructorPhotoID] as? String
    self.instructorPhotoURL = data[Key.instructorPhotoURL] as? String
    
    self.birthDay = (data[Key.birthDay] as? Timestamp)?.dateValue() ?? Date(timeIntervalSince1970: 0)
    
    self.createdOn = (data[Key.createdOn] as? Timestamp)?.dateValue() ?? Date(timeIntervalSince1970: 0)
    self.updatedOn = (data[Key.updatedOn] as? Timestamp)?.dateValue() ?? Date(timeIntervalSince1970: 0)
    
  }
}

extension Instructor {
  var fullName_Kanji: String {
    return lastName_Kanji + "  " + firstName_Kanji
  }
  var fullName_Hiragana: String {
    return lastName_Hiragana + "  " + firstName_Hiragana
  }
  var age: String? {
    let calendar = Calendar.current
    
    let ageComponents = calendar.dateComponents([.year], from: birthDay, to: Date())
    let age = ageComponents.year!
    
    return String(age)
  }
  var birthday_MonthAndDay: String? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
    
    return dateFormatter.string(from: birthDay)
  }
}

