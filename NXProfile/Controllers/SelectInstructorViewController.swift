//
//  SelectInstructorViewController.swift
//  Oshiego
//
//  Created by Zhiren Jin on 2019/07/14.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit
import Firebase

class SelectInstructorViewController: UITableViewController, DismissViewDelegate {
  
  var masterViewController: MasterViewController!
  var detailViewController: DetailViewController!
  
  var listener: ListenerRegistration!
  var firestore: Firestore!
  var student: Student!
  
  var list = [Instructor]() {
    didSet {
      self.tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let masterViewContorllor = splitViewController?.viewControllers.first?.children.first as? MasterViewController {
      masterViewContorllor.dismissViewDelegate = self
    }
    
    listener = firestore.collection(Key.instructor).order(by: Key.lastName_Hiragana).addSnapshotListener { (snapshot, _) in
      guard let snapshot = snapshot else {return}
      var newList = [Instructor]()
      
      for document in snapshot.documents {
        let instructor = Instructor(data: document.data())
        newList.append(instructor)
      }
      print(Date(), "new instructor list retrived from Firestore")
      self.list = newList
    }
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "InstructorTableViewCell", for: indexPath) as? InstructorTableViewCell ?? InstructorTableViewCell()
    let instructor = list[indexPath.row]
    cell.photoImageView.image = UIImage(named: instructor.lastName_Kanji)
    cell.nameLabel.text = instructor.lastName_Kanji
    cell.nameHiraganaLabel.text = instructor.lastName_Hiragana
    cell.birthdayLabel.text = "誕生日：" + instructor.birthday_MonthAndDay!
    
    return cell
  }
  
  func dismissView() {
    navigationController?.popViewController(animated: true)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    tableView.isUserInteractionEnabled = false
    
    let instructor = list[indexPath.row]
    let newPost: [String: Any] = [Key.aboutWhom_FirstName: student.firstName_Kanji, Key.aboutWhom_LastName: student.lastName_Kanji, Key.aboutWhom_ID: student.documentID, Key.content: "", Key.contributor_FirstName: instructor.firstName_Kanji, Key.contributor_LastName: instructor.lastName_Kanji, Key.contributor_ID: instructor.documentID, Key.createdOn: Date(), Key.updatedOn: Date()]
    
    let query = firestore.collection(Key.post).whereField(Key.aboutWhom_ID, isEqualTo: student.documentID).whereField(Key.contributor_FirstName, isEqualTo: newPost[Key.contributor_FirstName] ?? "").whereField(Key.contributor_LastName, isEqualTo: newPost[Key.contributor_LastName] ?? "")
    
    print("Data:")
    print(student.documentID)
    
    query.getDocuments { (snapshot, error) in
      if let snapshot = snapshot {
        print("is empty:")
        print(snapshot.documents.isEmpty)
        if snapshot.documents.isEmpty {
          print("new post can be added")
          print("will add", newPost[Key.contributor_LastName] ?? "", newPost[Key.contributor_FirstName] ?? "")
          
          
          let ref = self.firestore.collection(Key.post).addDocument(data: newPost)
          ref.updateData([Key.documentID: ref.documentID], completion: { (_) in
            print("will dismiss")
            
            var atRow = 0
            
            for post in self.detailViewController.postsForThisStudent {
              if post.contributor_ID == instructor.documentID {
                break
              }
              atRow += 1
            }
            
            let indexPath = IndexPath(row: atRow, section: 3)
            
            self.detailViewController.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            (self.detailViewController.tableView.cellForRow(at: indexPath) as? PostingTableViewCell ?? PostingTableViewCell()).textView.becomeFirstResponder()
            
            self.navigationController?.popViewController(animated: true)
          })
          
          
        } else {
          print("duplication found!")
          let alert = UIAlertController(title: "重複しています", message: "その講師による書き込みは既に存在しています。", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
          tableView.isUserInteractionEnabled = true
        }
        
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
  
}
