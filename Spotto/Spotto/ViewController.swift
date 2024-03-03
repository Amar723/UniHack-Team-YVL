//
//  ViewController.swift
//  Spotto
//
//  Created by Amarprit Singh on 1/3/2024.
//

import UIKit
import MapKit
import CoreLocation
import SwiftUI
import Foundation

protocol DropdownDelegate: AnyObject {
    func didSelectOption(_ option: String?)
}


let map = MKMapView()


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, DropdownDelegate {
    var button: UIButton!
    var selectedOption: String?

    

    let locationManager = CLLocationManager()
    let melbCoordinate = CLLocationCoordinate2D(
        latitude: -37.8102,
        longitude: 144.9628)
    
    
    
    // set to current location, ask permission for location
    
    // default location for Melbourne
    let coordinate = CLLocationCoordinate2D(
        latitude: -37.814,
        longitude: 144.96332)
    
    
    // used for preprocessing of the view
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(map)
        map.frame = view.bounds
        map.setRegion(MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(
                latitudeDelta: 0.1,
                longitudeDelta: 0.1)),
                      animated: false)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let dropdownVC = ReportViewController()
        dropdownVC.delegate = self
        
        map.delegate = self
        
        LocationManager.shared.getUserLocation { [weak self] location in
//            DispatchQueue.main.async {
//                guard let strongSelf = self else {
//                    return
//                }
                
                let annotation1 = MKPointAnnotation()
                annotation1.coordinate = location.coordinate
                annotation1.title = "User Location"
                annotation1.subtitle = "This is the user's current location"
                
                
                // Adding the annotation to the map
                map.addAnnotation(annotation1)
                
                // Centering the map on the user's location
                map.setRegion(MKCoordinateRegion(center: location.coordinate,
                                                            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)),
                                         animated: true)
            }
        
        
        
        // Create the button
        button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.frame = CGRect(x: 280, y: 740, width: 100, height: 100) // Adjust the frame as needed
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(button)
        view.bringSubviewToFront(button)
        //button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100)
    }
    
    
    @objc func buttonTapped() {
        // Create and present the overlay view controller modally
        let customPin = MKPointAnnotation()
        let ReportViewController1 = ReportViewController()

        //customPin.coordinate = CLLocationCoordinate2D(latitude: trainStationLat, longitude: trainStationLon)
        
        //customPin.coordinate = melbCoordinate
        customPin.title = "Myki Officer" // Use the title to identify the custom pin
        
            // Accessing the elements of the unwrapped tuple
//        let latitude = SharedData.StationCoordinates!.0
//        let longitude = SharedData.StationCoordinates!.1
            // Now you can use latitude and longitude
//        customPin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        
        
        map.addAnnotation(customPin)
        
        let reportViewController = ReportViewController()
        let navController = UINavigationController(rootViewController: reportViewController)
        self.present(navController, animated: true, completion: nil)
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let userCoordinate = location.coordinate
            //addCustomLocationPin(at: coordinate)
            
        }
    }
    
    func didSelectOption(_ option: String?) {
        selectedOption = option
        
        print("Selected Station (VIEWCONTROLLER): \(selectedOption ?? "None")")
    }
    
//    private func addCustomLocationPin(at coordinate: CLLocationCoordinate2D) {
//        let locationPin = MKPointAnnotation()
//        locationPin.coordinate = coordinate
//        locationPin.title = "Location"
//        locationPin.subtitle = "Your Location"
////        map.addAnnotation(locationPin)
//
//

//
//
//
//    func addCustomMykiPin(at coordinate: CLLocationCoordinate2D) {
//        let mykiPin = MKPointAnnotation()
//        // this coordinate needs to be changed to the coordinates of the train station
//        mykiPin.title = "Myki Officer Reported Here"
//        mykiPin.title = "Myki Officer"
//        mykiPin.subtitle = "Officer Reported"
//        map.addAnnotation(mykiPin)
//
//        // Timer will remove the annotation after 2 hours
//        Timer.scheduledTimer(withTimeInterval: 2 * 60 * 60, repeats: false) { [weak self] _ in
//            self?.map.removeAnnotation(mykiPin)
//        }
//    }
//
//
    
    //map
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MKPointAnnotation else {
            return nil
        }
        
        var annotationView: MKAnnotationView?
        
        if annotation.title == "Location" {
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomPin2") as? MKAnnotationView
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomPin2")
                annotationView!.canShowCallout = true
                annotationView!.image = UIImage(named: "drakob") // Set custom image 2
                annotationView!.image = UIImage(named: "drakob")?.scale(to: CGSize(width: 30, height: 30))
                
            } else {
                annotationView!.annotation = annotation

            }
        }
        
        if annotation.title == "Myki Officer" {
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomPin1") as? MKAnnotationView
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomPin1")
                annotationView!.canShowCallout = true
                annotationView!.image = UIImage(named: "PoliceOfficer") // Set custom image 1
                annotationView!.image = UIImage(named: "PoliceOfficer")?.scale(to: CGSize(width: 30, height: 30)) // Scale the image
            } else {
                annotationView!.annotation = annotation}}
        
        return annotationView
    }
}

extension UIImage {
    func scale(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
