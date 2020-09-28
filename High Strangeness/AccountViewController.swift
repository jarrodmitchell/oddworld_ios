//
//  AccountViewController.swift
//  High Strangeness
//
//  Created by penguindrum on 9/28/20.
//  Copyright © 2020 penguindrum. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol LoggedOut {
    func goToLogInScreen()
}

class AccountViewController: UIViewController {
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var imageViewProfilePic: UIImageView!
    
    var loggedOutListener:LoggedOut!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let userId = Auth.auth().currentUser?.uid
        if let userId = userId {
            getUsername(userId: userId)
            getProfilePic(userId: userId)
        }
        let email = Auth.auth().currentUser?.email
        
        labelEmail.text = email
        
        
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
                    self.labelUsername.text = username
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
    
    @IBAction func editProfileButtonTapped(_ sender: Any) {
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.loggedOutListener.goToLogInScreen()
        } catch  {
            print("error signing  out")
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
