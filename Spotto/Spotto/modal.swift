import UIKit
import MapKit
import CoreLocation
import SwiftUI
import Foundation

class ReportViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    // Add UIPickerView and UITextField properties
    let stationPicker = UIPickerView()
    let stationTextField = UITextField()
    
    var selectedStation: String = ""
    weak var delegate: DropdownDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background color and title 86, 85, 90
        let mykiColour = UIColor(red: 86/255, green: 85/255, blue: 90/255, alpha: 1.0)
        view.backgroundColor = mykiColour
        
        title = "Myki Officer spotted"
        
        // Create and add location input (e.g., UITextField)
        let stationTextField = UITextField(frame: CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 40))
        
        stationTextField.placeholder = "Select station"
        stationTextField.borderStyle = .roundedRect
        stationTextField.inputView = stationPicker // Set the input view to the UIPickerView
        stationTextField.delegate = self // Set the text field delegate
        view.addSubview(stationTextField)
        
        // Setup UIPickerView
        stationPicker.delegate = self
        stationPicker.dataSource = self
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
        
        
        
        // Add any other interface elements as needed
    }
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

    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // Return the number of options in your dropdown
        return stations.count
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Return the title for each row in the dropdown
        return stations[row]
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let userCoordinate = location.coordinate
            //addCustomLocationPin(at: coordinate)
            
        }
    }
    
    // Implement the pickerView(_:didSelectRow:inComponent:) function
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Handle the selection of a row in the dropdown
        selectedStation = stations[row]
        // print(selectedStation)
        // Update your text field or perform any other actions based on the selection
        stationTextField.text = selectedStation
        if let trainCoordinates = train_stops[selectedStation] {
            
            //print(CLLocationCoordinate2D(latitude: lat, longitude: lon))
            //buttonTapped(coordinates: CLLocationCoordinate2D(latitude: lat, longitude: lon))
            
            let mykiPin = MKPointAnnotation()
            mykiPin.coordinate = CLLocationCoordinate2D(latitude: trainCoordinates.0, longitude: trainCoordinates.1)

            mykiPin.title = "Myki Officer"
            
            
            map.addAnnotation(mykiPin)
            print("PIN ADDED")
    

        }
        //print(trainCoordinates)
        delegate?.didSelectOption(selectedStation)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // This method is called whenever user edits characters in the field that has the drop down menu
            let searchStation = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        stationPicker.reloadAllComponents()
            return true
        }


    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            // You can initialize or update the pickerView's selected row when the text field begins editing
            // For example, set the selected row to the first option:
            stationPicker.selectRow(0, inComponent: 0, animated: false)
            
        }

    @objc func doneButtonTapped() {
        // Perform any finalization or dismiss the modal
        print("Selected Station (MODAL): \(stationTextField.text ?? "None")")
    

        dismiss(animated: true, completion: nil)
    }
    
    // Add yourDropdownOptions array to hold the dropdown options
    let stations = ["Alamein", "Albion", "Ascot Vale", "Ashburton", "Balaclava", "Baxter", "Bayswater", "Bentleigh", "Bonbeach", "Brighton Beach", "Broadmeadows", "Burnley", "Carnegie", "Caulfield", "Cheltenham", "Cranbourne", "Croydon", "Dennis", "Diamond Creek", "Diggers Rest", "Eaglemont", "East Camberwell", "East Malvern", "Epping", "Frankston", "Gardenvale", "Ginifer", "Glenbervie", "Glenferrie", "Greensborough", "Hallam", "Hartwell", "Heatherdale", "Heathmont", "Heyington", "Highett", "Holmesglen", "Hoppers Crossing", "Hurstbridge", "Kooyong", "Lalor", "Leawarra", "Melbourne Central", "Merinda Park", "Merri", "Middle Brighton", "Mitcham", "Montmorency", "Moorabbin", "Mooroolbark", "Moreland", "Murrumbeena", "Watergardens", "North Williamstown", "Nunawading", "Oakleigh", "Officer", "Parliament", "Pascoe Vale", "Patterson", "Regent", "Ringwood", "Riversdale", "Rosanna", "Sandringham", "Seaford", "Roxburgh Park", "St Albans", "Syndal", "Thornbury", "Tottenham", "Upper Ferntree Gully", "Upwey", "Watsonia", "West Richmond", "Willison", "South Morang", "Armadale", "Aspendale", "Belgrave", "Bittern", "Blackburn", "Boronia", "Brunswick", "Clifton Hill", "Coburg", "Collingwood", "Craigieburn", "Croxton", "Dandenong", "Elsternwick", "Eltham", "Fairfield", "Flagstaff", "Flemington Bridge", "Gardiner", "Glen Iris", "Glen Waverley", "Glenroy", "Heidelberg", "Hughesdale", "Huntingdale", "Jewell", "Jolimont", "Kananook", "Laburnum", "Laverton", "Lilydale", "Mentone", "Merlynston", "Middle Footscray", "Mont Albert", "Moonee Ponds", "Mordialloc", "Morradoo", "Mount Waverley", "Noble Park", "Northcote", "Ormond", "Pakenham", "Parkdale", "Prahran", "Reservoir", "Rushall", "Ruthven", "Seaholme", "Seddon", "Somerville", "Spotswood", "Springvale", "Strathmore", "Sunshine", "Toorak", "Tooronga", "Tyabb", "Upfield", "Wattle Glen", "Werribee", "Westall", "Westona", "Williamstown Beach", "Cardinia Road", "Williams Landing", "Aircraft", "Flemington Racecourse", "Showgrounds", "Southland", "Alphington", "Altona", "Anstey", "Auburn", "Batman", "Beaconsfield", "Bell", "Berwick", "Box Hill", "Burwood", "Camberwell", "Canterbury", "Carrum", "Chatham", "Chelsea", "Clayton", "Crib Point", "Darebin", "Darling", "East Richmond", "Edithvale", "Essendon", "Fawkner", "Ferntree Gully", "Flinders Street", "Footscray", "Glenhuntly", "Gowrie", "Hampton", "Hastings", "Hawksburn", "Hawthorn", "Ivanhoe", "Jacana", "Jordanville", "Kensington", "Keon Park", "Macaulay", "Macleod", "Malvern", "Mckinnon", "Narre Warren", "Newmarket", "Newport", "North Brighton", "North Melbourne", "North Richmond", "Oak Park", "Preston", "Keilor Plains", "Richmond", "Ringwood East", "Ripponlea", "Royal Park", "Sandown Park", "South Kensington", "South Yarra", "Southern Cross", "Stony Point", "Sunbury", "Surrey Hills", "Tecoma", "Thomastown", "Victoria Park", "West Footscray", "Westgarth", "Williamstown", "Windsor", "Yarraman", "Yarraville", "Coolaroo", "Lynbrook"
    ]

}
