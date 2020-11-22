//
//  ModalViewController.swift
//  Oshiego
//
//  Created by Zhiren Jin on 2019/07/15.
//  Copyright © 2019 Zhiren Jin. All rights reserved.
//

import UIKit
import Firebase

class ModalViewController: UIViewController {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var errorLabel: UILabel!
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var buttonView: UIView!
  @IBOutlet weak var loginButton: UIButton!
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    buttonView.layer.cornerRadius = buttonView.frame.width * 0.5
    passwordTextField.becomeFirstResponder()
  }
  
  @IBAction func logInButtonTapped(_ sender: UIButton) {
    Auth.auth().signIn(withEmail: "team@lacoms-next.com", password: passwordTextField.text ?? "") { (result, error) in
      if let error = error {
        self.errorLabel.text = error.localizedDescription
      } else {
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}



