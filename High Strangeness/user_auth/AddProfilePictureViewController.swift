//
//  AddProfilePictureViewController.swift
//  High Strangeness
//
//  Created by penguindrum on 9/7/20.
//  Copyright © 2020 penguindrum. All rights reserved.
//

import UIKit
import FirebaseAuth

class AddProfilePictureViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageViewProfilePicture: UIImageView!
    
        
        @IBAction func takePhotoButtonTapped(_ sender: Any) {
            
        }
    
        @IBAction func fromFileButtonTapped(_ sender: Any) {
             let pickerController = UIImagePickerController()
             pickerController.delegate = self
             pickerController.allowsEditing = true
             pickerController.mediaTypes = ["public.image"]
             pickerController.sourceType = .camera
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }
    
        @IBAction func skipButtonTapped(_ sender: Any) {
            goToMainScreen()
        }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.isModalInPresentation = true
    }
    
    func setProfileImage() {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.photoURL
        changeRequest?.commitChanges { (error) in
          // ...
            if let error = error {
                print("Error adding profile picture: \(error.localizedDescription)")
            }else{
                print("Profile picture added successfully")
                self.goToMainScreen()
            }
        }
    }
    
    func goToMainScreen() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "addProfilePictureToMain", sender: self)
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
