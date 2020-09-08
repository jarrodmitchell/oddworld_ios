//
//  ResetPasswordViewController.swift
//  High Strangeness
//
//  Created by penguindrum on 9/6/20.
//  Copyright © 2020 penguindrum. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var labelErrorEmail: UILabel!
    
        
        @IBAction func sendResetRequestButtonTapped(_ sender: Any) {
            let email = textFieldEmail.text!
            if FormValidationUtility.validateEmail(email: email, labelErrorMessage: labelErrorEmail) {
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if let error = error {
                        print("Error sending reset request: " + error.localizedDescription)
                    }else{
                        print("Reset request sent successfully")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textFieldEmail.addTarget(self, action: #selector(textFieldTextChanged(_:)), for: .editingChanged)
    }
    
    @objc func textFieldTextChanged(_ textField: UITextField) {
        let email = textFieldEmail.text!;
        FormValidationUtility.validateEmail(email: email, labelErrorMessage: labelErrorEmail)
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
