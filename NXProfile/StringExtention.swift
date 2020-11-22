//
//  StringExtention.swift
//  Oshiego
//
//  Created by Zhiren Jin on 2019/07/13.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import Foundation

extension String {
  
  /// 「漢字」かどうか
  var isKanji: Bool {
    let range = "^[\u{3005}\u{3007}\u{303b}\u{3400}-\u{9fff}\u{f900}-\u{faff}\u{20000}-\u{2ffff}]+$"
    return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
  }
  
  /// 「ひらがな」かどうか
  var isHiragana: Bool {
    let range = "^[ぁ-ゞ]+$"
    return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
  }
  
  /// 「カタカナ」かどうか
  var isKatakana: Bool {
    let range = "^[ァ-ヾ]+$"
    return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
  }
  
}
