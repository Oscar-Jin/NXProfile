//
//  RootViewController.swift
//  Oshiego
//
//  Created by Zhiren Jin on 2019/07/10.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit
import Firebase

protocol DataTransferDelegate_Student {
  func studentSelected(student: Student, from vc: MasterViewController)
}

protocol DataTransferDelegate_Post {
  func postsUpdated(posts: [Post])
}

protocol DismissViewDelegate {
  func dismissView()
}

protocol StudentDataUpdatedDelegate {
  func studentUpdated(newStudent: Student)
}

protocol StudentDataUpdatedDelegate2 {
  func studentUpdated(newStudent: Student)
}


class MasterViewController: UITableViewController {
  var listener1: ListenerRegistration!
  var listener2: ListenerRegistration!
  var firestore: Firestore!
  
  var handle: AuthStateDidChangeListenerHandle?
  
  var needToInitializeSelection = true
  var sectionTitle = ["あ","か","さ","た","な","は","ま","や","わ","#"]
  
  var list = [String: [Student]]() {
    didSet {
      self.tableView.reloadData()
    }
  }
  var student: Student!
  
  var posts = [Post]() {
    didSet {
      delegate2?.postsUpdated(posts: self.posts)
    }
  }
  
  var cuurentlySelectedIndexPath = IndexPath(row: 0, section: 0)
  
  var delegate1: DataTransferDelegate_Student?
  var delegate2: DataTransferDelegate_Post?
  var delegate3: StudentDataUpdatedDelegate?
  var delegate4: StudentDataUpdatedDelegate2?
  
  var dismissViewDelegate: DismissViewDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    self.clearsSelectionOnViewWillAppear = false
    
    let rightNaigationController = splitViewController?.viewControllers.last as! UINavigationController
    let detailViewController = rightNaigationController.viewControllers.first as! DetailViewController
    firestore = Firestore.firestore()
    detailViewController.firestore = firestore
    
    navigationItem.title = "Loading..."
    tableView.sectionIndexColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    
    handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
      if let email = user?.email {
        print(email, "is sigined in")
      } else {
        self.performSegue(withIdentifier: "showModalViewSegue", sender: self)
      }
    })
    
  
    
    listener1 = firestore.collection(Key.student).order(by: Key.lastName_Hiragana).addSnapshotListener { (snapshot, _) in
      guard let snapshot = snapshot else {return}
      var newList =  ["あ": [Student](), "か": [Student](), "さ": [Student](), "た": [Student](), "な": [Student](), "は": [Student](), "ま": [Student](), "や": [Student](), "ら": [Student](), "わ": [Student](), "#": [Student]()]
      
      for document in snapshot.documents {
        let student = Student(data: document.data())
        newList[student.key]?.append(student)
      }
      print(Date(), "new list retrived from Firestore")
      self.list = newList
      
      //TODO: unknown solution
      
      if self.list[self.sectionTitle[self.cuurentlySelectedIndexPath.section]]!.indices.contains(self.cuurentlySelectedIndexPath.row) == false {
        return
      }
      
      self.student = self.list[self.sectionTitle[self.cuurentlySelectedIndexPath.section]]![self.cuurentlySelectedIndexPath.row]
      self.delegate3?.studentUpdated(newStudent: self.student)
      self.delegate4?.studentUpdated(newStudent: self.student)
      
      self.navigationItem.title = "生徒一覧"
      
      self.initializeSelectionIfNeeded()
    }
  
    listener2 = firestore.collection(Key.post).addSnapshotListener({ (snapshot, _) in
      guard let snapshot = snapshot else {return}
      var newPosts = [Post]()
      for document in snapshot.documents {
        let post = Post(data: document.data())
        newPosts.append(post)
      }
      self.posts = newPosts
    })
    

    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    listener1.remove()
    listener2.remove()
 
    Auth.auth().removeStateDidChangeListener(handle!)
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
    student = list[sectionTitle[indexPath.section]]![indexPath.row]
    
    delegate1?.studentSelected(student: student, from: self)
    delegate2?.postsUpdated(posts: posts)
    
    cuurentlySelectedIndexPath = indexPath
    
    dismissViewDelegate?.dismissView()
    

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

   // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showMenuSegue" {
      let menuViewController = segue.destination as! MenuViewController
      menuViewController.firestore = firestore
      menuViewController.masterViewController = self
    }
  }

 
  
  func initializeSelectionIfNeeded() {
    if needToInitializeSelection {
      let indexPath = IndexPath(row: 0, section: 0)
      tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
      
      delegate1?.studentSelected(student: student, from: self)
      delegate2?.postsUpdated(posts: posts)
      
      self.needToInitializeSelection = false
    }
  }
  
}
