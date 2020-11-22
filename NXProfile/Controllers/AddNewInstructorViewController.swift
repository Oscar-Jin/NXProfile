//
//  AddNewInstructorViewController.swift
//  Oshiego
//
//  Created by Zhiren Jin on 2019/07/13.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit
import Firebase

class AddNewInstructorViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
  var firestore: Firestore!
  
  @IBOutlet weak var lastName_Kanji_TextField: UITextField!
  @IBOutlet weak var lastName_Hiragana_TextField: UITextField!
  @IBOutlet weak var firstName_Kanji_TextField: UITextField!
  @IBOutlet weak var firstName_Hiragana_TextField: UITextField!
  
  @IBOutlet weak var genderPickerView: UIPickerView!
  @IBOutlet weak var birthdayPicker: UIDatePicker!
  @IBOutlet weak var instructorLevelPickerView: UIPickerView!
  
  let genders = ["男性", "女性", "その他"]
  let instructorLevels = ["S", "A", "B", "C", "アシスタント", "研修"]
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    genderPickerView.delegate = self
    genderPickerView.dataSource = self
    instructorLevelPickerView.delegate = self
    instructorLevelPickerView.dataSource = self
    
    genderPickerView.layer.cornerRadius = 5
    genderPickerView.clipsToBounds = true
    birthdayPicker.layer.cornerRadius = 5
    birthdayPicker.clipsToBounds = true
    instructorLevelPickerView.layer.cornerRadius = 5
    instructorLevelPickerView.clipsToBounds = true
    
    birthdayPicker.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.3)
//    birthdayPicker.inputView?.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.5)
    
    
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    if pickerView.tag == 0 {
      return 1
    }
    if pickerView.tag == 1 {
      return 1
    }
    return 0
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView.tag == 0 {
      return 3
    }
    if pickerView.tag == 1 {
      return 6
    }
    return 0
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView.tag == 0 {
      return genders[row]
    }
    if pickerView.tag == 1 {
      return instructorLevels[row]
    }
    return nil
  }
  
  
  
  
  @IBAction func registerButtonTapped(_ sender: Any) {
    if lastName_Kanji_TextField.text == "" || lastName_Hiragana_TextField.text == "" || firstName_Kanji_TextField.text == "" || firstName_Hiragana_TextField.text == "" {
      let alert = UIAlertController(title: "記入漏れがあります", message: "講師を登録するには、全ての欄を記入してください。", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
      
//    } else if !(lastName_Kanji_TextField.text!.isKanji) || !(firstName_Kanji_TextField.text!.isKanji) {
//      let alert = UIAlertController(title: "漢字で記入されていません", message: "講師の姓名を全て漢字で記入してください。", preferredStyle: .alert)
//      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//      self.present(alert, animated: true, completion: nil)
      
    } else if !(lastName_Hiragana_TextField.text!.isHiragana) || !(firstName_Hiragana_TextField.text!.isHiragana){
      let alert = UIAlertController(title: "ひらがなで記入されていません", message: "読み仮名を全てひらがなで記入してください。", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
      
    } else {
      let lastName_Kanji = lastName_Kanji_TextField.text ?? ""
      let lastName_Hiragana = lastName_Hiragana_TextField.text ?? ""
      let firstName_Kanji = firstName_Kanji_TextField.text ?? ""
      let firstName_Hiragana = firstName_Hiragana_TextField.text ?? ""
      let gender = genders[genderPickerView.selectedRow(inComponent: 0)]
      let birthday = birthdayPicker.date
      let instructorLevel = instructorLevels[instructorLevelPickerView.selectedRow(inComponent: 0)]
      
      let instructor: [String: Any] = [Key.lastName_Kanji: lastName_Kanji, Key.firstName_Kanji: firstName_Kanji, Key.lastName_Hiragana: lastName_Hiragana, Key.firstName_Hiragana: firstName_Hiragana, Key.instructorLevel: instructorLevel, Key.gender: gender, Key.birthDay: birthday]
      
      let query = firestore.collection(Key.instructor).whereField(Key.firstName_Kanji, isEqualTo: instructor[Key.firstName_Kanji] ?? "").whereField(Key.lastName_Kanji, isEqualTo: instructor[Key.lastName_Kanji] ?? "")
      
      query.getDocuments { (snapshot, error) in
        if let snapshot = snapshot {
          if snapshot.documents.isEmpty {
            print("instructor can be added")
            print("will add", instructor[Key.lastName_Kanji] ?? "", instructor[Key.firstName_Kanji] ?? "")
            let ref = self.firestore.collection(Key.instructor).addDocument(data: instructor)
            ref.updateData([Key.documentID: ref.documentID])
            ref.updateData([Key.createdOn: Date()])
            ref.updateData([Key.updatedOn: Date()], completion: { (_) in
              self.dismiss(animated: true, completion: nil)
            })
            
          } else {
            print("duplication found!")
            let data = snapshot.documents.first!.data()
            let lastName = data[Key.lastName_Kanji] as? String ?? ""
            let firstName = data[Key.firstName_Kanji] as? String ?? ""
            let name = lastName + " " + firstName
            print(name, "already exist!")
            
            let alert = UIAlertController(title: "重複を発見しました", message: "データベース内で同じ講師が既に登録されています。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
          }
        }
      }
      
      
    }
    
  }
  
  @IBAction func cancellButtonTapped(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  // MARK: - Table view data source
  
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
