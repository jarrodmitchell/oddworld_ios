//
//  FirstViewController.swift
//  High Strangeness
//
//  Created by penguindrum on 9/6/20.
//  Copyright © 2020 penguindrum. All rights reserved.
//

import UIKit
import GoogleMaps
import FirebaseAuth



class MapViewController: UIViewController, CLLocationManagerDelegate & LoggedOut {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var buttonAccount: UIBarButtonItem!
    
    private let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        checkForCurrentUser()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func checkForCurrentUser() {
        let user = Auth.auth().currentUser
        if (user != nil) {
            print((user?.displayName ?? "username") as String)
//            do {
//                try Auth.auth().signOut()
//            } catch  {
//                print("error signing  out")
//            }
            
        }else{
            goToLogInScreen()
        }
    }
    
    func goToLogInScreen() {
        print("log in")
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "mainToLogin", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToAccount" {
            print("prepared")
            if let destinationVC = segue.destination as? AccountViewController {
                destinationVC.loggedOutListener = segue.source as? LoggedOut
            }
        }else{
            print(segue.identifier)
        }
    }
    

}

