//
//  FirstViewController.swift
//  High Strangeness
//
//  Created by penguindrum on 9/6/20.
//  Copyright © 2020 penguindrum. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var buttonAccount: UIBarButtonItem!
    
    private let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }


}

