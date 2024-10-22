//
//  select_location_via_name.swift
//  PathMark
//
//  Created by Dishant Rajput on 28/08/24.
//

import UIKit
import GoogleMaps
import GooglePlaces

class select_location_via_name: UIViewController,UITextFieldDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var userSelectOriginOrDestination:String!
    
    var placesClient: GMSPlacesClient!
    var predictions: [GMSAutocompletePrediction] = []
    
    var db:DBHelper = DBHelper()
    var persons:[Person] = []
    
    var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    var centerPinImageView: UIImageView!
    
    var selectedVehicleType:String!
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .black
            btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var txtSearchGoogleLocation:UITextField! {
        didSet {
            txtSearchGoogleLocation.placeholder = "Search here"
        }
    }
    
    @IBOutlet weak var btnSearchGoogle:UIButton!
    
    @IBOutlet weak var viewMainSearch:UIView! {
        didSet {
            viewMainSearch.layer.cornerRadius = 20
            viewMainSearch.clipsToBounds = true
            viewMainSearch.backgroundColor = .white
            viewMainSearch.layer.masksToBounds = false
            viewMainSearch.layer.shadowColor = UIColor.black.cgColor
            viewMainSearch.layer.shadowOffset =  CGSize.zero
            viewMainSearch.layer.shadowOpacity = 0.5
            viewMainSearch.layer.shadowRadius = 2
            viewMainSearch.layer.cornerRadius = 30
        }
    }
    
    @IBOutlet weak var tableViewForGoogleSearch:UITableView! {
        didSet {
            tableViewForGoogleSearch.delegate = self
            tableViewForGoogleSearch.dataSource = self
        }
    }
    
    @IBOutlet weak var btnAddLocation:UIButton! {
        didSet {
            btnAddLocation.backgroundColor = navigation_color
            btnAddLocation.setTitle("Confirm", for: .normal)
            btnAddLocation.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugPrint(self.userSelectOriginOrDestination as Any)
        
        // init place client
        placesClient = GMSPlacesClient.shared()
        
        
        self.txtSearchGoogleLocation.delegate = self
        
        self.initGoogleMap()
    }
    
    @objc func initGoogleMap() {
        // Set up mapView
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 10.0)
        mapView = GMSMapView(frame: self.view.bounds, camera: camera)
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        // Set up constraints for mapView
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Step 1: Add a static pin image view at the center of the map
        centerPinImageView = UIImageView(image: UIImage(named: "pin")) // Replace "pin" with your pin image name
        centerPinImageView.contentMode = .scaleAspectFit
        centerPinImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(centerPinImageView)
        
        // Center the pin image view in the map view
        NSLayoutConstraint.activate([
            centerPinImageView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            centerPinImageView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            centerPinImageView.widthAnchor.constraint(equalToConstant: 40), // Adjust width as needed
            centerPinImageView.heightAnchor.constraint(equalToConstant: 40) // Adjust height as needed
        ])
        
        // Set up location manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        self.view.bringSubviewToFront(self.viewMainSearch)
    }
    
    // Step 2: Track when the map starts moving
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let centerCoordinate = mapView.camera.target
        fetchLocationDetails(for: centerCoordinate)
    }
    
    // Step 3: Fetch Location Details (Lat, Long, and Address)
    func fetchLocationDetails(for coordinate: CLLocationCoordinate2D) {
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        
        debugPrint("Center location - Latitude: \(latitude), Longitude: \(longitude)")
        
        // Reverse Geocode to Get Address
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let error = error {
                print("Error while reverse geocoding: \(error.localizedDescription)")
                return
            }
            
            if let address = response?.firstResult() {
                let lines = address.lines ?? []
                let fullAddress = lines.joined(separator: ", ")
                
                debugPrint("Center location address: \(address)")
                
                debugPrint("Center location address: \(fullAddress)")
                
                
                if let country = address.country {
                    print("Country: \(country)")
                    
                    // Check if the country is Bangladesh
                    if country != "Bangladesh" {
                        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Service not available outside Bangladesh."), style: .alert)
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                        return
                    }
                    
                    // If the country is Bangladesh, now check for the city
                    if let city = address.locality {
                        print("City: \(city)")
                        
                        if city == "Dhaka" {
                            
                            if (self.selectedVehicleType == "CAR" || self.selectedVehicleType == "car" || self.selectedVehicleType == "Car") {
                                print("USER SELECT CAR")
                                UserDefaults.standard.set("\(latitude),\(longitude)", forKey: "key_map_view_lat_long")
                                UserDefaults.standard.set(fullAddress, forKey: "key_map_view_address")
                                
                                self.txtSearchGoogleLocation.text = String(fullAddress)
                                
                                // Optionally, add data to the database
                                let randomCGFloat = Int.random(in: 1...1000)
                                self.db.insert(id: randomCGFloat, name: fullAddress,
                                               lat_long: "\(latitude),\(longitude)",
                                               age: 2)
                                
                                self.view.bringSubviewToFront(self.btnAddLocation)
                            } else if (self.selectedVehicleType == "BIKE" || self.selectedVehicleType == "bike" || self.selectedVehicleType == "Bike") {
                                print("USER SELECT Bike")
                                UserDefaults.standard.set("\(latitude),\(longitude)", forKey: "key_map_view_lat_long")
                                UserDefaults.standard.set(fullAddress, forKey: "key_map_view_address")
                                
                                self.txtSearchGoogleLocation.text = String(fullAddress)
                                
                                // Optionally, add data to the database
                                let randomCGFloat = Int.random(in: 1...1000)
                                self.db.insert(id: randomCGFloat, name: fullAddress,
                                               lat_long: "\(latitude),\(longitude)",
                                               age: 2)
                                
                                self.view.bringSubviewToFront(self.btnAddLocation)
                            } else {
                                if (self.selectedVehicleType == "CAR" || self.selectedVehicleType == "car" || self.selectedVehicleType == "Car") {
                                    print("USER SELECT Intercity")
                                    
                                    let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please select different car type inside Dhaka. Please choose Intercity."), style: .alert)
                                    let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                                    alert.addButtons([cancel])
                                    self.present(alert, animated: true)
                                    
                                }
                            }
                            
                            // print("This place is in Dhaka, Bangladesh.")
                            
                        } else {
                            print("This place is NOT in Dhaka, Bangladesh.")
                            
                            if (self.selectedVehicleType == "CAR" || self.selectedVehicleType == "car" || self.selectedVehicleType == "Car") {
                                print("USER SELECT CAR")
                                let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Your selected location is out of our Car service."), style: .alert)
                                let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                                alert.addButtons([cancel])
                                self.present(alert, animated: true)
                            } else if (self.selectedVehicleType == "BIKE" || self.selectedVehicleType == "bike" || self.selectedVehicleType == "Bike") {
                                print("USER SELECT Bike")
                                let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Your selected location is out of our Bike service"), style: .alert)
                                let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                                alert.addButtons([cancel])
                                self.present(alert, animated: true)
                            } else {
                              
                                    
                                    if (self.selectedVehicleType == "Intercity" || self.selectedVehicleType == "INTERCITY" || self.selectedVehicleType == "intercity") {
                                        print("USER SELECT Intercity")
                                        
                                        print("Yes, all good")
                                        UserDefaults.standard.set("\(latitude),\(longitude)", forKey: "key_map_view_lat_long")
                                        UserDefaults.standard.set(fullAddress, forKey: "key_map_view_address")
                                        
                                        self.txtSearchGoogleLocation.text = String(fullAddress)
                                        
                                        // Optionally, add data to the database
                                        let randomCGFloat = Int.random(in: 1...1000)
                                        self.db.insert(id: randomCGFloat, name: fullAddress,
                                                       lat_long: "\(latitude),\(longitude)",
                                                       age: 2)
                                        
                                        self.view.bringSubviewToFront(self.btnAddLocation)
                                        
                                    }
                                    
                               
                            }
                            
                            
                            
                        }
                    } else {
                        print("City not found.")
                        /*let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("City not found. Please try again."), style: .alert)
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)*/
                        
                        if (self.selectedVehicleType == "CAR" || self.selectedVehicleType == "car" || self.selectedVehicleType == "Car") {
                            print("USER SELECT CAR")
                            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Your selected location is out of our Car service."), style: .alert)
                            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                            alert.addButtons([cancel])
                            self.present(alert, animated: true)
                        } else if (self.selectedVehicleType == "BIKE" || self.selectedVehicleType == "bike" || self.selectedVehicleType == "Bike") {
                            print("USER SELECT Bike")
                            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Your selected location is out of our Bike service"), style: .alert)
                            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                            alert.addButtons([cancel])
                            self.present(alert, animated: true)
                        } else {
                            if (self.selectedVehicleType == "Intercity" || self.selectedVehicleType == "INTERCITY" || self.selectedVehicleType == "intercity") {
                                print("USER SELECT Intercity")
                                
                                print("Yes, all good")
                                UserDefaults.standard.set("\(latitude),\(longitude)", forKey: "key_map_view_lat_long")
                                UserDefaults.standard.set(fullAddress, forKey: "key_map_view_address")
                                
                                self.txtSearchGoogleLocation.text = String(fullAddress)
                                
                                // Optionally, add data to the database
                                let randomCGFloat = Int.random(in: 1...1000)
                                self.db.insert(id: randomCGFloat, name: fullAddress,
                                               lat_long: "\(latitude),\(longitude)",
                                               age: 2)
                                
                                self.view.bringSubviewToFront(self.btnAddLocation)
                                
                            }
                        }
                        
                        
                        
                    }
                    
                } else {
                    print("Country not found.")
                    let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Something went wrong. Please try again."), style: .alert)
                    let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                    alert.addButtons([cancel])
                    self.present(alert, animated: true)
                }

                
                
                /*if let country = address.country {
                    print("Country: \(country)")
                    
                    if ("\(country)" == "Bangladesh") {
                        // Save data in UserDefaults
                        UserDefaults.standard.set("\(latitude),\(longitude)", forKey: "key_map_view_lat_long")
                        UserDefaults.standard.set(fullAddress, forKey: "key_map_view_address")
                        
                        self.txtSearchGoogleLocation.text = String(fullAddress)
                        
                        // Optionally, add data to the database
                        let randomCGFloat = Int.random(in: 1...1000)
                        self.db.insert(id: randomCGFloat, name: fullAddress,
                                       lat_long: "\(latitude),\(longitude)",
                                       age: 2)
                        
                        self.view.bringSubviewToFront(self.btnAddLocation)
                    } else {
                        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String(""), style: .alert)
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                        return;
                    }
                    
                    
                    
                    
                } else {
                    print("Country not found.")
                    return;
                }*/
                
                
                
                
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: 15.0)
            mapView.animate(to: camera)
            
            // Add marker at user's location
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                     longitude: location.coordinate.longitude)
            marker.title = "You are here"
            marker.map = mapView
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.tableViewForGoogleSearch.isHidden = false
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        searchPlaces(query: updatedText)
        return true
    }
    
    func searchPlaces(query: String) {
        if query.isEmpty {
            predictions = []
            // tableViewForGoogleSearch.isHidden = true
            // tableViewForGoogleSearch.reloadData()
            return
        }
        
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        // filter.countries = [countryCodeForGoogleSearch]
        
        
        placesClient.findAutocompletePredictions(fromQuery: query,
                                                 filter: filter,
                                                 sessionToken: nil) { (results, error) in
            
            if let error = error {
                print("Error finding places: \(error.localizedDescription)")
                return
            }
            
            // self.tableViewForGoogleSearch.isHidden = false
            self.predictions = results ?? []
            self.tableViewForGoogleSearch.isHidden = self.predictions.isEmpty
            self.view.bringSubviewToFront(self.tableViewForGoogleSearch)
            self.tableViewForGoogleSearch.reloadData()
            // self.tableViewForGoogleSearch.reloadData()
        }
    }
    
    
    // import GooglePlaces
    
    func getCoordinates(for placeID: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let placesClient = GMSPlacesClient.shared()
        
        placesClient.fetchPlace(fromPlaceID: placeID, placeFields: .coordinate, sessionToken: nil) { (place, error) in
            if let error = error {
                print("Error fetching place details: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            if let place = place {
                let coordinates = place.coordinate
                print("Latitude: \(coordinates.latitude), Longitude: \(coordinates.longitude)")
                completion(coordinates, nil)
            } else {
                completion(nil, NSError(domain: "Place not found", code: 404, userInfo: nil))
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    // Step 1: Handle Tap on the Map
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        // Step 2: Clear existing markers and add a new marker at the tapped location
        mapView.clear()
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
        
        // Step 3: Get the coordinates and perform actions
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        
        debugPrint("Tapped location - Latitude: \(latitude), Longitude: \(longitude)")
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let error = error {
                print("Error while reverse geocoding: \(error.localizedDescription)")
                return
            }
            
            if let address = response?.firstResult() {
                let lines = address.lines ?? []
                let fullAddress = lines.joined(separator: ", ")
                
                debugPrint("Tapped location address: \(fullAddress)")
                
                // Save data in UserDefaults
                UserDefaults.standard.set("\(latitude),\(longitude)", forKey: "key_map_view_lat_long")
                UserDefaults.standard.set(fullAddress, forKey: "key_map_view_address")
                
                self.txtSearchGoogleLocation.text = String(fullAddress)
                
                // Optionally, add data to the database
                let randomCGFloat = Int.random(in: 1...1000)
                self.db.insert(id: randomCGFloat, name: fullAddress,
                               lat_long: "\(latitude),\(longitude)",
                               age: 2)
                
                // Update marker's title with the address
                marker.title = fullAddress
                
                self.view.bringSubviewToFront(self.btnAddLocation)
            }
        }
        
        // Save data in UserDefaults
        
        
        //        // Optionally, add data to the database
        //        let randomCGFloat = Int.random(in: 1...1000)
        //        self.db.insert(id: randomCGFloat, name: "Selected Location",
        //                       lat_long: "\(latitude),\(longitude)",
        //                       age: 2)
    }
    
}

extension select_location_via_name: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.predictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:select_location_via_nameTableViewCell = tableView.dequeueReusableCell(withIdentifier: "select_location_via_nameTableViewCell") as! select_location_via_nameTableViewCell
        print(predictions[indexPath.row])
        
        let prediction = predictions[indexPath.row]
        cell.lblLocationName.text = prediction.attributedFullText.string
        // cell.lblLocationName.text = prediction.attributedFullText.string
        
        return cell
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        let prediction = predictions[indexPath.row]
        // print(prediction.placeID as Any)
        
        let placeID = prediction.placeID
        // print(placeID as Any)
        getCoordinates(for: placeID) { coordinates, error in
            if let error = error {
                // print("Error: \(error.localizedDescription)")
            } else if let coordinates = coordinates {
                // print("Latitude: \(coordinates.latitude), Longitude: \(coordinates.longitude)")
                
                debugPrint("\(coordinates.latitude),\(coordinates.longitude)")
                debugPrint(prediction.attributedFullText.string)
                
                UserDefaults.standard.set("\(coordinates.latitude),\(coordinates.longitude)", forKey: "key_map_view_lat_long")
                UserDefaults.standard.set(prediction.attributedFullText.string, forKey: "key_map_view_address")
                
                let randomCGFloat = Int.random(in: 1...1000)
                // print(randomCGFloat as Any)
                self.db.insert(id: randomCGFloat, name: prediction.attributedFullText.string,
                               lat_long: "\(coordinates.latitude),\(coordinates.longitude)",
                               age: 2)
                
                
                DispatchQueue.main.async {
                    self.view.endEditing(true)
                    self.tableViewForGoogleSearch.isHidden = true
                    self.mapView.clear() // Clear any existing markers
                    let marker = GMSMarker(position: coordinates)
                    marker.title = prediction.attributedFullText.string
                    marker.map = self.mapView
                    
                    // Center the map on the selected location
                    let cameraUpdate = GMSCameraUpdate.setTarget(coordinates)
                    self.mapView.animate(with: cameraUpdate)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.view.bringSubviewToFront(self.btnAddLocation)
                    // self.navigationController?.popViewController(animated: true)
                }
                
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

class select_location_via_nameTableViewCell: UITableViewCell {
    @IBOutlet weak var lblLocationName:UILabel!
}
