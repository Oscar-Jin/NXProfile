//
//  InstructorTableViewCell.swift
//  Oshiego
//
//  Created by Zhiren Jin on 2019/07/14.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit

class InstructorTableViewCell: UITableViewCell {
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var nameHiraganaLabel: UILabel!
  @IBOutlet weak var birthdayLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      photoImageView.layer.cornerRadius = photoImageView.frame.width * 0.5
      photoImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
