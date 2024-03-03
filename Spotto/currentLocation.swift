import CoreLocation
import Foundation
import MapKit
import SwiftUI

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    

    let manager = CLLocationManager()
    
    @IBOutlet weak var myMapView: MKMapView?
    
    var completion: ((CLLocation) -> Void)?
    
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }

    public func locationManager(_ _manager: CLLocationManager, didUpdateLocations locations:
        [CLLocation]) {
        guard let location = locations.first else
        {return}
        
        completion?(location)
        manager.stopUpdatingLocation()
        
        
        //myMapView.showsUserLocation = true
        
    }
}


//struct ContentView: View {
//    
//    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//    
//    var body: some View {
//        Map(coordinateRegion: $region)
//            .ignoresSafeArea()
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
