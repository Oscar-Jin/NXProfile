//
//  DetailTableViewController.swift
//  Oshiego
//
//  Created by Zhiren Jin on 2019/07/10.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class DetailViewController: UITableViewController, DataTransferDelegate_Student, DataTransferDelegate_Post, SaveButtonTappedDelegate, StudentDataUpdatedDelegate, SaveButtonTappedAtTextViewCellDelegate {




  
  // MARK: - Variables and References
  var masterViewController: MasterViewController!
  var listener: ListenerRegistration!
  var firestore: Firestore!
  var storage: Storage!
  
  
  var sectionTitle = ["Photo", "About Me", "Memo", "Stories"]
  var list = [[String]]()
  
  var posts = [Post]() {
    didSet {
      var postsforThisStudent = [Post]()
      for post in posts {
        if post.aboutWhom_ID == student?.documentID {
          postsforThisStudent.append(post)
        }
      }
      self.postsForThisStudent = postsforThisStudent
    }
  }
  
  var postsForThisStudent = [Post]() {
    didSet {
      tableView.reloadData()
    }
  }
  
  var student: Student! {
    
    didSet {
      // update list
      print("DetailViewVC: didset activated.")
      list = [["名前", self.student.fullName_Kanji + "\t\t" + self.student.fullName_Hiragana], ["年齢", self.student.age ?? "--"], ["誕生日", self.student.birthday_MonthAndDay ?? "--"], ["クラス", self.student.classLevel ?? "--"], ["詳しい生徒情報を見る", ">"]]
      loadViewIfNeeded()
      tableView.reloadData()
    }
  }
  
  
  // MARK: - View Life Cycle overrides
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let leftNavigationController = splitViewController?.viewControllers.first as? UINavigationController ?? UINavigationController()
    let masterViewController = leftNavigationController.viewControllers[0] as?  MasterViewController ?? MasterViewController()
    self.firestore = masterViewController.firestore
    
    masterViewController.delegate3 = self
    
    storage = Storage.storage()
  }

  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    print(Date(), "DetailVC: view will dissapear. data backup enabled.")
//    if firestore != nil && student != nil {
//      self.firestore.collection(Key.student).document(self.student.documentID).updateData([Key.note: note ?? ""])
//    }
  }
  
  
  // MARK: - Table View Overrides
  
  // return numbers of section
  override func numberOfSections(in tableView: UITableView) -> Int {
    return sectionTitle.count
  }
  
  // return numbers of row at each section
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return list.count
    case 2:
      return 1
    case 3:
      // TODO: set up array count
      return postsForThisStudent.count + 1
    default:
      return 1
    }
  }
  
  // set color for each header
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    if let headerView = view as? UITableViewHeaderFooterView {
      headerView.textLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
  }
  
  // set titles for each section
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionTitle[section]
  }
  
  // MARK: cellForRowAt
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let formater = DateFormatter()
    formater.dateStyle = .full
    formater.timeStyle = .long
    formater.locale = Locale(identifier: "ja_JP")
    
    
    switch indexPath.section {
      
    case 0:  // set up ImageViewCell
      let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as? ImageTableViewCell ?? ImageTableViewCell()
      cell.studentPhotoView.image = UIImage()
      
      if let studentPhotoURL = student?.studentPhotoURL {

        cell.studentPhotoView.sd_setImage(with: URL(string: studentPhotoURL), placeholderImage: #imageLiteral(resourceName: "loading"), options: .progressiveDownload) { (image, error, chache, url) in
          if let error = error {
            print("error found when loading image",error)
            cell.studentPhotoView.image = #imageLiteral(resourceName: "noImageFound")
          }
        }
      }
      return cell
      
    case 1:  // set up ContentViewCell
      if indexPath.row == list.count - 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisclosureCell", for: indexPath) as? ContentViewCell ?? ContentViewCell()
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentViewCell", for: indexPath) as? ContentViewCell ?? ContentViewCell()
        cell.descriptionLabel.text = list[indexPath.row][0]
        cell.contentLabel.text = list[indexPath.row][1]
        return cell
      }
      
    case 2:  // set up TextViewCell
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as? TextViewCell ?? TextViewCell()
    
      
      cell.textView.text = student?.note1 ?? ""
      cell.updatedLabel.text = formater.string(for: student?.note1_updatedOn)
      cell.delegate = self
      cell.masterViewController = masterViewController
      cell.student = student
      
      return cell
      
    case 3:  //set up PostingTableViewCell
      if indexPath.row == postsForThisStudent.count {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewPostTableViewCell", for: indexPath) as? AddNewPostTableViewCell ?? AddNewPostTableViewCell()
        return cell
        
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostingTableViewCell", for: indexPath) as? PostingTableViewCell ?? PostingTableViewCell()

        cell.delegate = self
        cell.post = postsForThisStudent[indexPath.row]
        
        cell.instructorImageView.image = UIImage(named: postsForThisStudent[indexPath.row].contributor_LastName)
        cell.textView.text = postsForThisStudent[indexPath.row].content
        cell.contributorNameLabel.text = postsForThisStudent[indexPath.row].contributor_LastName
        
        cell.createdLabel.text = formater.string(from: postsForThisStudent[indexPath.row].createdOn)
        cell.updatedLabel.text = formater.string(from: postsForThisStudent[indexPath.row].updatedOn)
        
//        cell.createdLabel.text = postsForThisStudent[indexPath.row].createdOn.description(with: Locale(identifier: "ja_JP"))
//        cell.updatedLabel.text = postsForThisStudent[indexPath.row].updatedOn.description(with: Locale(identifier: "ja_JP"))
        
        cell.masterViewController = masterViewController
        
        return cell
      }
      
    default:
      return UITableViewCell()
    }
  }
  
  // MARK: didSelectRowAt
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("cell selected at", indexPath.section, indexPath.row)
    
    //resing first responder for note ans post
    (tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? TextViewCell ?? TextViewCell()).textView?.resignFirstResponder()
    
    for i in 0...postsForThisStudent.count {
      print(i)
      (tableView.cellForRow(at: IndexPath(row: i, section: 3)) as? PostingTableViewCell ?? PostingTableViewCell()).textView?.resignFirstResponder()
    }
    
  
    
    if (indexPath.section == 1) && (indexPath.row == list.count - 1) {
      performSegue(withIdentifier: "ShowCompleteDataSegue", sender: nil)
    }
  }
  
  // MARK: - IBActions
  @IBAction func addImageButtonTapped(_ sender: UIButton) {
    presentImagePickerController()
  }
  
  
  
  // MARK: - Delegates
  func studentSelected(student: Student, from vc: MasterViewController) {
    self.student = student
    self.masterViewController = vc
    print("DetailTableVC: student data recieved")
  }
  
  func postsUpdated(posts: [Post]) {
    self.posts = posts
  }
  
  func saveButtonTapped(updatedContent: String, atPost: Post) {
    print("content was updated to", updatedContent)
    print("by writer", atPost.contributor_LastName)
    
    firestore.collection(Key.post).document(atPost.documentID).updateData([Key.content: updatedContent, Key.updatedOn: Date()])
  }
  
  func saveButtonTappedAtTextViewCell(updatedContent: String, forStudent: Student) {
    print("memo is about to updated to", updatedContent)
    firestore.collection(Key.student).document(forStudent.documentID).updateData([Key.note1: updatedContent, Key.note1_updatedOn: Date()])
  }
  
  
  func studentUpdated(newStudent: Student) {
    student = newStudent
  }
  
  
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowCompleteDataSegue" {
      if let completeDataViewController = segue.destination as? CompleteDataViewController {
        completeDataViewController.firestore = firestore
        completeDataViewController.masterViewController = masterViewController
        completeDataViewController.student = student
      }
    }
    
    if segue.identifier == "ShowInstructorSegue" {
      if let selectInstructorViewController = segue.destination as? SelectInstructorViewController {
        selectInstructorViewController.firestore = firestore
        selectInstructorViewController.student = student
        selectInstructorViewController.masterViewController = masterViewController
        selectInstructorViewController.detailViewController = self
      }
    }
  }
  
}


// MARK: - UIImagePicker
extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func presentImagePickerController() {
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
      let picker = UIImagePickerController()
      picker.sourceType = UIImagePickerController.SourceType.photoLibrary
      picker.delegate = self
      self.present(picker, animated: true, completion: nil)
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    self.dismiss(animated: true) {
      
      let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
      let imageTableViewCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ImageTableViewCell ?? ImageTableViewCell()
      let originalImage = imageTableViewCell.studentPhotoView.image
      
      let alert = UIAlertController(title: "写真をアップロードしますか？", message: "現在使用されている写真に上書します。", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "はい", style: .destructive, handler: { (_) in
        
        //diable selection
        self.masterViewController.tableView.isUserInteractionEnabled = false
        
        imageTableViewCell.studentPhotoView.image = #imageLiteral(resourceName: "loading")
        
        guard let imageData = image.resized(toWidth: 500)?.jpegData(compressionQuality: 0.8) else {return}
        
        let randomID = UUID.init().uuidString
        let path = "\(Key.studentsPhoto)/\(randomID).jpg"
        let oldImagePath = "\(Key.studentsPhoto)/\(self.student.studentPhotoID ?? "failSafe").jpg"
        
        let uploadRef = self.storage.reference(withPath: path)
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        
        var downloadURL = ""
        
        //put data in Firebase
        uploadRef.putData(imageData, metadata: uploadMetadata) { (data, error) in
          
          if let error = error {
            let errorAlert = UIAlertController(title: "エラー　Error", message: error.localizedDescription, preferredStyle: .alert)
            self.present(errorAlert, animated: true, completion: nil)
          } else {
            uploadRef.downloadURL(completion: { (url, error) in
              if let error = error {
                let errorAlert = UIAlertController(title: "エラー　Error", message: error.localizedDescription, preferredStyle: .alert)
                self.present(errorAlert, animated: true, completion: nil)
              } else {
                downloadURL = url?.absoluteString ?? ""
                print(downloadURL)
                
                self.firestore.collection(Key.student).document(self.student.documentID).updateData([Key.studentPhotoID: randomID])
                self.firestore.collection(Key.student).document(self.student.documentID).updateData([Key.studentPhotoURL : downloadURL])
                
                imageTableViewCell.studentPhotoView.image = image
                //imageTableViewCell.studentPhotoView.sd_setImage(with: URL(string: downloadURL), placeholderImage: #imageLiteral(resourceName: "loading"))
//                imageTableViewCell.studentPhotoView.sd_setImage(with: URL(string: downloadURL), placeholderImage: #imageLiteral(resourceName: "loading"), options: .progressiveDownload, completed: { (_, _, _, _) in
//                  self.masterViewController.tableView.isUserInteractionEnabled = true
//                  self.storage.reference(withPath: oldImagePath).delete(completion: nil)
//
//                })
                
                imageTableViewCell.studentPhotoView.sd_setImage(with: URL(string: downloadURL), placeholderImage: #imageLiteral(resourceName: "loading"), options: .progressiveDownload, completed: { (image, error, chache, url) in
                  if let error = error {
                    print("error found when loading image",error)
                    imageTableViewCell.studentPhotoView.image = #imageLiteral(resourceName: "noImageFound")
                  } else {
                    self.masterViewController.tableView.isUserInteractionEnabled = true
                    self.storage.reference(withPath: oldImagePath).delete(completion: nil)
                  }
                })
                
                
                
                
              }
            })
          }
          
          //TODO: enable selection
          
          
        }
      }))
      
      alert.addAction(UIAlertAction(title: "いいえ", style: .cancel, handler: { (_) in
        imageTableViewCell.studentPhotoView.image = originalImage
        //TODO: enable selection
        self.masterViewController.tableView.isUserInteractionEnabled = true
      }))
      
      self.present(alert, animated: true, completion: nil)
    }
    
    
    
  }
  
  
  
  
}




