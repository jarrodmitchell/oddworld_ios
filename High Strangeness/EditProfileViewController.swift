//
//  EditProfileViewController.swift
//  High Strangeness
//
//  Created by penguindrum on 9/28/20.
//  Copyright © 2020 penguindrum. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var imageViewProfilePic: UIImageView!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonSaveChanges: UIButton!
    @IBOutlet weak var labelUsernameError: UILabel!
    
    let imagePickerController = UIImagePickerController()
    var uname: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let userId = Auth.auth().currentUser?.uid
        if let userId = userId {
            getUsername(userId: userId)
            getProfilePic(userId: userId)
        }
        let email = Auth.auth().currentUser?.email
        textFieldEmail.text = email
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.mediaTypes = ["public.image"]
        buttonSaveChanges.isHidden = true
        textFieldUsername.addTarget(self, action: #selector(textFieldTextChanged(_:)), for: .editingChanged)
    }
    
    @objc func textFieldTextChanged(_ textField: UITextField) {
        let username = textFieldUsername.text ?? "";
        FormValidationUtility.validateUsername(username: username, labelErrorMessage: labelUsernameError)
        if (uname != username) {
            buttonSaveChanges.isHidden = false
        }else{
            buttonSaveChanges.isHidden = true
        }
    }
    
    func getUsername(userId: String) {
        let db = Firestore.firestore()
        let doc = db.collection("user").document(userId)
        doc.getDocument { (snapshot, error) in
            if let error = error {
                print("error " + error.localizedDescription)
            }else{
                let username = snapshot?.data()!["username"] as? String
                if let username = username {
                    self.textFieldUsername.text = username
                    self.uname = username
                }
            }
        }
    }
    
    func getProfilePic(userId: String) {
        let storageRef = Storage.storage()
        let imageRef = storageRef.reference(withPath: "images/profileImages/" + userId + "/" + userId + ".png")
        imageRef.getData(maxSize: 112274450) { data, error in
          if let error = error {
            print("error " + error.localizedDescription)
          } else {
            // Data for "images/island.jpg" is returned
            let image = UIImage(data: data!)
            self.imageViewProfilePic.image = image
          }
        }
    }
    
    @IBAction func editProfilePictureButton(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    @IBAction func editEmailButtonTapped(_ sender: Any) {
        validatePassword(value:"email")
    }
    
    @IBAction func editPasswordButtonTapped(_ sender: Any) {
        validatePassword(value: "password")
    }
    
    @IBAction func saveChangesButtonTapped(_ sender: Any) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = textFieldUsername.text
        changeRequest?.commitChanges { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func setProfileImage() {
        let storageReference = Storage.storage().reference()
            .child("images")
            .child("profileImages")
            .child((Auth.auth().currentUser?.uid ?? ""))
            .child("\(Auth.auth().currentUser?.uid ?? "").png")
        print("set profile image")
        if let uploadData = self.imageViewProfilePic.image?.pngData() {
            print("\(Auth.auth().currentUser?.uid ?? "").png")
            let metadata = StorageMetadata.init();
            metadata.contentType = "image/png";
            storageReference.putData(uploadData, metadata: metadata) { (metadata, error) in
                print("come")
                if let error = error {
                    print("error " + error.localizedDescription)
                } else {
                    print("success adding profile picture")
                    //                    storageRef.downloadURL(completion: { (url, error) in
                    //                        print(url?.absoluteString)
                    //                    })
                }
            }
        }
    }
    
    func getSelectedImage(image: UIImage?) {
        print("here")
        if let _ = image {
            print("got image")
            imageViewProfilePic.image = image
            self.setProfileImage()
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Image Picked")
        getSelectedImage(image: info[UIImagePickerController.InfoKey.originalImage] as? UIImage)
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func validatePassword(value: String) {
        print("validate password for email")
        let dialogMessage = UIAlertController(title: "Enter Password", message: "Password cannot be empty", preferredStyle: .alert)
        dialogMessage.addTextField(configurationHandler: { textField in
            textField.placeholder = "Password"
        })
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("button tapped")
            if let password = dialogMessage.textFields?.first?.text {
                let passwordIsValid = FormValidationUtility.validatePasswordCreation(password: password, labelErrorMessage: nil)
                if passwordIsValid {
                    print("in")
                    dialogMessage.dismiss(animated: true, completion: nil)
                    self.reauthenticateUser(password: password, valueToBeChanged: value)
                }else{
                    self.validatePassword(value: value)
                }
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func reauthenticateUser(password: String, valueToBeChanged: String) {
        print("reathuenticate user")
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: user?.email ?? "", password: password)
        
        // Prompt the user to re-provide their sign-in credentials
        user?.reauthenticate(with: credential, completion: { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                self.validatePassword(value: valueToBeChanged)
            }else{
                if valueToBeChanged == "email" {
                    self.setEmail(message: "")
                }else if valueToBeChanged == "password" {
                    self.setPassword()
                }
            }
        })
    }
    
    func setPassword() {
        print("set password")
        let dialogMessage = UIAlertController(title: "Enter New Password", message: "Password must be at least 6 characters", preferredStyle: .alert)
        dialogMessage.addTextField(configurationHandler: { textField in
            textField.placeholder = "Password"
        })
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("button tapped")
            if let password = dialogMessage.textFields?.first?.text {
                let passwordIsValid = FormValidationUtility.validatePasswordCreation(password: password, labelErrorMessage: nil)
                if passwordIsValid {
                    Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
                        if let  error = error {
                            print(error.localizedDescription)
                            self.setEmail(message: "Invalid Email")
                        }else{
                            print("password changed")
                        }
                    })
                }else{
                    self.setPassword()
                }
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func setEmail(message: String) {
        print("set email")
        let dialogMessage = UIAlertController(title: "Enter New Email", message: message, preferredStyle: .alert)
        dialogMessage.addTextField(configurationHandler: { textField in
            textField.placeholder = "Email"
        })
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("button tapped")
            if let email = dialogMessage.textFields?.first?.text {
                let emailIsValid = FormValidationUtility.validateEmail(email: email, labelErrorMessage: nil)
                if emailIsValid {
                    Auth.auth().currentUser?.updateEmail(to: email) { (error) in
                        if let  error = error {
                            print(error.localizedDescription)
                            self.setEmail(message: "Invalid Email")
                        }else{
                            self.textFieldEmail.text = Auth.auth().currentUser?.email
                        }
                    }
                }else{
                    print("in")
                    self.setEmail(message: message)
                }
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
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
