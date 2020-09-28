//
//  AddProfilePictureViewController.swift
//  High Strangeness
//
//  Created by penguindrum on 9/7/20.
//  Copyright © 2020 penguindrum. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class AddProfilePictureViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func getSelectedImage(image: UIImage?) {
        print("here")
        if let _ = image {
            print("got image")
            imageViewProfilePicture.image = image
            self.setProfileImage()
        }
    }
    
    @IBOutlet weak var imageViewProfilePicture: UIImageView!
     
    let imagePickerController = UIImagePickerController()
    
    
    @IBAction func takePhotoButtonTapped(_ sender: Any) {
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true)
    }
    
    @IBAction func fromFileButtonTapped(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Image Picked")
        getSelectedImage(image: info[UIImagePickerController.InfoKey.originalImage] as? UIImage)
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        goToMainScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.isModalInPresentation = true
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.mediaTypes = ["public.image"]
    }
    
    func setProfileImage() {
        let storageReference = Storage.storage().reference()
            .child("images")
            .child("profileImages")
            .child((Auth.auth().currentUser?.uid ?? ""))
            .child("\(Auth.auth().currentUser?.uid ?? "").png")
        print("set profile image")
        if let uploadData = self.imageViewProfilePicture.image?.pngData() {
            print("\(Auth.auth().currentUser?.uid ?? "").png")
            let metadata = StorageMetadata.init();
            metadata.contentType = "image/png";
            storageReference.putData(uploadData, metadata: metadata) { (metadata, error) in
                print("come")
                if let error = error {
                    print("error " + error.localizedDescription)
                } else {
                    print("success adding profile picture")
                    self.goToMainScreen()
                    //                    storageRef.downloadURL(completion: { (url, error) in
                    //                        print(url?.absoluteString)
                    //                    })
                }
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
