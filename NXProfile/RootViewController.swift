//
//  RootViewController.swift
//  Oshiego
//
//  Created by Zhiren Jin on 2019/07/10.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit
import Firebase

protocol DataTransferDelegate {
  func studentSelected(_ student: Student)
}

class MasterViewController: UITableViewController {
  var listener: ListenerRegistration!
  var firestore: Firestore!
  
  var sectionTitle = ["あ","か","さ","た","な","は","ま","や","わ","#"]
  var list = [String: [Student]]() {
    didSet {
      self.tableView.reloadData()
    }
  }
  
  var delegate: DataTransferDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.clearsSelectionOnViewWillAppear = false
    
    firestore = Firestore.firestore()
    navigationItem.title = "Loading..."
    tableView.sectionIndexColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    listener = firestore.collection(Key.student).order(by: Key.lastName_Hiragana).addSnapshotListener { (snapshot, _) in
      guard let snapshot = snapshot else {return}
      var newList =  ["あ": [Student](), "か": [Student](), "さ": [Student](), "た": [Student](), "な": [Student](), "は": [Student](), "ま": [Student](), "や": [Student](), "ら": [Student](), "わ": [Student](), "#": [Student]()]
      
      for document in snapshot.documents {
        let student = Student(data: document.data())
        newList[student.key]?.append(student)
      }
      
      print(newList)
      self.list = newList
      self.navigationItem.title = ""
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    listener.remove()
  }


  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return sectionTitle.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list[sectionTitle[section]]?.count ?? 0
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell ?? ListTableViewCell()
    
    cell.fullName_KanjiLabel.text = list[sectionTitle[indexPath.section]]?[indexPath.row].fullName_Kanji
    cell.fullName_HiraganaLabel.text = list[sectionTitle[indexPath.section]]?[indexPath.row].fullName_Hiragana
    return cell
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionTitle[section]
  }
  
  
  override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return sectionTitle
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("row selected")
    let student = list[sectionTitle[indexPath.section]]![indexPath.row]
    print(student)
    delegate?.studentSelected(student)
    if let detailTableVC = delegate as? DetailTableViewController {
      splitViewController?.showDetailViewController(detailTableVC, sender: self)
    }
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
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
