//
//  TextViewCell.swift
//  Oshiego
//
//  Created by Zhiren Jin on 2019/07/11.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit
import Firebase

class TextViewCell: UITableViewCell, UITextViewDelegate {
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var createdLabel: UILabel!
  @IBOutlet weak var updatedLabel: UILabel!
  @IBOutlet weak var saveButton: UIButton!
  
  var student: Student!
  var delegate: SaveButtonTappedAtTextViewCellDelegate?
  var masterViewController: MasterViewController!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    textView.layer.cornerRadius = 8
    textView.clipsToBounds = true
    
    textView.delegate = self
    
    createdLabel.text = ""
  }
  
  func textViewDidChange(_ textView: UITextView) {
    saveButton.titleLabel?.text = "保存する"
    saveButton.isEnabled = true
    masterViewController.tableView.isUserInteractionEnabled = false
  }
  
  
  func textViewDidEndEditing(_ textView: UITextView) {
    self.delegate?.saveButtonTappedAtTextViewCell(updatedContent: textView.text, forStudent: student)
    masterViewController.tableView.isUserInteractionEnabled = true
    saveButton.isEnabled = false
  }
  
  @IBAction func saveButtonTapped(_ sender: UIButton) {
    self.delegate?.saveButtonTappedAtTextViewCell(updatedContent: textView.text, forStudent: student)
    masterViewController.tableView.isUserInteractionEnabled = true
    saveButton.isEnabled = false
  }
  
  
}

protocol SaveButtonTappedAtTextViewCellDelegate {
  func saveButtonTappedAtTextViewCell(updatedContent: String, forStudent: Student)
}
