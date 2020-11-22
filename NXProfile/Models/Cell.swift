//
//  Cell.swift
//  NXProfile
//
//  Created by Zhiren Jin on 2019/07/25.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit

struct Cell {
  /// 各View Controllerに合わせたセル数の返却
  static func switchForRow(at viewController: UIViewController, using section: Int) -> Int {
    
    // DetailViewControllerの場合
    if let detailViewController = viewController as? DetailViewController {
      switch section {
      case 0: // Photo
        return 1
      case 1: // About Me
        return detailViewController.aboutMeList.count
      case 2: // Memo
        return 1
      case 3: // Stories
        return detailViewController.postsForSpecificStudent.count + 1
      default:
        return 1
      }
    }
    return 0
  }
  
  
  
  
  
}
