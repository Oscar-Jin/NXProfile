//
//  MenuViewController.swift
//  Oshiego
//
//  Created by Zhiren Jin on 2019/07/12.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UITableViewController {
  var firestore: Firestore!
  var masterViewController: MasterViewController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: - Table view data source
  //
  //    override func numberOfSections(in tableView: UITableView) -> Int {
  //        // #warning Incomplete implementation, return the number of sections
  //        return 0
  //    }
  //
  //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  //        // #warning Incomplete implementation, return the number of rows
  //        return 0
  //    }
  
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
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      print("MenuVC: cell selected at", indexPath.section, indexPath.row)
      performSegue(withIdentifier: "showAddNewStudentSegue", sender: self)
      navigationController?.popViewController(animated: true)
    case 1:
      if indexPath.row == 0 {
        print("MenuVC: cell selected at", indexPath.section, indexPath.row)
        performSegue(withIdentifier: "showAddNewInstructorSegue", sender: self)
        navigationController?.popViewController(animated: true)
      }
    default:
      return
    }

  }
  
  @IBAction func logOutButtonTapped(_ sender: UIButton) {
    do {
      try Auth.auth().signOut()
    } catch {
      print(error)
    }
    navigationController?.popViewController(animated: true)
  }
  
  
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
    if segue.identifier == "showAddNewStudentSegue" {
      let addNewStudentViewController = segue.destination as! AddNewStudentViewController
      addNewStudentViewController.firestore = firestore
      addNewStudentViewController.masterViewController = masterViewController
    }
    if segue.identifier == "showAddNewInstructorSegue" {
      let addNewInstructorViewController = segue.destination as! AddNewInstructorViewController
      addNewInstructorViewController.firestore = firestore
    }
  }
  
  
}
