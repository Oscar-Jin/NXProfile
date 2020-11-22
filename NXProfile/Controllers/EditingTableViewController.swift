//
//  EditingTableViewController.swift
//  Oshiego
//
//  Created by Zhiren Jin on 2019/07/15.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit
import Firebase

class EditingTableViewController: UITableViewController, UITextFieldDelegate {
  
  var masterViewController: MasterViewController!
  var firestore: Firestore!
  var student: Student!
  var field: [String?]!
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var editableTextField: UITextField!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  @IBOutlet weak var inputCell: UITableViewCell!
  @IBOutlet weak var datePickerCell: UITableViewCell!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if field[2] == "Date" {
      editableTextField.isHidden = true
      titleLabel.text = (field[0] ?? "") + "："
      datePicker.date = student.getDateByKey(field[3]!) ?? Date()
      
    } else {
      datePicker.isHidden = true
      
      titleLabel.text = (field[0] ?? "") + "："
      editableTextField.text = field[1]
      editableTextField.delegate = self
      editableTextField.becomeFirstResponder()
    }
    
  }
  
  @IBAction func cancellButtonTapped(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func saveButtonTapped(_ sender: Any) {
    if field[2] == "Date" {
      let data = [field[3] ?? "failsafe": datePicker.date]
      firestore.collection(Key.student).document(student.documentID).updateData(data) { (_) in
        self.navigationController?.popViewController(animated: true)
      }
    } else {
      
      if field[3] == Key.firstName_Kanji || field[3] == Key.lastName_Kanji || field[3] == Key.firstName_Hiragana ||  field[3] == Key.lastName_Hiragana {
        let alert = UIAlertController(title: "本当に変更しますか？", message: "この生徒に関連するデータに影響を及ぼす恐れがあります", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "はい", style: .destructive, handler: { (_) in
          let data = [self.field[3] ?? "failsafe": self.editableTextField.text ?? ""]
          self.firestore.collection(Key.student).document(self.student.documentID).updateData(data, completion: { (_) in
            self.navigationController?.popViewController(animated: true)
          })
        }))
        alert.addAction(UIAlertAction(title: "いいえ", style: .cancel, handler: { (_) in
          return
        }))
        self.present(alert, animated: true, completion: nil)
        
        
      } else {
        let data = [field[3] ?? "failsafe": editableTextField.text ?? ""]
        firestore.collection(Key.student).document(student.documentID).updateData(data) { (_) in
          self.navigationController?.popViewController(animated: true)
        }
      }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
    }
  }
  
  
  
  /*
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
   
   // Configure the cell...
   
   return cell
   }
   */
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
