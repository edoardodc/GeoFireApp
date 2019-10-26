//  Created by Edoardo de Cal on 10/20/19.
//  Copyright © 2019 Edoardo de Cal. All rights reserved.
//

import UIKit
import MapKit
import GeoFire
import CoreLocation
import FirebaseAuth


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsBuildings = true
        mapView.showsLargeContentViewer = true
        mapView.showsUserLocation = false
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
        geoRef = Database.database().reference().child("Fountains")
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
    
    func setQuery(center: CLLocation, radius: Double) -> GFQuery {
        let query = geoFueg.query(at: center, withRadius: radius)
        return query
    }

    func addMapView() {
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation

        print("locations = \(userLocation)")
        
        guard let randomID = Database.database().reference().childByAutoId().key else { return }
        
        let location2D = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let geoHash = GFGeoHash(location: location2D)
        print(geoHash)
        
//        geoFueg.setLocation(userLocation, forKey: randomID) { (error) in
//            if (error != nil) {
//                print("An error occured: \(error!)")
//            } else {
//                print("Saved location successfully")
//            }
//        }
    
    }

    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
           let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        let centerLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        var radius = mapView.currentRadius()
        print("radius: ", radius)
        
        if radius > 5000 { return }
        
        setQuery(center: centerLocation, radius: 1).observe(.keyEntered, with: {(key: String!, location: CLLocation!) in
            guard let key = key else { return }
            print("Key: '\(key)' entered the search area and is at location '\(location!)'")
            self.addPin(location: location)
            print("Pin ADDED! \(key)")
            return
        })
    }
    
    func addPin(location: CLLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        mapView.addAnnotation(annotation)
    }
    

}
