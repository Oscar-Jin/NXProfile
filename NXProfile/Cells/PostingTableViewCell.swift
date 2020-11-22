//
//  PostingTableViewCell.swift
//  Oshiego
//
//  Created by Zhiren Jin on 2019/07/13.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit

class PostingTableViewCell: UITableViewCell, UITextViewDelegate {
  @IBOutlet weak var instructorImageView: UIImageView!
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var createdLabel: UILabel!
  @IBOutlet weak var updatedLabel: UILabel!
  @IBOutlet weak var contributorNameLabel: UILabel!
  
  @IBOutlet weak var saveButton: UIButton!
  
  var post: Post!
  var delegate: SaveButtonTappedDelegate?
  var masterViewController: MasterViewController!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    textView.layer.cornerRadius = 8
    textView.clipsToBounds = true
    
    textView.delegate = self
    
    instructorImageView.layer.cornerRadius = instructorImageView.frame.width * 0.5
    instructorImageView.clipsToBounds = true

  }
  
  func textViewDidChange(_ textView: UITextView) {
    masterViewController.tableView.isUserInteractionEnabled = false
    saveButton.titleLabel?.text = "保存する"
    saveButton.isEnabled = true
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    masterViewController.tableView.isUserInteractionEnabled = true
    self.delegate?.saveButtonTapped(updatedContent: textView.text, atPost: post)
    saveButton.isEnabled = false
  }
  
  
  @IBAction func saveButtonTapped(_ sender: UIButton) {
    masterViewController.tableView.isUserInteractionEnabled = true
    self.delegate?.saveButtonTapped(updatedContent: textView.text, atPost: post)
    saveButton.isEnabled = false
  }
  
  
}

protocol SaveButtonTappedDelegate {
  func saveButtonTapped(updatedContent: String, atPost: Post)
}

