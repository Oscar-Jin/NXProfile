//
//  ImageTableViewCell.swift
//  Oshiego
//
//  Created by Zhiren Jin on 2019/07/11.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
  @IBOutlet weak var studentPhotoView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    studentPhotoView.layer.cornerRadius = studentPhotoView.frame.width * 0.5
    studentPhotoView.layer.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
    studentPhotoView.clipsToBounds = true
    
  }

}
