//
//  Student.swift
//  Oshiego
//
//  Created by Zhiren Jin on 2019/07/10.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Student {
  var lastName_Kanji: String
  var lastName_Hiragana: String
  var firstName_Kanji: String
  var firstName_Hiragana: String
  
  var documentID: String
  
  var studentPhotoID: String?
  var studentPhotoURL: String?
  
  var createdOn: Date?
  var updatedOn: Date?
  
  var gender: String?
  var birthDay: Date?
  
  var classLevel: String?
  
  var note1: String?
  var note1_updatedOn: Date?
  
  
  //newly added 2019/07/12
  var nationality: String?
  var hometown: String?
  
  var occupation: String?
  var company: String?
  
  var schoolName: String?
  var grade: String?
  
  var mobilePhone: String?
  var homePhone: String?
  var workPhone: String?
  var parentsPhone: String?
  
  var personalEmail: String?
  var workEmail: String?
  var parentsEmail: String?
  
  var postalCode: String?
  var address: String?
  
  var line: String?
  var twitter: String?
  var facebook: String?
  var instagram: String?
  
  var comment1: String?
  var comment2: String?
  
  
  init(data: [String: Any]) {
    self.lastName_Kanji = data[Key.lastName_Kanji] as? String ?? ""
    self.lastName_Hiragana = data[Key.lastName_Hiragana] as? String ?? ""
    self.firstName_Kanji = data[Key.firstName_Kanji] as? String ?? ""
    self.firstName_Hiragana = data[Key.firstName_Hiragana] as? String ?? ""
    
    self.documentID = (data[Key.documentID] ?? "") as? String ?? ""
    
    self.studentPhotoID = data[Key.studentPhotoID] as? String
    self.studentPhotoURL = data[Key.studentPhotoURL] as? String
    
    self.createdOn = (data[Key.createdOn] as? Timestamp)?.dateValue()
    self.updatedOn = (data[Key.updatedOn] as? Timestamp)?.dateValue()
    
    self.gender = data[Key.gender] as? String
    self.birthDay = (data[Key.birthDay] as? Timestamp)?.dateValue()
    
    self.classLevel = data[Key.classLevel] as? String
    
    self.note1 = data[Key.note1] as? String
    self.note1_updatedOn = (data[Key.note1_updatedOn] as? Timestamp)?.dateValue()
    
    //newly added 2019/07/12
    self.nationality = data[Key.nationality] as? String
    self.hometown = data[Key.hometown] as? String
    
    self.occupation = data[Key.occupation] as? String
    self.company = data[Key.company] as? String
    
    self.schoolName = data[Key.schoolName] as? String
    self.grade = data[Key.grade] as? String
    
    self.mobilePhone = data[Key.mobilePhone] as? String
    self.homePhone = data[Key.homePhone] as? String
    self.workPhone = data[Key.workPhone] as? String
    self.parentsPhone = data[Key.parentsPhone] as? String
    
    self.personalEmail = data[Key.personalEmail] as? String
    self.workEmail = data[Key.workEmail] as? String
    self.parentsEmail = data[Key.parentsEmail] as? String
    
    self.postalCode = data[Key.postalCode] as? String
    self.address = data[Key.address] as? String
    
    self.line = data[Key.line] as? String
    self.twitter = data[Key.twitter] as? String
    self.facebook = data[Key.facebook] as? String
    self.instagram = data[Key.instagram] as? String
    
    self.comment1 = data[Key.comment1] as? String
    self.comment2 = data[Key.comment2] as? String
  }
}

extension Student {
  var fullName_Kanji: String {
    return lastName_Kanji + "  " + firstName_Kanji
  }
  var fullName_Hiragana: String {
    return lastName_Hiragana + "  " + firstName_Hiragana
  }
  var age: String? {
    guard let birthday = birthDay else {return nil}
    
    let calendar = Calendar.current
    
    let ageComponents = calendar.dateComponents([.year], from: birthday, to: Date())
    let age = ageComponents.year!
    
    return String(age)
  }
  var birthday_MonthAndDay: String? {
    guard let birthday = birthDay else {return nil}
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
    
    return dateFormatter.string(from: birthday)
  }
}

extension Student {
  var key: String {
    switch String(lastName_Hiragana.prefix(1)) {
    case "あ", "い", "う", "え", "お":
      return "あ"
    case "か", "き", "く", "け", "こ",
         "が", "ぎ", "ぐ", "げ", "ご":
      return "か"
    case "さ", "し", "す", "せ", "そ",
         "ざ", "じ", "ず", "ぜ", "ぞ":
      return "さ"
    case "た", "ち", "つ", "て", "と",
         "だ", "ぢ", "づ", "で", "ど":
      return "た"
    case "な", "に", "ぬ", "ね", "の":
      return "な"
    case "は", "ひ", "ふ", "へ", "ほ",
         "ば", "び", "ぶ", "べ", "ぼ",
         "ぱ", "ぴ", "ぷ", "ぺ", "ぽ":
      return "は"
    case "ま", "み", "む", "め", "も":
      return "ま"
    case "や", "ゆ", "よ":
      return "や"
    case "ら", "り", "る", "れ", "ろ":
      return "ら"
    case "わ", "を", "ん":
      return "わ"
    default:
      return "#"
    }
  }
}


extension Student {
  func getDateByKey(_ key: String) -> Date? {
    switch key {
    case Key.birthDay:
      return birthDay
    default:
      return nil
    }
  }
}
