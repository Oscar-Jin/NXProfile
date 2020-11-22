//
//  CompleteDataViewController.swift
//  Oshiego
//
//  Created by Zhiren Jin on 2019/07/11.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit
import Firebase

class CompleteDataViewController: UITableViewController, DismissViewDelegate, UITextFieldDelegate,  StudentDataUpdatedDelegate2{
  
  func studentUpdated(newStudent: Student) {
    print("CompleteVC: studentUpdated invoked")
    self.student = newStudent
  }
  

  
  // MARK: - Variables and References
  var masterViewController: MasterViewController!
  var firestore: Firestore!
  var student: Student! {
    didSet {
      tableView.reloadData()
    }
  }
  
  var sectionTitle = ["Name", "Backgrounds", "Contacts", "Class Info", "System"]
  var name = [[String]]()
  var backgrounds = [[String?]]()
  var contacts = [[String?]]()
  var classInfo = [[String?]]()
  var system = [[String?]]()
  
  var indexPath: IndexPath!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let formater = DateFormatter()
    formater.dateStyle = .full
    formater.timeStyle = .none
    formater.locale = Locale(identifier: "ja_JP")
    
    
    // 0
    name = [
      ["姓（漢字）", student.lastName_Kanji, "String", Key.lastName_Kanji],
      ["姓（かな）", student.lastName_Hiragana, "String", Key.lastName_Hiragana],
      ["名（漢字）", student.firstName_Kanji, "String", Key.firstName_Kanji],
      ["名（かな）", student.firstName_Hiragana, "String", Key.firstName_Hiragana]
    ]
    
    // 1
    backgrounds = [
      ["国籍", student.nationality, "String", Key.nationality],
      ["出身地", student.hometown, "String", Key.hometown],
      ["性別", student.gender, "String", Key.gender],
      ["誕生日", formater.string(for: student.birthDay), "Date", Key.birthDay],
      ["職業", student.occupation, "String", Key.occupation],
      ["勤務先", student.company, "String", Key.company],
      ["学校名", student.schoolName, "String", Key.schoolName],
      //      ["学年", student.grade, "String", Key], 自動的に学年を増加するためには、専門のプログラムが必要
      ["備考１", student.comment1, "String", Key.comment1],
      ["備考２", student.comment2, "String", Key.comment2],
    ]
    
    // 2
    contacts = [
      ["携帯（番号）", student.mobilePhone, "String", Key.mobilePhone],
      ["自宅（番号）", student.homePhone, "String", Key.homePhone],
      ["勤務先（番号）", student.workPhone, "String", Key.workPhone],
      ["保護者（番号）", student.parentsPhone, "String", Key.parentsPhone],
      ["個人（メールアドレス）", student.personalEmail, "String", Key.personalEmail],
      ["勤務先（メールアドレス）", student.workEmail, "String", Key.workEmail],
      ["保護者（メールアドレス）", student.parentsEmail, "String", Key.parentsEmail],
      ["郵便番号", student.postalCode, "String", Key.postalCode],
      ["住所", student.address, "String", Key.address],
      ["LINE", student.line, "String", Key.line],
      ["Twitter", student.twitter, "String", Key.twitter],
      ["Facebook", student.facebook, "String", Key.facebook],
      ["Instagram", student.instagram, "String", Key.instagram],
    ]
    
    
    // 3
    classInfo = [
      ["クラス", student.classLevel ?? "", "String", Key.classLevel],
    ]
    
    // 4
    system = [
      ["Document ID", student.documentID, "String", Key.documentID],
      ["Photo ID", student.studentPhotoID, "String", Key.studentPhotoID],
      ["Photo URL", student.studentPhotoURL, "String", Key.studentPhotoURL],
      ["Created on", student.createdOn?.description, "Date", Key.createdOn],
      ["Updated on", student.updatedOn?.description, "Date", Key.updatedOn],
    ]
    
  
    if let masterViewContorllor = masterViewController {
      masterViewContorllor.dismissViewDelegate = self
      masterViewController.delegate4 = self
    }
    

  }
  
  
  
  
  // MARK: - Table View Overrides
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return sectionTitle.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    switch section {
    case 0:
      return name.count
    case 1:
      return backgrounds.count
    case 2:
      return contacts.count
    case 3:
      return classInfo.count
    case 4:
      return system.count
    default:
      return 1
    }
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let editableCell = tableView.dequeueReusableCell(withIdentifier: "EditableDisplayCell", for: indexPath) as? EditableDisplayCell ?? EditableDisplayCell()
    // let pickerCell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell", for: indexPath) as? DatePickerCell ?? DatePickerCell()

    let section = indexPath.section
    let row = indexPath.row
    
    switch section {
    case 0:
      editableCell.discriptionLabel.text = name[row][0]
      editableCell.textField.text = name[row][1]
      return editableCell
    case 1:
      editableCell.discriptionLabel.text = backgrounds[row][0]
      editableCell.textField.text = backgrounds[row][1]
      return editableCell
    case 2:
      editableCell.discriptionLabel.text = contacts[row][0]
      editableCell.textField.text = contacts[row][1]
      return editableCell
    case 3:
      editableCell.discriptionLabel.text = classInfo[row][0]
      editableCell.textField.text = classInfo[row][1]
      return editableCell
    case 4:
      editableCell.discriptionLabel.text = system[row][0]
      editableCell.textField.text = system[row][1]
      return editableCell
    default:
      return UITableViewCell()
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionTitle[section]
  }
  
  // set color for each header
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    if let headerView = view as? UITableViewHeaderFooterView {
      headerView.textLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
  }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 4 {
    } else {
      self.indexPath = indexPath
      performSegue(withIdentifier: "showEditViewSegue", sender: self)
      
    }
    

  }
  
  
  
  
  
  
  
  
  
  func dismissView() {
    navigationController?.popViewController(animated: true)
  }
  
  
  
  
  @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
//    if sender.title == "編集" {
//      for cell in tableView.visibleCells {
//        if let editableCell = cell as? EditableDisplayCell {
//          editableCell.textField.isEnabled = true
//          editableCell.textField.borderStyle = .roundedRect
//        }
//        tableView.reloadData()
//      }
//      for cell in tableView.visibleCells {
//        if let editableCell = cell as? EditableDisplayCell {
//          editableCell.textField.isEnabled = true
//          editableCell.textField.borderStyle = .roundedRect
//        }
//      }
//      sender.title = "保存"
//    } else {
//      for cell in tableView.visibleCells {
//        if let editableCell = cell as? EditableDisplayCell {
//          editableCell.textField.isEnabled = false
//          editableCell.textField.borderStyle = .none
//        }
//      }
//      for cell in tableView.visibleCells {
//        if let editableCell = cell as? EditableDisplayCell {
//          editableCell.textField.isEnabled = false
//          editableCell.textField.borderStyle = .none
//        }
//      }
//      sender.title = "編集"
//    }
//
    
  }
  
  
  
  
  
  
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let editingTableViewController = segue.destination as? EditingTableViewController ?? EditingTableViewController()
    let section = indexPath.section
    let row = indexPath.row
    
    editingTableViewController.masterViewController = masterViewController
    editingTableViewController.firestore = firestore
    editingTableViewController.student = student
    
    switch section {
    case 0:
      editingTableViewController.field = name[row]
    case 1:
      editingTableViewController.field = backgrounds[row]
    case 2:
      editingTableViewController.field = contacts[row]
    case 3:
      editingTableViewController.field = classInfo[row]
    case 4:
      editingTableViewController.field = system[row]
    default:
      return
    }
    
  
    
  }
  
  
}
