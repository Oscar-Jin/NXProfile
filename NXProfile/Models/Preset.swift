//
//  List.swift
//  NXProfile
//
//  Created by Zhiren Jin on 2019/07/25.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import Foundation

struct Preset {
  static let aboutMeTitles = [Key.名前, Key.年齢, Key.誕生日, Key.クラス, Key.学校勤務先, Key.詳しい生徒情報を見る]
  static let classLevels = [Key.L1, Key.L2, Key.L3, Key.L4, Key.L5, Key.A, Key.B, Key.C, Key.D, Key.E, Key.F, Key.G, Key.H, Key.I, Key.I_Jr]
  static let studentDictionary = ["あ": [Student](), "か": [Student](), "さ": [Student](), "た": [Student](), "な": [Student](), "は": [Student](), "ま": [Student](), "や": [Student](), "ら": [Student](), "わ": [Student](), "#": [Student]()]
  static let genders = ["男性", "女性", "その他"]
  static let instructorLevels = ["S", "A", "B", "C", "アシスタント", "研修"]
  
  
  static func generatePersonalInfoList(from student: Student) -> [String: String]{
    return [
      Key.名前: student.fullName_Kanji + "\t\t" + student.fullName_Hiragana,
      Key.年齢: student.age ?? "--",
      Key.誕生日: student.birthday_MonthAndDay ?? "--",
      Key.クラス: student.classLevel ?? "--",
      Key.学校勤務先: student.schoolName ?? student.company ?? "--",
      Key.詳しい生徒情報を見る: "--",
    ]
  }

}




