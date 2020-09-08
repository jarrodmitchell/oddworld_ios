//
//  LogInViewController.swift
//  High Strangeness
//
//  Created by penguindrum on 9/6/20.
//  Copyright © 2020 penguindrum. All rights reserved.
//

import UIKit
import FirebaseAuth


class LogInViewController: UIViewController {
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var labelErrorEmail: UILabel!
    @IBOutlet weak var labelErrorPassword: UILabel!
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if validateLoginValues() {
            let email = textFieldEmail.text!;
            let password = textFieldPassword.text!;
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let error = error as NSError? {
                    switch AuthErrorCode(rawValue: error.code) {
                    case .invalidEmail:
                        self!.labelErrorEmail.text = "Invalid Email"
                    case .wrongPassword:
                        self!.labelErrorPassword.text = "Invalid Password"
                    default:
                        if error.code == 17011 {
                            self!.labelErrorEmail.text = "There is no record of this email"
                        }else{
                            self!.labelErrorEmail.text = "Internal Error Logging in"
                        }
                        print("Error: \(error.localizedDescription)")
                        print(error.code)
                    }
                } else {
//                    let userInfo = Auth.auth().currentUser
//                    let email = userInfo?.email
                    print("User signs in successfully")
                    self!.checkForCurrentUser()
              }
            }
        }
    }

    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "loginToResetPassword", sender: self)
        }
    }

    @IBAction func signUpButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "logInToSignUp", sender: self)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        checkForCurrentUser()
        textFieldEmail.addTarget(self, action: #selector(textFieldTextChanged(_:)), for: .editingChanged)
        textFieldPassword.addTarget(self, action: #selector(textFieldTextChanged(_:)), for: .editingChanged)
    }
    
    func checkForCurrentUser() {
        let user = Auth.auth().currentUser
        if (user != nil) {
            print((user?.displayName ?? "username") as String)
            goToMainScreen()
//            do {
//                try Auth.auth().signOut()
//            } catch  {
//                print("error signing  out")
//            }
            
        }
    }
    
    @objc func textFieldTextChanged(_ textField: UITextField) {
        switch textField {
        case textFieldEmail:
            let email = textFieldEmail.text!;
            FormValidationUtility.validateEmail(email: email, labelErrorMessage: labelErrorEmail)
            break;
        case textFieldPassword:
            let password = textFieldPassword.text!;
            FormValidationUtility.validatePassword(password: password, labelErrorMessage: labelErrorPassword)
            break;
        default:
            break;
        }
    }
    
    func validateLoginValues() -> Bool {
        let email = textFieldEmail.text!;
        let password = textFieldPassword.text!;
        
        if FormValidationUtility.validateEmail(email: email, labelErrorMessage: labelErrorEmail) {
            return true;
        }else if FormValidationUtility.validatePassword(password: password, labelErrorMessage: labelErrorPassword) {
            return true;
        }
        return false;
    }
    
    func goToMainScreen() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "logInToMain", sender: self)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("segue " + identifier)
//        if identifier == "logInToMain" || "" {
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
