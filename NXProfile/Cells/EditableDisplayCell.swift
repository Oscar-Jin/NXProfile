//
//  EditableDisplayCell.swift
//  Oshiego
//
//  Created by Zhiren Jin on 2019/07/12.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit

class EditableDisplayCell: UITableViewCell {
  @IBOutlet weak var discriptionLabel: UILabel!
  @IBOutlet weak var textField: UITextField!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    textField.text = "--"
  }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
