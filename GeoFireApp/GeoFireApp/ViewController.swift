//  Created by Edoardo de Cal on 10/20/19.
//  Copyright © 2019 Edoardo de Cal. All rights reserved.
//

import UIKit
import MapKit
import GeoFire
import CoreLocation
import FirebaseAuth


class ViewController: UIViewController, CLLocationManagerDelegate {

    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsBuildings = true
        mapView.showsLargeContentViewer = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let locationManager = CLLocationManager()
    
    var authEndResult: AuthDataResult!
    var fireRef = DatabaseReference()
    var geoRef: DatabaseReference!
    var geoFueg: GeoFire!
    var lastLocation: CLLocation!
    var fountainID = "Id"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMapView()
        authenticateUser()
        setupFirebase()
    }
    
    func setupFirebase() {
        fireRef = Database.database().reference()
        geoRef = Database.database().reference().child("motorists").childByAutoId()
        geoFueg = GeoFire(firebaseRef: geoRef)
    }
    
    func authenticateUser() {
        Auth.auth().signInAnonymously(completion: { (authResult, error) in
            if let error = error {
                print("Anon sign in faild:", error.localizedDescription)
            } else {
                self.authEndResult = authResult
                self.setLocationManager()
            }
            
        })
    }
    
    func setLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func getLocation() -> CLLocation {
        if let newLocation = locationManager.location {
            lastLocation = newLocation
            return newLocation
        } else {
            return lastLocation
        }
    }
    
    func setLocation() {
        let newLocation = getLocation()
        geoFueg.setLocation(CLLocation(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude), forKey: self.authEndResult.user.uid) { (error) in
            if (error != nil) {
                print("An error occured: \(error!)")
            } else {
                print("Saved location successfully")
            }
        }
    }
    

    func addMapView() {
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        let userLocation:CLLocation = locations[0] as CLLocation

        print("locations = \(userLocation)")
     
        guard let fountainID = geoRef.key else { return }
        
        geoFueg.setLocation(userLocation, forKey: fountainID) { (error) in
            if (error != nil) {
                print("An error occured: \(error!)")
            } else {
                print("Saved location successfully")
            }
        }
        
    }
    

}

