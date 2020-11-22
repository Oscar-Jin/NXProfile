//
//  AddNewStudentViewController.swift
//  Oshiego
//
//  Created by Zhiren Jin on 2019/07/13.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit
import Firebase

class AddNewStudentViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  var firestore: Firestore!
  var masterViewController: MasterViewController!
  
  @IBOutlet weak var lastName_Kanji_TextField: UITextField!
  @IBOutlet weak var lastName_Hiragana_TextField: UITextField!
  @IBOutlet weak var firstName_Kanji_TextField: UITextField!
  @IBOutlet weak var firstName_Hiragana_TextField: UITextField!
  @IBOutlet weak var classPickerView: UIPickerView!
  
  let classLevel =  ["L1", "L2", "L3", "L4", "L5", "A", "B", "C", "D", "E", "F", "G", "H", "I"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    classPickerView.delegate = self
    classPickerView.dataSource = self
    
    classPickerView.layer.cornerRadius = 5
    classPickerView.clipsToBounds = true
  }
  
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return 14
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 || indexPath.row == 5 {
      lastName_Kanji_TextField.resignFirstResponder()
      lastName_Hiragana_TextField.resignFirstResponder()
      firstName_Kanji_TextField.resignFirstResponder()
      firstName_Hiragana_TextField.resignFirstResponder()
    }
  }
  
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return classLevel[row]
  }
  
  @IBAction func cancellButtonTapped(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func registerButtonTapped(_ sender: Any) {
    print("register button tapped")

    if lastName_Kanji_TextField.text == "" || lastName_Hiragana_TextField.text == "" || firstName_Kanji_TextField.text == "" || firstName_Hiragana_TextField.text == "" {
      let alert = UIAlertController(title: "記入漏れがあります", message: "生徒を登録するには、全ての欄を記入してください。", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    } else if !(lastName_Kanji_TextField.text!.isKanji) || !(firstName_Kanji_TextField.text!.isKanji) {
      let alert = UIAlertController(title: "漢字で記入されていません", message: "生徒の姓名を全て漢字で記入してください。", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    } else if !(lastName_Hiragana_TextField.text!.isHiragana) || !(firstName_Hiragana_TextField.text!.isHiragana){
      let alert = UIAlertController(title: "ひらがなで記入されていません", message: "読み仮名を全てひらがなで記入してください。", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    } else {
      print("validation success. begin to upload to firestore")

      let lastName_Kanji = lastName_Kanji_TextField.text ?? ""
      let lastName_Hiragana = lastName_Hiragana_TextField.text ?? ""
      let firstName_Kanji = firstName_Kanji_TextField.text ?? ""
      let firstName_Hiragana = firstName_Hiragana_TextField.text ?? ""
      let classLevel = self.classLevel[classPickerView.selectedRow(inComponent: 0)]
      
      let studentInfo: [String: String] = [Key.lastName_Kanji: lastName_Kanji, Key.firstName_Kanji: firstName_Kanji, Key.lastName_Hiragana: lastName_Hiragana, Key.firstName_Hiragana: firstName_Hiragana, Key.classLevel: classLevel, Key.note1: ""]
      
      let query = firestore.collection(Key.student).whereField(Key.firstName_Kanji, isEqualTo: studentInfo[Key.firstName_Kanji] ?? "").whereField(Key.lastName_Kanji, isEqualTo: studentInfo[Key.lastName_Kanji] ?? "")
      query.getDocuments { (snapshot, error) in
        if let snapshot = snapshot {
          if snapshot.documents.isEmpty {
            print("student can be added")
            print("will add", studentInfo[Key.lastName_Kanji] ?? "", studentInfo[Key.firstName_Kanji] ?? "")
            let ref = self.firestore.collection(Key.student).addDocument(data: studentInfo)
            ref.updateData([Key.documentID: ref.documentID])
            ref.updateData([Key.createdOn: Date()])
            ref.updateData([Key.updatedOn: Date()], completion: { (_) in
              //TODO:
//            
//              let student = Student(data: studentInfo)
//              
//              let list = self.masterViewController.list
//              let sectionTitle = self.masterViewController.sectionTitle
//              
//              let section = sectionTitle.firstIndex(of: student.key) ?? 0
//              print("section found at", section)
//              var row = 0
//              
//              
//              for soneone in list[student.key]! {
//                if soneone.lastName_Kanji == student.lastName_Kanji && soneone.firstName_Kanji == student.firstName_Kanji {
//                  break
//                } else {
//                  row += 1
//                }
//              }
//              
//              print("row found at", row)
//              self.masterViewController.tableView.selectRow(at: IndexPath(row: row, section: section), animated: true, scrollPosition: .middle)
              
              self.dismiss(animated: true, completion: nil)
            })
            
          } else {
            print("duplication found!")
            let data = snapshot.documents.first!.data()
            let lastName = data[Key.lastName_Kanji] as? String ?? ""
            let firstName = data[Key.firstName_Kanji] as? String ?? ""
            let name = lastName + " " + firstName
            print(name, "already exist!")
            
            let alert = UIAlertController(title: "重複を発見しました", message: "データベース内で同じ名前の生徒が既に登録されています。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
          }
        }
      }
    }
    
    
    
    
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
