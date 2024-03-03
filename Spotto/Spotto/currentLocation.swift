import CoreLocation
import Foundation

class locationManager: NSObject, CLLocationManagerDelegate {
    static let shared = locationManager()

    let manager = CLLocationManager()
    var completion: ((CLLocation) -> Void)?
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation
    }

    func locationManager(_manager: CLLocationManager, didUpdateLocations locations:
        [CLLocation]){
            guard let location = location.first else
            {return}
        }
        completion?(location)
        manager.stopUpdatingLocation()
}