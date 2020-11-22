//
//  FireService.swift
//  NXProfile
//
//  Created by Zhiren Jin on 2019/07/26.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import Foundation
import Firebase


class FireService {
//*****************************************************************
  var firestore: Firestore
  var storage: Storage
  var auth: Auth
  
  var postListener: ListenerRegistration
  var studentListener: ListenerRegistration
  var stateDidChangeListener: AuthStateDidChangeListenerHandle
//*****************************************************************
  init() {
    self.firestore = Firestore.firestore()
    self.storage = Storage.storage()
    self.auth = Auth.auth()
    
    self.postListener = firestore.collection(Key.post).addSnapshotListener({ (snapshot, error) in
      guard let snapshot = snapshot else {return}
      print("FB postListener: new snapshot at ~/post")
      var newPosts = [Post]()
      for document in snapshot.documents { newPosts.append(Post(data: document.data())) }
      NotificationCenter.default.post(name: .didUpdatePost, object: nil, userInfo: [Key.post: newPosts])
    })
    self.studentListener = firestore.collection(Key.student).order(by: Key.lastName_Hiragana).addSnapshotListener({ (snapshot, error) in
      guard let snapshot = snapshot else {return}
      print("FB studentListener: new snapshot at ~/student")
      var studentList = Preset.studentDictionary
      for document in snapshot.documents {
        let student = Student(data: document.data())
        studentList[student.key]?.append(student) }
      NotificationCenter.default.post(name: .didUpdateStudent, object: nil, userInfo: studentList)
    })
    self.stateDidChangeListener = Auth.auth().addStateDidChangeListener({ (auth, user) in
      if user?.email == nil {
        NotificationCenter.default.post(name: .showLogInView, object: nil)
      }
    })
  }
//*****************************************************************
  func reInit() {
    postListener.remove()
    studentListener.remove()
    auth.removeStateDidChangeListener(self.stateDidChangeListener)
    
    self.postListener = firestore.collection(Key.post).addSnapshotListener({ (snapshot, error) in
      guard let snapshot = snapshot else {return}
      print("FB postListener: new snapshot at ~/post")
      var newPosts = [Post]()
      for document in snapshot.documents { newPosts.append(Post(data: document.data())) }
      NotificationCenter.default.post(name: .didUpdatePost, object: nil, userInfo: [Key.post: newPosts])
    })
    self.studentListener = firestore.collection(Key.student).order(by: Key.lastName_Hiragana).addSnapshotListener({ (snapshot, error) in
      guard let snapshot = snapshot else {return}
      print("FB studentListener: new snapshot at ~/student")
      var studentList = Preset.studentDictionary
      for document in snapshot.documents {
        let student = Student(data: document.data())
        studentList[student.key]?.append(student) }
      NotificationCenter.default.post(name: .didUpdateStudent, object: nil, userInfo: studentList)
    })
    self.stateDidChangeListener = Auth.auth().addStateDidChangeListener({ (auth, user) in
      if user?.email == nil {
        NotificationCenter.default.post(name: .showLogInView, object: nil)
      }
    })
  }
//*****************************************************************
}
