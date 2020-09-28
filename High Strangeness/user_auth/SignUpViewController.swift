//
//  SignUpViewController.swift
//  High Strangeness
//
//  Created by penguindrum on 9/6/20.
//  Copyright © 2020 penguindrum. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var labelErrorEmail: UILabel!
    @IBOutlet weak var labelErrorUsername: UILabel!
    @IBOutlet weak var labelErrorPassword: UILabel!
    

        
        @IBAction func logInButtonTapped(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
        }
    

        
        @IBAction func signUpButtonTapped(_ sender: Any) {
            if validateSignUpValues() {
                let email = textFieldEmail.text!;
                let password = textFieldPassword.text!;
                let username =  textFieldUsername.text;
                Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                    if let error = error as NSError? {
                        switch AuthErrorCode(rawValue: error.code) {
                        case .emailAlreadyInUse:
                            self!.labelErrorEmail.text = "Email already in use"
                        case .weakPassword:
                            self!.labelErrorPassword.text = "Weak Password"
                        default:
                            self!.labelErrorEmail.text = "Internal Error Signing Up"
                            print("Error creating user: \(error.localizedDescription)")
                            print(error.code)
                        }
                    } else {
                        print("User signed up successfully")
                        
                        let db = Firestore.firestore()
                        let ref = db.collection("user")
                        let docId = ref.document().documentID
                        ref.document(docId).setData([
                            "username": username!
                        ]) { err in
                            if let error = error {
                                print("Error adding username: \(error.localizedDescription)")
                            }else{
                                print("Username added successfully")
                                self!.checkForCurrentUser()
                            }
                        }
                  }
                }
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.'
        textFieldEmail.addTarget(self, action: #selector(textFieldTextChanged(_:)), for: .editingChanged)
        textFieldUsername.addTarget(self, action: #selector(textFieldTextChanged(_:)), for: .editingChanged)
        textFieldPassword.addTarget(self, action: #selector(textFieldTextChanged(_:)), for: .editingChanged)
    }
    
    @objc func textFieldTextChanged(_ textField: UITextField) {
        
        switch textField {
        case textFieldEmail:
            let email = textFieldEmail.text!;
            FormValidationUtility.validateEmail(email: email, labelErrorMessage: labelErrorEmail)
            break;
        case textFieldUsername:
            let username = textFieldUsername.text ?? "";
            FormValidationUtility.validateUsername(username: username, labelErrorMessage: labelErrorUsername)
            break;
        case textFieldPassword:
            let password = textFieldPassword.text!;
            FormValidationUtility.validatePasswordCreation(password: password, labelErrorMessage: labelErrorPassword)
            break;
        default:
            break;
        }
    }
    
    func checkForCurrentUser() {
        let user = Auth.auth().currentUser
        if (user != nil) {
            print((user?.displayName ?? "username") as String)
            goToAddProfilePictureScreen()
        }
    }
    
    func goToAddProfilePictureScreen() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "signUpToAddProfilePicture", sender: self)
        }
    }
    
    func validateSignUpValues() -> Bool {
        let email = textFieldEmail.text!;
        let username = textFieldUsername.text ?? "ZZZZ";
        let password = textFieldPassword.text!;
        
        if FormValidationUtility.validateEmail(email: email, labelErrorMessage: labelErrorEmail) {
            return true;
        }else if FormValidationUtility.validateUsername(username: username, labelErrorMessage: labelErrorUsername) {
            return true;
        }else if FormValidationUtility.validatePassword(password: password, labelErrorMessage: labelErrorPassword) {
            return true;
        }
        return false;
    }
        
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("segue " + identifier)
        //        if identifier == "userAuthToMain" || "" {
        //            return true
        //        }
        return true
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
